using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using MapsterMapper;
using RentACar.Model;
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
        public PagedResult<Model.Model.Vehicle> GetAvailableForDriver()
        {
            List<Model.Model.Vehicle> result = new List<Model.Model.Vehicle>();
            var query = Context.Set<Vehicle>().AsQueryable();

            //all available cars
            query = query.Where(x => x.Available == true);

            //rents for that cars that are in status active
            var rents=Context.Rents.Where(x=>x.Status=="active"&&
            (DateTime.Now.Date>=x.RentingDate!.Value.Date)&&
            (DateTime.Now<=x.EndingDate!.Value.Date)).Select(x=>x.Vehicle.Id).ToList();

            //exclude rents from query
            query=query.Where(x=>!rents.Contains(x.Id));


            int count = query.Count();

            var list = query.ToList();

            result = Map(list, result);

            PagedResult<Model.Model.Vehicle> pageResult = new PagedResult<Model.Model.Vehicle>();
            pageResult.Result = result;
            pageResult.Count = count;

            return pageResult;
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
