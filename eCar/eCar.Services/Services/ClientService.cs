using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using MapsterMapper;
using Nest;
using System;
using System.Collections.Generic;
using EFCore = Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using eCar.Model.Helper;
using eCar.Services.Helpers;

namespace eCar.Services.Services
{
    public class ClientService:BaseCRUDService<Model.Model.Client,
        ClientSearchObject,Database.Client,ClientUpsertRequest,ClientUpsertRequest>,IClientService
    {
        public ClientService(ECarDbContext context,IMapper mapper)
            :base(context,mapper)
        {
            
        }
        public override Model.Model.Client GetById(int id)
        {
            var set = Context.Set<Database.Client>().AsQueryable();
            set = set.Include(x => x.User);
            var entity=set.FirstOrDefault(c=>c.Id==id);
            if (entity == null)
                throw new Exception("Non-existed entity");
            return Mapper.Map<Model.Model.Client>(entity);
            
        }
        public override IQueryable<Client> AddFilter(ClientSearchObject search, IQueryable<Client> query)
        {
            var filteredQuery = base.AddFilter(search, query);
            if (!string.IsNullOrWhiteSpace(search?.NameGTE))
                filteredQuery = filteredQuery.Where(x => x.User.Name.StartsWith(search.NameGTE));
            if (!string.IsNullOrWhiteSpace(search?.SurenameGTE))
                filteredQuery = filteredQuery.Where(x => x.User.Surname.StartsWith(search.SurenameGTE));
            if (!string.IsNullOrWhiteSpace(search?.Username))
                filteredQuery = filteredQuery.Where(x => x.User.UserName == search.Username);
            return filteredQuery;
        }
        public override IQueryable<Client> AddInclude(ClientSearchObject search, IQueryable<Client> query)
        {
            var filteredQuery = base.AddInclude(search, query);
            if (search?.IsUserIncluded == true)
            {
                filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.User);
            }
            return filteredQuery;
        }
        public override void BeforeInsert(ClientUpsertRequest request, Client entity)
        {
            if (request.Password != request.PasswordConfirm)
                throw new UserException("Password and Confirmed password are not the same");

            User user = Mapper.Map<Database.User>(request);
            entity.User = user;
            entity.User.PasswordSalt = PasswordGenerate.GenerateSalt();
            entity.User.PasswordHash = PasswordGenerate.GenerateHash(entity.User.PasswordSalt, request.Password);
            entity.User.RegistrationDate = DateTime.Now;
            entity.User.IsActive = true;
            base.BeforeInsert(request, entity);
        }
        public override Model.Model.Client Update(int id, ClientUpsertRequest request)
        {
            var set = Context.Set<Database.Client>();
            var entity = set.Include(x=>x.User).FirstOrDefault(c=>c.Id==id);
            if (entity == null)
                throw new Exception("Non-existed model");

            Mapper.Map(request, entity?.User);
            Mapper.Map(request, entity);
            
            Context.SaveChanges();

            var result = Mapper.Map<Model.Model.Client>(entity);

            return result;
        }
    }
}
