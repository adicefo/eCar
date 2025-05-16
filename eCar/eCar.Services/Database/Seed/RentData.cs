using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static  class RentData
    {
        public static void SeedData(this EntityTypeBuilder<Rent> entity)
        {
            entity.HasData(
                new Rent()
                {
                    Id = 1,
                    RentingDate=DateTime.Now.AddDays(10),
                    EndingDate=DateTime.Now.AddDays(13),
                    VehicleId=1,
                    ClientId=1,
                    FullPrice=120,
                    NumberOfDays=3,
                    Status="wait",
                },
                new Rent()
                {
                    Id = 2,
                    RentingDate = DateTime.Now.AddDays(13),
                    EndingDate = DateTime.Now.AddDays(23),
                    VehicleId = 2,
                    ClientId = 3,
                    FullPrice = 550,
                    NumberOfDays = 10,
                    Status = "wait",

                }, new Rent()
                {
                    Id = 3,
                    RentingDate = DateTime.Now.AddDays(10),
                    EndingDate = DateTime.Now.AddDays(15),
                    VehicleId = 5,
                    ClientId = 2,
                    FullPrice = 225,
                    NumberOfDays = 10,
                    Status = "wait",

                }, new Rent()
                {
                    Id = 4,
                    RentingDate = DateTime.Now.AddDays(3),
                    EndingDate = DateTime.Now.AddDays(7),
                    VehicleId = 8,
                    ClientId = 1,
                    FullPrice = 196,
                    NumberOfDays = 4,
                    Status = "wait",

                }, new Rent()
                {
                    Id = 5,
                    RentingDate = DateTime.Now.AddDays(-3),
                    EndingDate = DateTime.Now.AddDays(15),
                    VehicleId = 1,
                    ClientId = 3,
                    FullPrice = 480,
                    NumberOfDays = 12,
                    Status = "active",

                }, new Rent()
                {
                    Id = 6,
                    RentingDate = DateTime.Now.AddDays(-2),
                    EndingDate = DateTime.Now.AddDays(15),
                    VehicleId = 7,
                    ClientId = 3,
                    FullPrice = 612,
                    NumberOfDays = 13,
                    Status = "active",


                }, new Rent()
                {
                    Id = 7,
                    RentingDate = DateTime.Now.AddDays(-30),
                    EndingDate = DateTime.Now.AddDays(-10),
                    VehicleId = 4,
                    ClientId = 3,
                    FullPrice = 1200,
                    NumberOfDays = 20,
                    Status = "finished",


                }, new Rent()
                {
                    Id = 8,
                    RentingDate = DateTime.Now.AddDays(-20),
                    EndingDate = DateTime.Now.AddDays(-10),
                    VehicleId = 4,
                    ClientId = 2,
                    FullPrice = 450,
                    NumberOfDays = 10,
                    Status = "finished",


                },
                new Rent()
                {
                    Id = 9,
                    RentingDate = DateTime.Now.AddDays(-30),
                    EndingDate = DateTime.Now.AddDays(-25),
                    VehicleId = 6,
                    ClientId = 1,
                    FullPrice = 235,
                    NumberOfDays = 5,
                    Status = "finished",


                },
                new Rent()
                {
                    Id = 10,
                    RentingDate = DateTime.Now.AddDays(-35),
                    EndingDate = DateTime.Now.AddDays(-25),
                    VehicleId = 3,
                    ClientId = 2,
                    FullPrice = 450,
                    NumberOfDays = 10,
                    Status = "finished",


                }, new Rent()
                {
                    Id = 11,
                    RentingDate = DateTime.Now.AddDays(-45),
                    EndingDate = DateTime.Now.AddDays(-35),
                    VehicleId = 3,
                    ClientId = 3,
                    FullPrice = 450,
                    NumberOfDays = 10,
                    Status = "finished",


                }, new Rent()
                {
                    Id = 12,
                    RentingDate = DateTime.Now.AddDays(-10),
                    EndingDate = DateTime.Now.AddDays(-5),
                    VehicleId = 10,
                    ClientId = 1,
                    FullPrice = 235,
                    NumberOfDays = 5,
                    Status = "finished",


                }, new Rent()
                {
                    Id = 13,
                    RentingDate = DateTime.Now.AddDays(-15),
                    EndingDate = DateTime.Now.AddDays(-8),
                    VehicleId = 9,
                    ClientId = 4,
                    FullPrice = 385,
                    NumberOfDays = 7,
                    Status = "finished",


                }, new Rent()
                {
                    Id = 14,
                    RentingDate = DateTime.Now.AddDays(-30),
                    EndingDate = DateTime.Now.AddDays(-25),
                    VehicleId = 8,
                    ClientId = 1,
                    FullPrice = 245,
                    NumberOfDays = 5,
                    Status = "finished",


                }, new Rent()
                {
                    Id = 15,
                    RentingDate = DateTime.Now.AddDays(-80),
                    EndingDate = DateTime.Now.AddDays(-65),
                    VehicleId = 4,
                    ClientId = 2,
                    FullPrice = 675,
                    NumberOfDays = 15,
                    Status = "finished",


                });


        }
    }
}
