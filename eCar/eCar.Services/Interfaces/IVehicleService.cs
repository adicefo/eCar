using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using RentACar.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IVehicleService:ICRUDService<Model.Model.Vehicle,
        VehicleSearchObject,VehicleInsertRequest,VehicleUpdateRequest>
    { 
        public PagedResult<Model.Model.Vehicle> GetAvailableForDriver();

    }
}
