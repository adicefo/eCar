using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using EFCore = Microsoft.EntityFrameworkCore;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using eCar.Model.Helper;

namespace eCar.Services.Services
{
    public class RequestService:BaseCRUDService<Model.Model.Request,
        RequestSearchObject,Database.Request,RequestInsertRequest,RequestUpdateRequest>,IRequestService
    {
        public RequestService(ECarDbContext context,IMapper mapper):base(context,mapper)
        {
            
        }

        public override IQueryable<Request> AddFilter(RequestSearchObject search, IQueryable<Request> query)
        {
            var filteredQuery = base.AddFilter(search, query);
            var driver = Context.Drivers.Find(search.DriverId);
            var route = Context.Routes.Find(search.RouteId);
            if (driver != null)
                filteredQuery = filteredQuery.Where(x => x.DriverId == search.DriverId);
            if (route != null)
                filteredQuery = filteredQuery.Where(x => x.RouteId == search.RouteId);
            if (search?.IsAccepted != null)
                filteredQuery = filteredQuery.Where(x =>search.IsAccepted==x.IsAccepted);
            //important condition
            if(search?.IsAccepted==null&&search.RouteId==null&&search?.DriverId!=null)
                filteredQuery=filteredQuery.Where(x=>x.DriverId==search.DriverId&&x.IsAccepted==null);

            return filteredQuery;
        }
        public override IQueryable<Request> AddInclude(RequestSearchObject search, IQueryable<Request> query)
        {

            var filteredQuery = base.AddInclude(search, query);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Driver).ThenInclude(x => x.User);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Route).ThenInclude(x=>x.Client).ThenInclude(x=>x.User);
            return filteredQuery;
        }
        public override void BeforeInsert(RequestInsertRequest request, Request entity)
        {
            var route = Context.Routes.Include(x => x.Client).
                ThenInclude(x => x.User).FirstOrDefault(x => x.Id == entity.RouteId);
            var driver=Context.Drivers.Include(x=>x.User).FirstOrDefault(x=>x.Id == entity.DriverId);
            if (route == null || driver == null)
                throw new UserException("Invalid route or driver inserted");
            entity.Route = route;
            entity.Driver = driver;
        }

        public override void BeforeUpdate(RequestUpdateRequest request, Request entity)
        {
            var route = Context.Routes.Include(x => x.Client).ThenInclude(x => x.User).FirstOrDefault(x => x.Id == entity.RouteId);
            if (entity.IsAccepted == true)
                route!.Status = "active";
            else
                route!.Status = "finished";
                
        }

    }
}
