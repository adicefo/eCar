using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObject;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using eCar.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RentACar.Model;

namespace eCar.API.Controllers
{

    [ApiController]
    public class VehicleController : BaseCRUDController<Model.Model.Vehicle,
        VehicleSearchObject,VehicleInsertRequest,VehicleUpdateRequest>
    {
        
        public VehicleController(IVehicleService service):base(service) 
        { 

        }
        [Authorize(Roles="Driver,Admin")]
        [HttpGet("GetAvailableForDriver")]
        public PagedResult<Model.Model.Vehicle> GetAvailableForDriver()
        {
            return (_service as IVehicleService).GetAvailableForDriver();
        }
        [Authorize(Roles ="Admin")]
        public override Vehicle Insert(VehicleInsertRequest request)
        {
            return base.Insert(request);
        }
        [Authorize(Roles ="Admin")]
        public override Vehicle Update(int id, VehicleUpdateRequest request)
        {
            return base.Update(id, request);
        }
        [Authorize(Roles ="Admin")]
        public override Vehicle Delete(int id)
        {
            return base.Delete(id);
        }

    }
}
