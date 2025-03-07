using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class AdminData
    {
        public static void SeedData(this EntityTypeBuilder<Admin> entity)
        {
            entity.HasData(
                new Admin()
                {
                    Id = 1,UserID=1
                    

                },
                new Admin()
                {
                    Id = 2,
                   UserID=2

                });
               

        }
    }
}
