using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class KategorijaTranskacije25062025Seed
    {
        public static void SeedData(this EntityTypeBuilder<KategorijaTransakcije250602025> entity)
        {
            entity.HasData(
                new KategorijaTransakcije250602025()
                {
                        Id=1,
                         Naziv="Hrana",
                         Tip="Prihod"
                         
                },
                 new KategorijaTransakcije250602025()
                 {
                     Id = 2,
                     Naziv = "Zabava",
                     Tip = "Rashod"

                 },
                  new KategorijaTransakcije250602025()
                  {
                      Id = 3,
                      Naziv = "Plata",
                      Tip = "Prihod"

                  }
                );


        }
    }
}

