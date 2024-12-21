using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObject;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{

    [ApiController]
    public class ClientController : BaseCRUDController<Model.Model.Client,ClientSearchObject
        ,ClientUpsertRequest,ClientUpsertRequest>
    {
        public ClientController(IClientService service):base(service)
        {
           
        }
        [AllowAnonymous]
        public override Client Insert(ClientUpsertRequest request)
        {
            return base.Insert(request);
        }
    }
}
