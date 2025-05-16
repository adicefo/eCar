using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCar.Services.Database.Seed
{
    public static class UserData
    {
        public static void SeedData(this EntityTypeBuilder<User> entity)
        {
            entity.HasData(
                new User()
                {
                    Id = 1,
                    Name = "Admin",
                    Surname = "Admin",
                    UserName = "admin",
                    Email = "admin@edu.fit.ba",
                    PasswordHash = "UbzzxOGag4pPmBhguTkyKnpEZw4=",
                    PasswordSalt = "qYk4OxryQgplthbzFlS0yQ==",
                    TelephoneNumber = "061-111-111",
                    Gender = "Male",
                    IsActive = true,

                },
                new User()
                {
                    Id = 2,
                    Name = "Admin2",
                    Surname = "Admin2",
                    UserName = "admin2",
                    Email = "admin2@edu.fit.ba",
                    PasswordHash = "UbzzxOGag4pPmBhguTkyKnpEZw4=",
                    PasswordSalt = "qYk4OxryQgplthbzFlS0yQ==",
                    TelephoneNumber = "061-111-112",
                    Gender = "Male",
                    IsActive = true,

                },
                new User()
                {
                    Id = 3,
                    Name = "Client1",
                    Surname = "Client1",
                    UserName = "client1",
                    Email = "client1@edu.fit.ba",
                    PasswordHash = "UbzzxOGag4pPmBhguTkyKnpEZw4=",
                    PasswordSalt = "qYk4OxryQgplthbzFlS0yQ==",
                    TelephoneNumber = "061-111-113",
                    Gender = "Male",
                    IsActive = true,

                },
                new User()
                {
                    Id = 4,
                    Name = "Client2",
                    Surname = "Client2",
                    UserName = "client2",
                    Email = "client2@edu.fit.ba",
                    PasswordHash = "UbzzxOGag4pPmBhguTkyKnpEZw4=",
                    PasswordSalt = "qYk4OxryQgplthbzFlS0yQ==",
                    TelephoneNumber = "061-111-114",
                    Gender = "Female",
                    IsActive = true,

                },
                new User()
                {
                    Id = 5,
                    Name = "Client3",
                    Surname = "Client3",
                    UserName = "client3",
                    Email = "client3@edu.fit.ba",
                    PasswordHash = "UbzzxOGag4pPmBhguTkyKnpEZw4=",
                    PasswordSalt = "qYk4OxryQgplthbzFlS0yQ==",
                    TelephoneNumber = "061-111-116",
                    Gender = "Female",
                    IsActive = true,

                },
                new User()
                {
                    Id = 6,
                    Name = "Driver1",
                    Surname = "Driver1",
                    UserName = "driver1",
                    Email = "driver1@edu.fit.ba",
                    PasswordHash = "UbzzxOGag4pPmBhguTkyKnpEZw4=",
                    PasswordSalt = "qYk4OxryQgplthbzFlS0yQ==",
                    TelephoneNumber = "061-111-117",
                    Gender = "Male",
                    IsActive = true,

                }, new User()
                {
                    Id = 7,
                    Name = "Driver2",
                    Surname = "Driver2",
                    UserName = "driver2",
                    Email = "driver2@edu.fit.ba",
                    PasswordHash = "UbzzxOGag4pPmBhguTkyKnpEZw4=",
                    PasswordSalt = "qYk4OxryQgplthbzFlS0yQ==",
                    TelephoneNumber = "061-111-212",
                    Gender = "Male",
                    IsActive = true,

                }, new User()
                {
                    Id = 8,
                    Name = "Driver3",
                    Surname = "Driver3",
                    UserName = "driver3",
                    Email = "driver3@edu.fit.ba",
                    PasswordHash = "UbzzxOGag4pPmBhguTkyKnpEZw4=",
                    PasswordSalt = "qYk4OxryQgplthbzFlS0yQ==",
                    TelephoneNumber = "061-111-343",
                    Gender = "Male",
                    IsActive = true,

                },
                 new User()
                 {
                     Id = 9,
                     Name = "Client4",
                     Surname = "Client4",
                     UserName = "client4",
                     Email = "client4@edu.fit.ba",
                     PasswordHash = "UbzzxOGag4pPmBhguTkyKnpEZw4=",
                     PasswordSalt = "qYk4OxryQgplthbzFlS0yQ==",
                     TelephoneNumber = "061-111-245",
                     Gender = "Male",
                     IsActive = true,

                 },
                  new User()
                  {
                      Id = 10,
                      Name = "Driver4",
                      Surname = "Driver4",
                      UserName = "driver4",
                      Email = "driver4@edu.fit.ba",
                      PasswordHash = "UbzzxOGag4pPmBhguTkyKnpEZw4=",
                      PasswordSalt = "qYk4OxryQgplthbzFlS0yQ==",
                      TelephoneNumber = "061-124-343",
                      Gender = "Female",
                      IsActive = true,

                  });

        }
    }
}
