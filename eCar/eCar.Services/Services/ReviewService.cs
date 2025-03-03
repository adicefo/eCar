using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using EFCore = Microsoft.EntityFrameworkCore;
using MapsterMapper;
using Nest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using eCar.Model.Helper;
using Microsoft.AspNetCore.Mvc;

namespace eCar.Services.Services
{
    public class ReviewService : BaseCRUDService<Model.Model.Review,
        ReviewSearchObject, Database.Review, ReviewInsertRequest, ReviewUpdateRequest>, IRevieweService
    {
        public ReviewService(ECarDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override Model.Model.Review GetById(int id)
        {
            var set = Context.Set<Database.Review>().AsQueryable();
            set = set.Include(x => x.Route);
            var entity = set.FirstOrDefault(c => c.Id == id);
            if (entity == null)
                throw new Exception("Non-existed entity");
            return Mapper.Map<Model.Model.Review>(entity);

        }
        public IActionResult GetForReport(ReviewReportRequest request)
        {
            //get all reviews in that period
            var reviews = Context.Reviews.Where(x => x.AddedDate != null &&
            x.AddedDate.Value.Year == request.Year &&
            x.AddedDate.Value.Month == request.Month);
            
            if(!reviews.Any())
            {
               return new OkObjectResult(new { maxDriver = "null",minDriver="null" });
            }

            //taker driver and his average mark
            var driverReviews = reviews
                        .GroupBy(x => new { x.Reviewed.User.Name,x.Reviewed.User.Surname})
                        .Select(group => new
                        {
                           DriverName = group.Key,
                           AvgMark = Math.Round((decimal)group.Average(x => x.Value),2)
                        }).ToList();

            //take max and min driver by mark
            var maxAvgDriver = driverReviews.MaxBy(x => x.AvgMark);
            var minAvgDriver = driverReviews.MinBy(x => x.AvgMark);

            return new OkObjectResult(new { maxDriver = maxAvgDriver, minDriver = minAvgDriver });

        }
        public override IQueryable<Review> AddFilter(ReviewSearchObject search, IQueryable<Review> query)
        {
            var filteredQuery= base.AddFilter(search, query);
            if(!string.IsNullOrWhiteSpace(search.ReviewedName))
                filteredQuery=filteredQuery.Where(x=>x.Reviewed.User.Name== search.ReviewedName);
            return filteredQuery;
        }

        public override IQueryable<Review> AddInclude(ReviewSearchObject search, IQueryable<Review> query)
        {
            var filteredQuery = base.AddInclude(search, query);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Reviewed).ThenInclude(x => x.User);          
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Reviews).ThenInclude(x => x.User);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Route);
            return filteredQuery;
        }
        public override void BeforeInsert(ReviewInsertRequest request, Review entity)
        {
            //prevent to review driver that did not serve you
            var route = Context.Routes.Where(x=>x.Client.Id==request.ReviewsId&&x.Driver.Id==request.ReviewedId).FirstOrDefault();
           if(route==null)
            {
                throw new UserException("Trying to review unexisted route");
            }
            entity.RouteId = route.Id;

            entity.AddedDate = DateTime.Now;

             base.BeforeInsert(request, entity);
        }

       
    }
}
