using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class ReviewData
    {
        public static void SeedData(this EntityTypeBuilder<Review> entity)
        {
            entity.HasData(
                new Review()
                {
                    Id = 1,
                    Value=5,
                    Description= "Sve pohvale,efikasno i brzo.",
                    AddedDate = DateTime.Now.AddMonths(-2),
                    ReviewedId=1,
                    ReviewsId=2,
                    RouteId=6
                },
                 new Review()
                 {
                     Id = 2,
                     Value = 4,
                     Description = "Dobro je, malo je kasnio,al sve ok,auto za 10.",
                     AddedDate = DateTime.Now.AddMonths(-2),
                     ReviewedId = 2,
                     ReviewsId = 2,
                     RouteId=8
                 },
                  new Review()
                  {
                      Id = 3,
                      Value = 4,
                      Description = "Pohvale za vozača,ljubazan...",
                      AddedDate = DateTime.Now.AddMonths(-1),
                      ReviewedId = 1,
                      ReviewsId = 3,
                      RouteId=7
                  },
                   new Review()
                   {
                       Id = 4,
                       Value = 3,
                       Description = "Kasniiiiiii",
                       AddedDate = DateTime.Now.AddMonths(-1),
                       ReviewedId = 2,
                       ReviewsId = 2,
                       RouteId=8

                   }
                   
               );


        }
    }
}
