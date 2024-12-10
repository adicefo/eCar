using eCar.Model;
using eCar.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RouteController : ControllerBase
    {
        protected IRouteService _service { get; set; }
        public RouteController(IRouteService service)
        {
            _service = service;
        }
        [HttpGet]
        public List<eCar.Model.Route> GetRoutes()
        {
            return _service.GetRoutes();
        }
    }
}
