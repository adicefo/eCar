using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{
    [ApiController]
    public class Transakcija25062025Controller : BaseCRUDController<Model.Model.Transakcija250602025,
        Transkacija25062025SearchObject,Transakcija250602025InsertRequest,Transakcija25062025UpdateRequest>
    {
        public Transakcija25062025Controller(ITransakcija25062025 service):base(service)
        {
        }

        
        public override Model.Model.Transakcija250602025 Insert(Transakcija250602025InsertRequest request)
        {
            return (_service as ITransakcija25062025).Insert(request);
        }

        [AllowAnonymous]
        [HttpGet("GetTotalHrana")]
        public IActionResult GetTotalHrana([FromQuery] Transkacija25062025SearchObject searchObject)
        {
            return (_service as ITransakcija25062025).GetTotalHrana(searchObject);
        }
        [AllowAnonymous]
        [HttpGet("GetTotalZabava")]
        public IActionResult GetTotalZabava([FromQuery] Transkacija25062025SearchObject searchObject)
        {
            return (_service as ITransakcija25062025).GetTotalZabava(searchObject);
        }
        [AllowAnonymous]
        [HttpGet("GetTotalPlata")]
        public IActionResult GetTotalPlata([FromQuery] Transkacija25062025SearchObject searchObject)
        {
            return (_service as ITransakcija25062025).GetTotalPlata(searchObject);
        }
    }
}
