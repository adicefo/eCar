using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObject;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BaseController<TModel, TSearch> : ControllerBase where TSearch : BaseSearchObject where TModel : class
    {
        protected IService<TModel, TSearch> _service;

        public BaseController(IService<TModel, TSearch> service)
        {
            _service = service;
        }


        [HttpGet]
        public List<TModel> Get([FromQuery] TSearch searchObject)
        {
            return _service.Get(searchObject);
        }

        [HttpGet("{id}")]
        public TModel GetById(int id)
        {
            return _service.GetById(id);
        }
    }
}
