using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RentACar.Model;

namespace eCar.API.Controllers
{
    [ApiController]
    public class StatisticsController :BaseCRUDController<Model.Model.Statistics,
        StatisticsSearchObjectcs,StatisticsInsertRequest,StatisticsUpdateRequest>
    {
        public StatisticsController(IStatisticsService service):base(service)
        {
        }

        //[Authorize(Roles ="Driver")]
        public override Statistics Insert(StatisticsInsertRequest request)
        {
            return base.Insert(request);
        }
       // [Authorize(Roles = "Driver")]
        public override Statistics Update(int id, StatisticsUpdateRequest request)
        {
            return base.Update(id, request);
        }
       // [Authorize(Roles ="Driver")]
        [HttpPut("Finish/{id}")]
        public Model.Model.Statistics UpdateFinish(int id)
        {
            return (_service as IStatisticsService).UpdateFinsih(id);
        }

    }
}
