using eCar.Model.Requests;
using eCar.Services.Database;
using eCar.Services.Helpers;
using MapsterMapper;
using NetTopologySuite.Geometries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.StateMachine.RouteStateMachine
{
    public class InitialRouteState:BaseRouteState
    {
        
        public InitialRouteState(ECarDbContext context, IMapper mapper,IServiceProvider serviceProvider):
            base(context,mapper,serviceProvider)
        {
          
        }
        public override Model.Model.Route Insert(RouteInsertRequest request)
        {
            var set = Context.Set<Route>();
            var entity = Mapper.Map <Database.Route>(request);

            var client = Context.Clients.Find(request.ClientId);
            var driver = Context.Drivers.Find(request.DriverID);
            if (client == null || driver == null)
                throw new Exception("Driver or client cannot be null");

            if (request.SourcePoint == null || request.DestinationPoint == null)
                throw new Exception("Source point or Destionation point cannnot be null");

            // I have done manually mapping because of different data types between RequestClass and Model/Database Class
            var distanceMeters = DistanceGenerate.GetDistance(request.SourcePoint.Longitude,
                                 request.SourcePoint.Latitude, request.DestinationPoint.Longitude, request.DestinationPoint.Latitude);

            var SourcePoint = new Point(request.SourcePoint.Longitude, request.SourcePoint.Latitude) { SRID = request.SourcePoint.SRID };
            var DestinationPoint = new NetTopologySuite.Geometries.Point(request.DestinationPoint.Longitude, request.DestinationPoint.Latitude) { SRID = request.SourcePoint.SRID };

            var lastPrice = Context.CompanyPrices.OrderByDescending(x => x.Id).FirstOrDefault();

            entity.SourcePoint = SourcePoint;
            entity.DestinationPoint = DestinationPoint;
            entity.NumberOfKilometars = (decimal)distanceMeters / 1000;
            entity.FullPrice = entity.NumberOfKilometars * lastPrice?.PricePerKilometar;
            
            entity.Status = "wait";

            entity.ClientId = request.ClientId;
            entity.DriverID = request.DriverID;
            entity.Client = client;
            entity.Driver = driver;
            entity.CompanyPricesID = lastPrice!.Id;

            set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map< Model.Model.Route>(entity);
        }

        public override List<Enums.Action> AllowedActions(Route entity)
        {
            return new List<Enums.Action> { Enums.Action.Insert};
        }
    }
}
