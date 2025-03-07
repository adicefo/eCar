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
                   
                   
                    Status ="wait",
                    CompanyPricesID=1,
                    ClientId=1,
                    DriverID=1,
                   


                },
                new Route()
                {
                    Id = 2,
                   
                   
                    Status = "wait",
                    CompanyPricesID = 2,
                    ClientId = 2,
                    DriverID = 1,
                  

                }, new Route()
                {
                    Id = 3,
                    
                    
                    Status = "wait",
                    CompanyPricesID = 3,
                    ClientId = 3,
                    DriverID = 2,
                   


                }, new Route()
                {
                    Id = 4,
                  
                    
                    Status = "wait",
                    CompanyPricesID = 3,
                    ClientId = 1,
                    DriverID = 2,
                  
                }, new Route()
                {
                    Id = 5,
                   
                    
                    Status = "wait",
                    CompanyPricesID = 3,
                    ClientId = 1,
                    DriverID = 3,
                  

                });


        }
    }
}
