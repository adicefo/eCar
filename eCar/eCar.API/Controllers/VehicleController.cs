﻿using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObject;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using eCar.Services.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{

    [ApiController]
    [Route("[controller]")]
    public class VehicleController : BaseCRUDController<Model.Model.Vehicle,
        VehicleSearchObject,VehicleInsertRequest,VehicleUpdateRequest>
    {
        
        public VehicleController(IVehicleService service):base(service) 
        { 

        }
                 
    }
}
