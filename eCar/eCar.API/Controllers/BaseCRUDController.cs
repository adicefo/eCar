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
    public class BaseCRUDController<TModel, TSearch,TInsert,TUpdate> : BaseController<TModel,TSearch> where TSearch:BaseSearchObject where TModel :class
    {
        protected new ICRUDService<TModel, TSearch, TInsert, TUpdate> _service;
        public BaseCRUDController(ICRUDService<TModel, TSearch,TInsert,TUpdate> service):base(service)
        {
            _service = service;
        }


        [HttpPost]
        public TModel Insert(TInsert request)
        { 
            return _service.Insert(request);
        }


        [HttpPut("{id}")]
        public TModel Update(int id,TUpdate request)
        {
            return _service.Update(id,request);
        }

        [HttpDelete("{id}")]
        public TModel Delete(int id)
        {
            return _service.Delete(id);
        }
    }
}
