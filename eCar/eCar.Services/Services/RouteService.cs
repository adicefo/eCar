using MapsterMapper;
using Microsoft.SqlServer.Types;
using Nest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using eCar.Services.Helpers;
using System.Data.Entity.Spatial;
using NetTopologySuite.Geometries;
using eCar.Model.DTO;
using eCar.Model.SearchObjects;
using System.Data.Entity;
using eCar.Services.StateMachine.RouteStateMachine;
using Microsoft.Extensions.Logging;
using EFCore = Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace eCar.Services.Services

{
    public class RouteService : BaseCRUDService<Model.Model.Route,
        RouteSearchObject,Database.Route,RouteInsertRequest,RouteUpdateRequest>
        ,IRouteService
    {
        public ILogger<RouteService> _logger { get; set; }
        public BaseRouteState BaseRouteState { get; set; }
        public RouteService(ECarDbContext context, IMapper mapper,BaseRouteState baseRouteState,ILogger<RouteService> logger) :base(context,mapper)
        {
            BaseRouteState = baseRouteState;
            _logger = logger;
        }

        public override Model.Model.Route Insert(RouteInsertRequest request)
        {
            var state = BaseRouteState.CreateState("initial");
            return state.Insert(request);
        }

        public override Model.Model.Route Update(int id, RouteUpdateRequest request)
        {
            var entity=GetById(id);
            var state = BaseRouteState.CreateState(entity.Status);
            return state.Update(id, request);
        }
        //Using maually mapping to avoid Swagger documentation complexity of Point type
        public Model.Model.Route UpdateFinsih(int id)
        {
            var entity = GetById(id);
            var state=BaseRouteState.CreateState(entity.Status);
            return state.UpdateFinish(id);
        }
        public List<Enums.Action> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed actions called for: {id} ");
                
            if(id<=0)
            {
                var state = BaseRouteState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity= Context.Routes.Find(id);
                var state = BaseRouteState.CreateState(entity.Status);
                return state.AllowedActions(entity);
            }
        }
        public override IQueryable<Database.Route> AddFilter(RouteSearchObject search, IQueryable<Database.Route> query)
        {
            var filteredQuery=base.AddFilter(search, query);
            if (!string.IsNullOrWhiteSpace(search.Status))
                filteredQuery = filteredQuery.Where(x => x.Status == search.Status);
            if (!string.IsNullOrWhiteSpace(search.StatusNot))
                filteredQuery = filteredQuery.Where(x => x.Status!=search.StatusNot);
            if (search.ClientId.HasValue)
                filteredQuery = filteredQuery.Where(x => x.ClientId == search.ClientId);
            if (search.NumberOfKilometarsGTE != null)
                filteredQuery = filteredQuery.Where(x => x.NumberOfKilometars > search.NumberOfKilometarsGTE);
            return filteredQuery;
        }
        public override IQueryable<Database.Route> AddInclude(RouteSearchObject search, IQueryable<Database.Route> query)
        {
            var filteredQuery=base.AddInclude(search, query);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Client).ThenInclude(x=>x.User);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Driver).ThenInclude(x=>x.User);
            return filteredQuery;
        }
        public override List<Model.Model.Route> Map(List<Database.Route> list, List<Model.Model.Route> result)
        {
            var newResult= base.Map(list, result); 
            foreach (var item in list)
            {
                foreach (var item1 in newResult)
                {
                    if (item1.Id == item.Id)
                    {
                        item1.SourcePoint = item.SourcePoint != null ? new PointDTO(item.SourcePoint.X, item.SourcePoint.Y, item.SourcePoint.SRID) : null;
                        item1.DestinationPoint = item.DestinationPoint != null ? new PointDTO(item.DestinationPoint.X, item.DestinationPoint.Y, item.DestinationPoint.SRID) : null;
                        item1.Client = Mapper.Map(item.Client, item1.Client);
                        item1.Driver= Mapper.Map(item.Driver, item1.Driver);
                    }
                }
            }
            return newResult;
            
        }
        public override void BeforeInsert(RouteInsertRequest request, Database.Route entity)
        { 
            base.BeforeInsert(request, entity);
        }
        public override void BeforeUpdate(RouteUpdateRequest request, Database.Route entity)
        {
            base.BeforeUpdate(request, entity);
        }

        
    };

    

}
