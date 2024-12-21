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
    public class AdminController : BaseCRUDController<Model.Model.Admin,AdminSearchObject
        ,AdminInsertRequest,AdminUpdateRequest>
    {
        public AdminController(IAdminService service):base(service)
        {
           
        }
        [AllowAnonymous]
        public override Admin Insert(AdminInsertRequest request)
        {
            return base.Insert(request);
        }
    }
}
