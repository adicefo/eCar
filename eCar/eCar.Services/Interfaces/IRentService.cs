
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eCar.Model.Model;
using eCar.Model.SearchObjects;
using eCar.Model.Requests;
namespace eCar.Services.Interfaces
{
    public interface IRentService:ICRUDService<Rent,RentSearchObject,
        RentInsertRequest,RentUpdateRequest>
    {
        Model.Model.Rent UpdateFinsih(int id);
    }
}
