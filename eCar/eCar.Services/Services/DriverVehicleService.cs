using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using EFCore = Microsoft.EntityFrameworkCore;
using MapsterMapper;
using Nest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using eCar.Model.Helper;
using Microsoft.AspNetCore.Mvc;

namespace eCar.Services.Services
{
    public class DriverVehicleService:BaseCRUDService<Model.Model.DriverVehicle,
        DriverVehicleSearchObject,Database.DriverVehicle,DriverVehicleInsertRequest,DriverVehicleUpdateRequest>,IDriverVehicleService
    {
        public DriverVehicleService(ECarDbContext context,IMapper mapper):base(context,mapper)
        {
            
        }
        public Model.Model.DriverVehicle UpdateFinsih(DriverVehicleUpdateFinsihRequest request)
        {
            var set = Context.Set<Database.DriverVehicle>().AsQueryable();
            var entity = set.Include(x => x.Driver).ThenInclude(x => x.User).Include(x=>x.Vehicle).Where(x=>x.DriverId==request.DriverId
            &&x.DatePickUp.Value.Date==request.DatePickUp.Date&&x.DateDropOff==null).FirstOrDefault();
            if (entity == null)
                return null;

            entity.DateDropOff = DateTime.Now;

            //vehicle is now available
            var vehicle = Context.Vehicles.FirstOrDefault(x => x.Id == entity.VehicleId);
            if (vehicle == null)
                throw new UserException("Non existed vehicle");
            vehicle.Available = true;

            Context.DriverVehicles.Update(entity);
            Context.Vehicles.Update(vehicle);
            Context.SaveChanges();

            var result = Mapper.Map<Model.Model.DriverVehicle>(entity);

            return result;
        }

        public override IQueryable<DriverVehicle> AddFilter(DriverVehicleSearchObject search, IQueryable<DriverVehicle> query)
        {
            var filteredQuery = base.AddFilter(search, query);
            var driver = Context.Drivers.Find(search.DriverId);
            var vehicle = Context.Vehicles.Find(search.VechicleId);
            if (driver!=null)
                filteredQuery = filteredQuery.Where(x => x.DriverId==search.DriverId);
            if(vehicle!=null)
                filteredQuery = filteredQuery.Where(x => x.VehicleId == search.VechicleId);
            if(search.DatePickUp!=null)
                filteredQuery=filteredQuery.Where(x=>x.DatePickUp.Value.Date==search.DatePickUp.Value.Date);
            if (search.DriverName != null)
                filteredQuery = filteredQuery.Where(x => x.Driver.User.Name.StartsWith(search.DriverName));
            return filteredQuery;
        }
        public override IQueryable<DriverVehicle> AddInclude(DriverVehicleSearchObject search, IQueryable<DriverVehicle> query)
        {
            var filteredQuery = base.AddInclude(search, query); 
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Driver).ThenInclude(x=>x.User);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Vehicle);
            return filteredQuery;
        }
        public override void BeforeInsert(DriverVehicleInsertRequest request, DriverVehicle entity)
        {
            

            entity.DatePickUp=DateTime.Now;
            var vehicle = Context.Vehicles.Find(request.VehicleId);
            if(vehicle!=null)
                vehicle.Available = false;
        }
        public IActionResult CheckIfAssigned(int driverId)
        {
            //check if driver has assigned car for this date
            var instance = Context.DriverVehicles.Where(x => x.DriverId == driverId &&
             x.DatePickUp.Value.Date == DateTime.Now.Date).Any();
            if (instance)
                return new OkObjectResult(new { isAssigned = true });
            return new OkObjectResult(new { isAssigned = false }); ;
        }
    }
}
