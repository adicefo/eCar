using eCar.Model.Helper;
using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObject;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{

    [ApiController]
    public class UsersController : BaseCRUDController<Model.Model.User,UserSearchObject
        ,UserInsertRequest,UserUpdateRequest>
    {
        public UsersController(IUserService service):base(service)
        {
           
        }
        [HttpPost("admin_login")]
        [AllowAnonymous]
        public AuthResponse AdminLogin([FromBody] LoginRequest login)
        {
            return (_service as IUserService).AuthenticateUser(login.Email,login.Password,"Admin");
        }
        [HttpPost("client_login")]
        [AllowAnonymous]
        public AuthResponse ClientLogin([FromBody,] LoginRequest login) 
        {
            return (_service as IUserService).AuthenticateUser(login.Email,login.Password,"Client");

        }
        [HttpPost("driver_login")]
        [AllowAnonymous]
        public AuthResponse DriverLogin([FromBody,] LoginRequest login)
        {
            return (_service as IUserService).AuthenticateUser(login.Email, login.Password, "Driver");

        }
        [HttpPut("updatePassword/{id}")]
        public Model.Model.User UpdatePassword(int id,UserUpdatePasswordRequest request)
        {
            return (_service as IUserService).UpdatePassword(id, request);
        }
        [HttpGet("token/{token}")]
        [AllowAnonymous]
        public Model.Model.User GetBasedOnToken(string token)
        {
            return (_service as IUserService).GetBasedOnToken(token);

        }
    }
}
