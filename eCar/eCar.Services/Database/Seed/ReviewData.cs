﻿using Microsoft.EntityFrameworkCore.Metadata.Builders;
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
                    RouteId=2
                },
                 new Review()
                 {
                     Id = 2,
                     Value = 4,
                     Description = "Dobro je, malo je kasnio,al sve ok,auto za 10.",
                     AddedDate = DateTime.Now.AddMonths(-2),
                     ReviewedId = 2,
                     ReviewsId = 1,
                     RouteId=4
                 },
                  new Review()
                  {
                      Id = 3,
                      Value = 4,
                      Description = "Pohvale za vozača,ljubazan...",
                      AddedDate = DateTime.Now.AddMonths(-1),
                      ReviewedId = 1,
                      ReviewsId = 2,
                      RouteId=2     
                  },
                   new Review()
                   {
                       Id = 4,
                       Value = 3,
                       Description = "Kasniiiiiii",
                       AddedDate = DateTime.Now.AddMonths(-1),
                       ReviewedId = 2,
                       ReviewsId = 3,
                       RouteId=3

                   },
                   new Review()
                   {
                       Id = 5,
                       Value = 5,
                       Description = "Sve pohvale za momka. Jako lijepa vožnja i prijatan stav.",
                       AddedDate = DateTime.Now.AddMonths(-1),
                       ReviewedId = 4,
                       ReviewsId = 1,
                       RouteId = 6

                   }, new Review()
                   {
                       Id = 6,
                       Value = 4,
                       Description = "Poprilično sam zadovoljan vožnjom...",
                       AddedDate = DateTime.Now.AddMonths(-1),
                       ReviewedId = 3,
                       ReviewsId = 2,
                       RouteId = 7

                   }

               );


        }
    }
}
