using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using EFCore = Microsoft.EntityFrameworkCore;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using eCar.Model.Helper;
using eCar.Services.Helpers;

namespace eCar.Services.Services
{
    public class DriverService:BaseCRUDService<Model.Model.Driver,
        DriverSearchObject,Database.Driver,DriverInsertRequest,DriverUpdateRequest>,IDriverService
    {
        public DriverService(ECarDbContext context,IMapper mapper)
            :base(context,mapper) 
        {
            
        }
        public override Model.Model.Driver GetById(int id)
        {
            var set=Context.Set<Driver>().AsQueryable();
            var entity=set.Include(x=>x.User).FirstOrDefault(d=>d.Id==id);
            if (entity == null)
                throw new UserException("Non existed model");
            var result=Mapper.Map<Model.Model.Driver>(entity);
            return result;
        }
        public Model.Model.Driver InsertBasedOnUser(int userId)
        {
            var user = Context.Users.Find(userId);
            if (user == null)
                throw new UserException("Non existed user");
            var entity = new Database.Driver();
            entity.UserID = userId;
            Mapper.Map(user, entity?.User);

            Context.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Model.Driver>(entity);

        }
        public override IQueryable<Driver> AddFilter(DriverSearchObject search, IQueryable<Driver> query)
        {
            var filteredQuery= base.AddFilter(search, query);
            if(!string.IsNullOrWhiteSpace(search?.NameGTE))
                filteredQuery=filteredQuery.Where(x=>x.User.Name.StartsWith(search.NameGTE));
            if(!string.IsNullOrWhiteSpace(search?.SurnameGTE))
                filteredQuery=filteredQuery.Where(x=>x.User.Surname.StartsWith(search.SurnameGTE));
            return filteredQuery;
        }

        public override IQueryable<Driver> AddInclude(DriverSearchObject search, IQueryable<Driver> query)
        {
            var filteredQuery=base.AddInclude(search, query);
            if (search?.IsUserIncluded == true)
                filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.User);
            return filteredQuery;
        }

        public override void BeforeInsert(DriverInsertRequest request, Driver entity)
        {
            if (request.Password != request.PasswordConfirm)
                throw new UserException("Password and Confirmed password are not the same");

            User user = Mapper.Map<User>(request);
            entity.User= user;
            entity.User.PasswordSalt = PasswordGenerate.GenerateSalt();
            entity.User.PasswordHash = PasswordGenerate.GenerateHash(user.PasswordSalt, request.Password);
            entity.User.RegistrationDate= DateTime.Now;
            entity.User.IsActive= true;
            entity.NumberOfHoursAmount = 0;
            entity.NumberOfClientsAmount = 0;
            base.BeforeInsert(request, entity);
        }

        public override Model.Model.Driver Update(int id, DriverUpdateRequest request)
        {
            var set = Context.Set<Database.Driver>();
            var entity = set.Include(x => x.User).FirstOrDefault(c => c.Id == id);
            if (entity == null)
                throw new Exception("Non-existed model");

            Mapper.Map(request, entity?.User);
            Mapper.Map(request, entity);

            Context.SaveChanges();

            var result = Mapper.Map<Model.Model.Driver>(entity);

            return result;
        }
    }
}
