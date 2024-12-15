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
    public class VehicleService : BaseService<Model.Model.Vehicle, VehicleSearchObject, Database.Vehicle>, IVehicleService
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
                    query = query.Where(x => x.Available == false);
            if (!string.IsNullOrWhiteSpace(search?.NameCTS))
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.NameCTS));
            return filteredQuery;
        }
    }
}
