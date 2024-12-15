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
namespace eCar.Services.Services
{
    public class UserService : BaseService<Model.Model.User,UserSearchObject,Database.User>,IUserService
    {

     
       public UserService(ECarDbContext context,IMapper mapper):
            base(context,mapper)
       {
          
       }
        
       public Model.Model.User Insert(UserInsertRequest request)
       {
           if(request.Password!= request.PasswordConfirm)
           {
               throw new Exception("Password and Confirmed password are not the same");
           }

           Database.User entity=new Database.User();
           Mapper.Map(request, entity);
           entity.PasswordSalt = PasswordGenerate.GenerateSalt();
           entity.PasswordHash = PasswordGenerate.GenerateHash(entity.PasswordSalt, request.Password);
           entity.RegistrationDate= DateTime.Now;

           Context.Users.Add(entity);
           Context.SaveChanges();


          return Mapper.Map<Model.Model.User>(entity);

        }
        public Model.Model.User Update(int id, UserUpdateRequest request)
        {
           var entity=Context.Users.Find(id);
            if (entity == null)
                throw new Exception("Non-existed user");
           
            entity=Mapper.Map(request, entity);
           
            if(request.Password!=null)
            {
                if(request.Password!=request.PasswordConfirm)
                {
                    throw new Exception("Password and Confirm password" +
                        "must be same values");
                }
                entity.PasswordSalt=PasswordGenerate.GenerateSalt();
                entity.PasswordHash=PasswordGenerate.GenerateHash(entity.PasswordSalt, request.Password);
            }
            Context.SaveChanges();
            return Mapper.Map<Model.Model.User>(entity);
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

    }
}
