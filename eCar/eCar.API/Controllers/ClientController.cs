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
        ,ClientInserRequest,ClientUpdateRequest>
    {
        public ClientController(IClientService service):base(service)
        {
           
        }
        [AllowAnonymous]
        public override Client Insert(ClientInserRequest request)
        {
            return base.Insert(request);
        }

        [HttpPost("/Client/InsertBasedOnUser/{userId}")]
        public Model.Model.Client InsertBasedOnUser(int userId)
        {
            return (_service as IClientService).InsertBasedOnUser(userId);
        }
    }
}
