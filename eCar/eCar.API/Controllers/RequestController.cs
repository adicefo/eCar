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
    [Route("[controller]")]
    [ApiController]
    public class RequestController : BaseCRUDController<Model.Model.Request,
        RequestSearchObject,RequestInsertRequest,RequestUpdateRequest>
    {
        
        public RequestController(IRequestService service):base(service) 
        { 

        }
       

    }
}
