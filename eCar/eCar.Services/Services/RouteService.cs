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

namespace eCar.Services.Services

{
    public class RouteService : IRouteService
    {
       public ECarDbContext Context { get; set; }
       public IMapper Mapper { get; set; }
       public RouteService(ECarDbContext context,IMapper mapper)
       {
           Context = context;
           Mapper = mapper;
       }
       //Using maually mapping to avoid Swagger documentation complexity of Point type
       public List<Model.Model.Route> GetRoutes(RouteSearchObject searchObject)
       {
           
            var query = Context.Routes.AsQueryable();
            if (!string.IsNullOrWhiteSpace(searchObject?.Status))
                query = query.Where(x => x.Status==searchObject.Status);
            if (searchObject.NumberOfKilometarsGTE!=null)
                query = query.Where(x => x.NumberOfKilometars>=searchObject.NumberOfKilometarsGTE);
            if (searchObject?.Page.HasValue == true && searchObject?.PageSize.HasValue == true)
                query = query.Skip(searchObject.Page.Value * searchObject.PageSize.Value)
                   .Take(searchObject.PageSize.Value);
            var list = query.ToList();


            var result = new List<Model.Model.Route>();

            list.ForEach(item =>
            {
                result.Add(new Model.Model.Route()
                {
                    Id = item.Id,
                    SourcePoint = item.SourcePoint != null ? new PointDTO(item.SourcePoint.X, item.SourcePoint.Y, item.SourcePoint.SRID) : null,
                    DestinationPoint = item.DestinationPoint != null ? new PointDTO(item.DestinationPoint.X, item.DestinationPoint.Y, item.DestinationPoint.SRID) : null,
                    StartDate = item.StartDate,
                    EndDate = item.EndDate,
                    Duration = item.Duration,
                    NumberOfKilometars = item.NumberOfKilometars,
                    FullPrice = item.FullPrice,
                    Status = item.Status,
                    ClientId=item.ClientId,
                    DriverID=item.DriverID
                });
            });
          
            return result;
       }
        //Using maually mapping to avoid Swagger documentation complexity of Point type
        public Model.Model.Route Insert(RouteInsertRequest request)
        {
            var client=Context.Clients.Find(request.ClientId);
            var driver=Context.Drivers.Find(request.DriverID);
            

            if (client ==null||driver == null)
                throw new Exception("Driver or client cannot be null");
           
            Database.Route entity=new Database.Route();


            
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

            entity.ClientId= request.ClientId;
            entity.DriverID= request.DriverID;
            entity.CompanyPricesID = lastPrice!.Id;
         
            Context.Routes.Add(entity);
            Context.SaveChanges();

            //Manually maping because of different data types POINT and POINTDTO
            var result = Mapper.Map<Model.Model.Route>(entity);
            result.SourcePoint.Longitude = entity.SourcePoint.X;
            result.SourcePoint.Latitude= entity.SourcePoint.Y;
            result.SourcePoint.SRID= entity.SourcePoint.SRID;
            result.DestinationPoint.Longitude= entity.DestinationPoint.X;
            result.DestinationPoint.Latitude= entity.DestinationPoint.Y;
            result.DestinationPoint.SRID = entity.DestinationPoint.SRID;
            return result;

        }
        //Using maually mapping to avoid Swagger documentation complexity of Point type
        public Model.Model.Route UpdateBegin(int id)
        {
            var entity = Context.Routes.Find(id);
            if (entity == null)
                throw new Exception("Non-existed route");

            entity.StartDate= DateTime.Now;
            entity.Status = "active";

            Context.Routes.Update(entity);
            Context.SaveChanges();

            var result = Mapper.Map<Model.Model.Route>(entity);
            result.SourcePoint.Longitude = entity.SourcePoint.X;
            result.SourcePoint.Latitude = entity.SourcePoint.Y;
            result.SourcePoint.SRID = entity.SourcePoint.SRID;
            result.DestinationPoint.Longitude = entity.DestinationPoint.X;
            result.DestinationPoint.Latitude = entity.DestinationPoint.Y;
            result.DestinationPoint.SRID = entity.DestinationPoint.SRID;
            return result;
        }

        //Using maually mapping to avoid Swagger documentation complexity of Point type
        public Model.Model.Route UpdateFinsih(int id)
        {
            var entity= Context.Routes.Find(id);
            if (entity == null)
                throw new Exception("Non-existed route");

            entity.EndDate= DateTime.Now;
            entity.Duration = (int)(entity.EndDate.Value - entity.StartDate!.Value).TotalMinutes;
            entity.Status = "finished";

            Context.Routes.Update(entity);
            Context.SaveChanges();

            var result = Mapper.Map<Model.Model.Route>(entity);
            result.SourcePoint!.Longitude = entity.SourcePoint!.X;
            result.SourcePoint.Latitude = entity.SourcePoint.Y;
            result.SourcePoint.SRID = entity.SourcePoint.SRID;
            result.DestinationPoint!.Longitude = entity.DestinationPoint!.X;
            result.DestinationPoint.Latitude = entity.DestinationPoint.Y;
            result.DestinationPoint.SRID = entity.DestinationPoint.SRID;
            return result;
        }
    };

    

}
