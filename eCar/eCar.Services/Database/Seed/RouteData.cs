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
                    
                });


        }
    }
}
