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
    public class UsersController : BaseController<Model.Model.User,UserSearchObject>
    {

        public UsersController(IUserService service):base(service)
        {
           
        }


       /* [HttpPost]
        public User Insert(UserInsertRequest request)
        {
            return _service.Insert(request);
        }

        [HttpPut("{id}")]
        public User Update(int id,UserUpdateRequest request)
        {
            return _service.Update(id,request);
        }*/
    }
}
