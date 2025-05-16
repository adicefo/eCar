using eCar.Model.DTO;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NetTopologySuite.Geometries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class RouteData
    {
        public static void SeedData(this EntityTypeBuilder<Route> entity)
        {
            entity.HasData(
                new Route()
                {
                    Id = 1,
                    SourcePoint = new NetTopologySuite.Geometries.Point(-121.782024, 38.592187) { SRID=4326},
                    DestinationPoint = new Point(-121.793017, 37.910617) { SRID=4326},
                    Status ="wait",
                    CompanyPricesID=1,
                    ClientId=1,
                    DriverID=1,
                    NumberOfKilometars = 75.787m,
                    FullPrice = 3.0101m * 75.787m


                },
                new Route()
                {
                    Id = 2,
                    SourcePoint = new Point(-121.463208, 38.523458) { SRID = 4326 },
                    DestinationPoint = new Point(-120.935512, 37.519529) { SRID = 4326 },
                    Status = "wait",
                    CompanyPricesID = 2,
                    ClientId = 2,
                    DriverID = 1,
                    NumberOfKilometars = 120.823m,
                    FullPrice = 3.05m * 120.823m

                }, new Route()
                {
                    Id = 3,
                    SourcePoint = new Point(-121.221347, 37.893279) { SRID = 4326 },
                    DestinationPoint = new Point(-122.375726, 37.641422) { SRID = 4326 },
                    Status = "wait",
                    CompanyPricesID = 3,
                    ClientId = 3,
                    DriverID = 2,
                    NumberOfKilometars = 105.263m,
                    FullPrice = 3.07m * 105.263m


                }, new Route()
                {
                    Id = 4,

                    SourcePoint = new Point(-121.485239, 38.557831) { SRID = 4326 },
                    DestinationPoint = new Point(-119.745856, 36.600094) { SRID = 4326 },
                    Status = "wait",
                    CompanyPricesID = 3,
                    ClientId = 1,
                    DriverID = 2,
                    NumberOfKilometars = 266.227m,
                    FullPrice = 3.07m * 266.227m,

                }, new Route()
                {
                    Id = 5,
                    SourcePoint = new Point(-121.913084, 37.321893) { SRID=4326},
                    DestinationPoint = new Point(-122.051879, 37.344823) { SRID=4326},
                    Status = "wait",
                    CompanyPricesID = 3,
                    ClientId = 1,
                    DriverID = 3,
                    NumberOfKilometars = 12.533m,
                    FullPrice = 3.07m * 12.533m
                    
                },
                 new Route()
                 {
                     Id = 6,
                     SourcePoint = new Point(-122.474006, 37.676212) { SRID = 4326 },
                     DestinationPoint = new Point(-122.354379, 37.536138) { SRID = 4326 },
                     Status = "finished",
                     CompanyPricesID = 3,
                     ClientId = 1,
                     DriverID = 4,
                     NumberOfKilometars = 16.1311m,
                     FullPrice = 3.07m * 16.1311m

                 },
                  new Route()
                  {
                      Id = 7,
                      SourcePoint = new Point(-122.440116, 37.528152) { SRID = 4326 },
                      DestinationPoint = new Point(-122.264319, 37.491704) { SRID = 4326 },
                      Status = "finished",
                      CompanyPricesID = 3,
                      ClientId = 2,
                      DriverID = 3,
                      NumberOfKilometars = 16.027m,
                      FullPrice = 3.07m * 16.027m

                  }, new Route()
                  {
                      Id = 8,
                      SourcePoint = new Point(-122.425499, 37.765920) { SRID = 4326 },
                      DestinationPoint = new Point(-122.433732, 37.665976) { SRID = 4326 },
                      Status = "finished",
                      CompanyPricesID = 3,
                      ClientId = 1,
                      DriverID = 1,
                      NumberOfKilometars = 11.137m,
                      FullPrice = 3.07m * 11.137m

                  }, new Route()
                  {
                      Id = 9,
                      SourcePoint = new Point(-121.881457, 37.281884) { SRID = 4326 },
                      DestinationPoint = new Point(-122.013187, 36.962146) { SRID = 4326 },
                      Status = "finished",
                      CompanyPricesID = 3,
                      ClientId = 1,
                      DriverID = 1,
                      NumberOfKilometars = 37.422m,
                      FullPrice = 3.07m * 37.422m

                  });


        }
    }
}
