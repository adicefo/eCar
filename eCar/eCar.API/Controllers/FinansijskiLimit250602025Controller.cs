using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{
    [ApiController]
    public class FinansijskiLimit250602025Controller : BaseCRUDController<Model.Model.FinansijskiLimit25062025,
        FinansijskiLimit25062025SearchObject,FinansijskiLimit25062025InsertRequest,FinansijskiLimit25062025UpdateRequest>
    {
        public FinansijskiLimit250602025Controller(IFinansijskiLimit25062025 service):base(service)
        {
        }

    }
}
