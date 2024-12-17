using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Services
{
    public class VehicleService : BaseCRUDService<Model.Model.Vehicle,
        VehicleSearchObject,Database.Vehicle,VehicleInsertRequest,VehicleUpdateRequest>,IVehicleService
    {

        public VehicleService(ECarDbContext context, IMapper mapper) :
            base(context, mapper)
        {
        }

        public override IQueryable<Database.Vehicle> AddFilter(VehicleSearchObject search, IQueryable<Database.Vehicle> query)
        {
            var filteredQuery = base.AddFilter(search, query);
            if (search.IsAvailable != null)
                if (search.IsAvailable.Value == true)
                    filteredQuery = filteredQuery.Where(x => x.Available == true);
                else 
                    filteredQuery = filteredQuery.Where(x => x.Available == false);
            if (!string.IsNullOrWhiteSpace(search?.NameCTS))
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.NameCTS));
            return filteredQuery;
        }
        public override void BeforeInsert(VehicleInsertRequest request, Vehicle entity)
        {
            if (request.Name == null)
                throw new Exception("You have to set Name attribute");
            if (request.Price < 40 && request.Price > 65)
                throw new Exception("Set valid price between 40 and 65");
            base.BeforeInsert(request, entity);
        }
    }
}
