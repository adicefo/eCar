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
    public interface IUserService:IService<User,UserSearchObject>
    {
        Model.Model.User Insert(UserInsertRequest request);
        Model.Model.User Update(int id,UserUpdateRequest request);
    }
}
