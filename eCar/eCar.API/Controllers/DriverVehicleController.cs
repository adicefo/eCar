using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObject;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using eCar.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{

    [ApiController]
    public class DriverVehicleController : BaseCRUDController<Model.Model.DriverVehicle,
        DriverVehicleSearchObject,DriverVehicleInsertRequest,DriverVehicleUpdateRequest>
    {
        
        public DriverVehicleController(IDriverVehicleService service):base(service) 
        { 

        }
        [HttpGet("CheckIfAssigned/{driverId}")]
        public IActionResult CheckIfAssigned(int driverId)
        {
            return (_service as IDriverVehicleService).CheckIfAssigned(driverId);
        }
        [AllowAnonymous]
        [HttpPut("UpdateFinish")]
        public Model.Model.DriverVehicle UpdateFinish([FromBody]DriverVehicleUpdateFinsihRequest request)
        {
            return (_service as IDriverVehicleService).UpdateFinsih(request);
        }

    }
}
