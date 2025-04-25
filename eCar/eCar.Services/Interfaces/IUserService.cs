using eCar.Model.Helper;
using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IUserService:ICRUDService<Model.Model.User,UserSearchObject,
        UserInsertRequest,UserUpdateRequest>
    {
        public AuthResponse AuthenticateUser(string username,string password,string role);
        public Model.Model.User GetBasedOnToken(string token);

        public Model.Model.User UpdatePassword(int id,UserUpdatePasswordRequest request);
    }
}
