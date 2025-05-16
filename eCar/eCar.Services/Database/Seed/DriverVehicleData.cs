using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Nest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class DriverVehicleData
    {
        public static void SeedData(this EntityTypeBuilder<DriverVehicle> entity)
        {
            entity.HasData(
                new DriverVehicle()
                {
                    Id=1,
                   DatePickUp=DateTime.Now.AddDays(-10),
                   DateDropOff=DateTime.Now.AddDays(-10),
                   VehicleId=1,
                   DriverId=1,
                   
                },
                new DriverVehicle()
                {
                    Id = 2,
                    DatePickUp = DateTime.Now.AddDays(-10),
                    DateDropOff = DateTime.Now.AddDays(-10),
                    VehicleId = 4,
                    DriverId = 2,

                }, new DriverVehicle()
                {
                    Id = 3,
                    DatePickUp = DateTime.Now.AddDays(-10),
                    DateDropOff = DateTime.Now.AddDays(-10),
                    VehicleId = 10,
                    DriverId = 3,

                }, new DriverVehicle()
                {
                    Id = 4,
                    DatePickUp = DateTime.Now.AddDays(-10),
                    DateDropOff = DateTime.Now.AddDays(-10),
                    VehicleId = 8,
                    DriverId = 4,

                }, new DriverVehicle()
                {
                    Id = 5,
                    DatePickUp = DateTime.Now.AddDays(-9),
                    DateDropOff = DateTime.Now.AddDays(-9),
                    VehicleId = 9,
                    DriverId = 1,

                }, new DriverVehicle()
                {
                    Id = 6,
                    DatePickUp = DateTime.Now.AddDays(-9),
                    DateDropOff = DateTime.Now.AddDays(-9),
                    VehicleId = 6,
                    DriverId = 2,

                }, new DriverVehicle()
                {
                    Id = 7,
                    DatePickUp = DateTime.Now.AddDays(-9),
                    DateDropOff = DateTime.Now.AddDays(-9),
                    VehicleId = 3,
                    DriverId = 3,

                }, new DriverVehicle()
                {
                    Id = 8,
                    DatePickUp = DateTime.Now.AddDays(-9),
                    DateDropOff = DateTime.Now.AddDays(-9),
                    VehicleId = 2,
                    DriverId = 4,

                }, new DriverVehicle()
                {
                    Id = 9,
                    DatePickUp = DateTime.Now.AddDays(-8),
                    DateDropOff = DateTime.Now.AddDays(-8),
                    VehicleId = 8,
                    DriverId = 1,

                }


            );
        }
    }
}
