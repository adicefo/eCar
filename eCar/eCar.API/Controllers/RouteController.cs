using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RouteController : ControllerBase
    {
        protected IRouteService _service;
        public RouteController(IRouteService service)
        {
            _service = service;
        }
        [HttpGet]
        public List<Model.Model.Route> GetRoutes([FromQuery]RouteSearchObject searchObject)
        {
            return _service.GetRoutes(searchObject);
        }
        [HttpPost]
        public Model.Model.Route Insert(RouteInsertRequest request)
        {
            return _service.Insert(request);
        }
        [HttpPut("Begin{id}")]
        public Model.Model.Route UpdateBegin(int id)
        {
            return _service.UpdateBegin(id);
        }

        [HttpPut("Finish{id}")]
        public Model.Model.Route UpdateFinish(int id)
        {
            return _service.UpdateFinsih(id);
        }
    }
}
