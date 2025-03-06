using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IDriverVehicleService:ICRUDService<Model.Model.DriverVehicle,
        DriverVehicleSearchObject,DriverVehicleInsertRequest,DriverVehicleUpdateRequest>
    {
        Model.Model.DriverVehicle UpdateFinsih(DriverVehicleUpdateFinsihRequest request);

        IActionResult CheckIfAssigned(int driverId);
    }
}
