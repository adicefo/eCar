using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IStatisticsService:ICRUDService<Model.Model.Statistics,
        StatisticsSearchObjectcs,StatisticsInsertRequest,StatisticsUpdateRequest>
    {
        Model.Model.Statistics UpdateFinsih(int id);
    }
}
