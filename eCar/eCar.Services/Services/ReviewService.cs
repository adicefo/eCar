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
            var route = Context.Routes.Find(request.RouteId);
            if (route == null)
                throw new UserException("Trying to review unexisted Route");
            if (route.ClientId != entity.ReviewsId || route.DriverID != entity.ReviewedId)
                throw new UserException("Wrong user or driver used");


            base.BeforeInsert(request, entity);
        }
    }
}
