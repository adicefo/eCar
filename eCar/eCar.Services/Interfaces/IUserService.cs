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
      
    }
}
