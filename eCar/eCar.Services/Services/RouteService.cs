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

namespace eCar.Services.Services

{
    public class RouteService : BaseCRUDService<Model.Model.Route,
        RouteSearchObject,Database.Route,RouteInsertRequest,RouteUpdateRequest>
        ,IRouteService
    {
        public BaseRouteState BaseRouteState { get; set; }
        public RouteService(ECarDbContext context, IMapper mapper,BaseRouteState baseRouteState) :base(context,mapper)
        {
            BaseRouteState = baseRouteState;
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
        public override IQueryable<Database.Route> AddFilter(RouteSearchObject search, IQueryable<Database.Route> query)
        {
            var filteredQuery=base.AddFilter(search, query);
            if (!string.IsNullOrWhiteSpace(search.Status))
                filteredQuery = filteredQuery.Where(x => x.Status == search.Status);
            if (search.NumberOfKilometarsGTE != null)
                filteredQuery = filteredQuery.Where(x => x.NumberOfKilometars > search.NumberOfKilometarsGTE);
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
          //  var client = Context.Clients.Find(request.ClientId);
          //  var driver = Context.Drivers.Find(request.DriverID);
          //  if (client == null || driver == null)
          //      throw new Exception("Driver or client cannot be null");
          //
          //  if (request.SourcePoint == null || request.DestinationPoint == null)
          //      throw new Exception("Source point or Destionation point cannnot be null");
          //
          //  // I have done manually mapping because of different data types between RequestClass and Model/Database Class
          //  var distanceMeters = DistanceGenerate.GetDistance(request.SourcePoint.Longitude,
          //                       request.SourcePoint.Latitude, request.DestinationPoint.Longitude, request.DestinationPoint.Latitude);
          //
          // var SourcePoint = new Point(request.SourcePoint.Longitude, request.SourcePoint.Latitude) { SRID = request.SourcePoint.SRID };
          //  var DestinationPoint = new NetTopologySuite.Geometries.Point(request.DestinationPoint.Longitude, request.DestinationPoint.Latitude) { SRID = request.SourcePoint.SRID };
          //
          //  var lastPrice = Context.CompanyPrices.OrderByDescending(x => x.Id).FirstOrDefault();
          //
          //  entity.SourcePoint = SourcePoint;
          //  entity.DestinationPoint = DestinationPoint;
          //  entity.NumberOfKilometars = (decimal)distanceMeters / 1000;
          //  entity.FullPrice = entity.NumberOfKilometars * lastPrice?.PricePerKilometar;
          //  entity.Status = "wait";
          //
          //  entity.ClientId = request.ClientId;
          //  entity.DriverID = request.DriverID;
          //  entity.Client = client;
          //  entity.Driver = driver;
          //  entity.CompanyPricesID = lastPrice!.Id;
            base.BeforeInsert(request, entity);
        }
        public override void BeforeUpdate(RouteUpdateRequest request, Database.Route entity)
        {
           // entity.StartDate = DateTime.Now;
           // entity.Status = "active";
            base.BeforeUpdate(request, entity);
        }
    };

    

}
