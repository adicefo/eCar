using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class FinansijskiLimit250602025Seed
    {
        public static void SeedData(this EntityTypeBuilder<FinansijskiLimit250602025> entity)
        {
            entity.HasData(
                new FinansijskiLimit250602025()
                {
                    Id=1,
                     Limit=300.0,
                     KorisnikId=1,
                     KategorijaId=1
                },
                new FinansijskiLimit250602025()
                {
                    Id = 2,
                    Limit = 300.0,
                    KorisnikId = 1,
                    KategorijaId = 2
                }, new FinansijskiLimit250602025()
                {
                    Id = 3,
                    Limit = 300.0,
                    KorisnikId = 2,
                    KategorijaId = 1
                }, new FinansijskiLimit250602025()
                {
                    Id = 4,
                    Limit = 300.0,
                    KorisnikId = 2,
                    KategorijaId = 1
                }

                );


        }
    }
}
