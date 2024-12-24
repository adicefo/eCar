using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IClientService:ICRUDService<Model.Model.Client,
        ClientSearchObject, ClientUpsertRequest, ClientUpsertRequest>
    {
        public Model.Model.Client InsertBasedOnUser(int userId);
    }
}
