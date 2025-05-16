using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class DriverData
    {
        public static void SeedData(this EntityTypeBuilder<Driver> entity)
        {
            entity.HasData(
                new Driver()
                {
                    Id = 1,
                    UserID=6,
                    NumberOfClientsAmount=35,
                    NumberOfHoursAmount=19,

                },
                new Driver()
                {
                    Id = 2,
                    UserID = 7,
                    NumberOfClientsAmount = 45,
                    NumberOfHoursAmount = 23,

                }, new Driver()
                {
                    Id = 3,
                    UserID = 8,
                    NumberOfClientsAmount=55,
                    NumberOfHoursAmount=29

                },
                new Driver()
                {
                    Id = 4,
                    UserID = 10,
                    NumberOfClientsAmount=39,
                    NumberOfHoursAmount=20
                });


        }
    }
}
