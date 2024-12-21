using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObject;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{

    [ApiController]
    public class DriverController : BaseCRUDController<Model.Model.Driver,DriverSearchObject
        ,DriverInsertRequest,DriverUpdateRequest>
    {
        public DriverController(IDriverService service):base(service)
        {
           
        }
        [Authorize(Roles ="Admin")]
        public override Driver Insert(DriverInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override Driver Update(int id, DriverUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles ="Admin")]
        public override Driver Delete(int id) 
        { 
            return base.Delete(id);
        }
    }
}
