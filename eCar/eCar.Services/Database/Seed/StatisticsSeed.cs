using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class StatisticsSeed
    {
        public static void SeedData(this EntityTypeBuilder<Statistic> entity)
        {
            entity.HasData(
                new Statistic()
                {
                    Id=1,
                    DriverId=1,
                    BeginningOfWork=DateTime.Now.AddDays(-10),
                    EndOfWork=DateTime.Now.AddDays(-10),
                    NumberOfClients=7,
                    NumberOfHours=8,
                    PriceAmount=105
                },
                 new Statistic()
                 {
                     Id = 2,
                     DriverId = 2,
                     BeginningOfWork = DateTime.Now.AddDays(-10),
                     EndOfWork = DateTime.Now.AddDays(-10),
                     NumberOfClients = 4,
                     NumberOfHours =7,
                     PriceAmount = 80
                 },
                  new Statistic()
                  {
                      Id = 3,
                      DriverId = 3,
                      BeginningOfWork = DateTime.Now.AddDays(-10),
                      EndOfWork = DateTime.Now.AddDays(-10),
                      NumberOfClients = 5,
                      NumberOfHours = 7,
                      PriceAmount = 56
                  },
                   new Statistic()
                   {
                       Id = 4,
                       DriverId = 4,
                       BeginningOfWork = DateTime.Now.AddDays(-10),
                       EndOfWork = DateTime.Now.AddDays(-10),
                       NumberOfClients = 9,
                       NumberOfHours = 8,
                       PriceAmount = 100
                   },
                    new Statistic()
                    {
                        Id = 5,
                        DriverId = 1,
                        BeginningOfWork = DateTime.Now.AddDays(-9),
                        EndOfWork = DateTime.Now.AddDays(-9),
                        NumberOfClients = 10,
                        NumberOfHours = 8,
                        PriceAmount = 105
                    },
                     new Statistic()
                     {
                         Id = 6,
                         DriverId = 2,
                         BeginningOfWork = DateTime.Now.AddDays(-9),
                         EndOfWork = DateTime.Now.AddDays(-9),
                         NumberOfClients = 6,
                         NumberOfHours = 8,
                         PriceAmount = 89
                     },
                      new Statistic()
                      {
                          Id = 7,
                          DriverId = 3,
                          BeginningOfWork = DateTime.Now.AddDays(-9),
                          EndOfWork = DateTime.Now.AddDays(-9),
                          NumberOfClients = 6,
                          NumberOfHours = 7,
                          PriceAmount = 75
                      },
                      new Statistic()
                      {
                          Id = 8,
                          DriverId = 4,
                          BeginningOfWork = DateTime.Now.AddDays(-9),
                          EndOfWork = DateTime.Now.AddDays(-9),
                          NumberOfClients = 7,
                          NumberOfHours = 7,
                          PriceAmount = 80
                      }, new Statistic()
                      {
                          Id = 9,
                          DriverId = 1,
                          BeginningOfWork = DateTime.Now.AddDays(-8),
                          EndOfWork = DateTime.Now.AddDays(-8),
                          NumberOfClients = 5,
                          NumberOfHours = 8,
                          PriceAmount = 55
                      }


            );


        }
    }
}

