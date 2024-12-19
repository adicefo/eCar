using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MapsterMapper;
using System.Security.Cryptography;
using eCar.Services.Interfaces;
using eCar.Model.Requests;
using eCar.Services.Database;
using eCar.Services.Helpers;
using eCar.Model.SearchObject;
using System.Data.Entity;
using Microsoft.Extensions.Logging;
namespace eCar.Services.Services
{
    public class UserService : BaseCRUDService<Model.Model.User,UserSearchObject ,Database.User,UserInsertRequest,UserUpdateRequest> ,IUserService
    {

        public ILogger<UserService> _logger { get; set; }
        public UserService(ECarDbContext context,IMapper mapper,ILogger<UserService> logger):
            base(context,mapper)
        {
            _logger = logger;
        }
       
        public override IQueryable<Database.User> AddFilter(UserSearchObject search, IQueryable<Database.User> query)
        {
            var filteredQuery=base.AddFilter(search, query);
            if (!string.IsNullOrWhiteSpace(search?.NameGTE))
                filteredQuery = filteredQuery.Where(x => x.Name.StartsWith(search.NameGTE));
            if (!string.IsNullOrWhiteSpace(search?.SurnameGTE))
                filteredQuery = filteredQuery.Where(x => x.Surname.StartsWith(search.SurnameGTE));
            if (!string.IsNullOrWhiteSpace(search?.Email))
                filteredQuery = filteredQuery.Where(x => x.Email==search.Email);
            if (!string.IsNullOrWhiteSpace(search?.Username))
                filteredQuery = filteredQuery.Where(x => x.UserName==search.Username);
            return filteredQuery;
        }

        public override void BeforeInsert(UserInsertRequest request, User entity)
        {
            _logger.LogInformation($"Adding user: {entity.UserName}");

           if (request.Password != request.PasswordConfirm)
           {
               throw new Exception("Password and Confirmed password are not the same");
           }
           entity.PasswordSalt = PasswordGenerate.GenerateSalt();
           entity.PasswordHash = PasswordGenerate.GenerateHash(entity.PasswordSalt, request.Password);
           entity.RegistrationDate = DateTime.Now;
           base.BeforeInsert(request, entity);
        }
        public override void BeforeUpdate(UserUpdateRequest request, User entity)
        {

             if (request.Password != null)
             {
                 if (request.Password != request.PasswordConfirm)
                 {
                     throw new Exception("Password and Confirm password" +
                         "must be same values");
                 }
                 entity.PasswordSalt = PasswordGenerate.GenerateSalt();
                 entity.PasswordHash = PasswordGenerate.GenerateHash(entity.PasswordSalt, request.Password);
             }
            base.BeforeUpdate(request, entity);
        }

    }
}
