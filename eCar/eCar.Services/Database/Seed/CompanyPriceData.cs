using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class CompanyPriceData
    {
        public static void SeedData(this EntityTypeBuilder<CompanyPrice> entity)
        {
            entity.HasData(
                new CompanyPrice()
                {
                    Id = 1,
                   PricePerKilometar=3.0101M,
                   AddingDate = DateTime.Now.AddMonths(-2),

                },
               new CompanyPrice()
               {
                   Id = 2,
                   PricePerKilometar = 3.05M,
                   AddingDate = DateTime.Now.AddMonths(-1),

               }, new CompanyPrice()
               {
                   Id = 3,
                   PricePerKilometar = 3.07M,
                   AddingDate = DateTime.Now,

               });


        }
    }
}
