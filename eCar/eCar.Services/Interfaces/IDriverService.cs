using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IDriverService:ICRUDService<Model.Model.Driver,
        DriverSearchObject,DriverInsertRequest,DriverUpdateRequest>
    {
        public Model.Model.Driver InsertBasedOnUser(int userId);
    }
}
