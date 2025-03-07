using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database.Seed
{
    public static class NotificationData
    {
        public static void SeedData(this EntityTypeBuilder<Notification> entity)
        {
            entity.HasData(
                new Notification()
                {
                    Id = 1,
                    AddingDate=DateTime.Now.AddDays(-10),
                    Heading= "Dobrodošli u eCar aplikaciju",
                    Content_= "Obavještavamo vas da je eCar aplikacija u pripremi. Nadamo se da će ista biti osposobljena u što skorije vrijeme. Trenutno radimo na admin dijelu aplikacije,a u skorije vrijeme bismo trebali započeti i sa mobile dijelom. Vaš eCar",
                    IsForClient=false,
                    Status="active"
                },
                 new Notification()
                 {
                     Id = 2,
                     AddingDate = DateTime.Now.AddDays(-9),
                     Heading = "Aplikacija u pripremi",
                     Content_= "Dragi naši klijenti, korisnici eCar aplikacije. Naš developerski tim radi na uspostavljanju iste, te se nadamo u što skorije vrijeme da ćete moći koristi pogodnosti eCar aplikacije. Vaš eCar.",
                     IsForClient = true,
                     Status = "active"
                 },
                  new Notification()
                  {
                      Id = 3,
                      AddingDate = DateTime.Now.AddDays(-8),
                      Heading = "Nova obavijest.",
                      Content_ = "Obavještavamo zaposlenike da je aplikacija još uvijek u pripremi. Hvala na strpljenju.",
                      IsForClient = false,
                      Status = "active"
                  },
                   new Notification()
                   {
                       Id = 4,
                       AddingDate = DateTime.Now.AddDays(-5),
                       Heading = "Probna za klijenta",
                       Content_ = "Notifikacija napravljena u svrhu testiranja funkcionalnosti na UI-u.",
                       IsForClient = true,
                       Status = "active"
                   },
                    new Notification()
                    {
                        Id = 5,
                        AddingDate = DateTime.Now.AddDays(-3),
                        Heading = "Test za klijenta",
                        Content_= "Testna obavijest za klijenta u svrhu testiranja image_placeholdera.",
                        IsForClient = true,
                        Status = "active"
                    }
               );


        }
    }
}
