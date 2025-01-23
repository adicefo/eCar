using eCar.Model.Helper;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Helpers;
using eCar.Services.Interfaces;
using MapsterMapper;
using EFCore = Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Azure.Core;


namespace eCar.Services.Services
{
    public class AdminService:BaseCRUDService<Model.Model.Admin,
        AdminSearchObject,Database.Admin,AdminInsertRequest,AdminUpdateRequest>,IAdminService
    {
        public AdminService(ECarDbContext context,IMapper mapper):base(context,mapper) 
        {
            
        }
        
        public override Model.Model.Admin GetById(int id)
        {
            var set = Context.Set<Database.Admin>().AsQueryable();
            set = EFCore.EntityFrameworkQueryableExtensions.Include(set,x => x.User);
            var entity= set.FirstOrDefault(a=>a.Id==id);
            if (entity == null)
                throw new Exception("Non-existed entity");
            return Mapper.Map<Model.Model.Admin>(entity);
        }
        public Model.Model.Admin InsertBasedOnUser(int userId)
        {
            var user = Context.Users.Find(userId);
            if (user == null)
                throw new UserException("Non existed user");
            var entity=new Database.Admin();
            entity.UserID= userId;
            Mapper.Map(user, entity?.User);

            Context.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Model.Admin>(entity);

        }

        public override IQueryable<Admin> AddInclude(AdminSearchObject search, IQueryable<Admin> query)
        {
            var filteredQuery= base.AddInclude(search, query);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery,x=>x.User);
            return filteredQuery;
            
        }
           
        public override void BeforeInsert(AdminInsertRequest request, Admin entity)
        {
            if (request.Password != request.PasswordConfirm)
                throw new UserException("Password and Confirmed password are not the same");
            
            User user = Mapper.Map<Database.User>(request);
            entity.User = user;
            entity.User.PasswordSalt = PasswordGenerate.GenerateSalt();
            entity.User.PasswordHash=PasswordGenerate.GenerateHash(entity.User.PasswordSalt,request.Password);
            entity.User.RegistrationDate= DateTime.Now;
            entity.User.IsActive= true;
            base.BeforeInsert(request, entity);
        }
        public override Model.Model.Admin Update(int id, AdminUpdateRequest request)
        {
            var set = Context.Set<Database.Admin>();
            var entity = set.Include(x=>x.User).FirstOrDefault(x=>x.Id==id);
            if (entity == null)
                throw new Exception("Non-existed model");

            Mapper.Map(request, entity?.User);
            entity = Mapper.Map(request, entity);
     

            Context.SaveChanges();

            return Mapper.Map<Model.Model.Admin>(entity);
        }

    }
}
