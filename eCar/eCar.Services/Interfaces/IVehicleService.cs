using eCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IVehicleService:IService<Model.Model.Vehicle,VehicleSearchObject>
    { 
    }
}
