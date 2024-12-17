using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObject;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{

    [ApiController]
    [Route("[controller]")]
    public class UsersController : BaseCRUDController<Model.Model.User,UserSearchObject
        ,UserInsertRequest,UserUpdateRequest>
    {
        public UsersController(IUserService service):base(service)
        {
           
        }
    }
}
