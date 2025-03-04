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
    public class RentController : BaseCRUDController<Model.Model.Rent,
        RentSearchObject,RentInsertRequest,RentUpdateRequest>
    {
        
        public RentController(IRentService service):base(service) 
        {

        }
        [HttpPut("Active/{id}")]
        public Model.Model.Rent UpdateActive(int id)
        {
            return (_service as IRentService).UpdateActive(id);
        }
        [HttpPut("UpdatePayment/{id}")]
        public Model.Model.Rent UpdatePayment(int id)
        {
            return (_service as IRentService).UpdatePayment(id);
        }
        [AllowAnonymous]
        [HttpGet("Recommend/{vehicleId}")]
        public List<Model.Model.Rent> Recommend(int vehicleId)
        {
            return (_service as IRentService).Recommend(vehicleId);
        }

      
        [HttpPut("Finish/{id}")]
        public Model.Model.Rent UpdateFinish(int id)
        {
            return (_service as IRentService).UpdateFinsih(id);
        }
        [HttpPost("ChechAvailability/{id}")]
        public IActionResult CheckAvailability(int id,[FromBody]RentAvailabilityRequest request)
        {
            return (_service as IRentService).CheckAvailability(id,request);
        }
        [HttpGet("Actions/{id}")]
        public List<Services.Enums.Action> AllowedActions(int id)
        {
            return (_service as IRentService).AllowedActions(id);
        }
    }
}
