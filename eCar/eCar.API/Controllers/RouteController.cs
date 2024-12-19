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
    public class RouteController :BaseCRUDController<Model.Model.Route,
        RouteSearchObject,RouteInsertRequest,RouteUpdateRequest>
    {
        public RouteController(IRouteService service):base(service)
        {
            
        }
       [HttpPut("Finish/{id}")]
       public Model.Model.Route UpdateFinish(int id)
       {
           return (_service as IRouteService).UpdateFinsih(id);
       }
        [HttpGet("Actions/{id}")]
        public List<Services.Enums.Action> AllowedActions(int id)
        {
            return (_service as IRouteService).AllowedActions(id);
        }
    }
}
