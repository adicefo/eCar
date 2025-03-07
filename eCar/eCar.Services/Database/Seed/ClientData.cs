using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class ClientData
    {
        public static void SeedData(this EntityTypeBuilder<Client> entity)
        {
            entity.HasData(
                new Client()
                {
                    Id = 1,
                    UserId=3,

                },
                new Client()
                {
                    Id = 2,
                    UserId = 4

                }, new Client()
                {
                    Id = 3,
                    UserId = 5

                });


        }
    }
}

