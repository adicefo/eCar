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
    public class RentController : BaseCRUDController<Model.Model.Rent,
        RentSearchObject,RentInsertRequest,RentUpdateRequest>
    {
        
        public RentController(IRentService service):base(service) 
        { 

        }

        [HttpPut("Finish/{id}")]
        public Model.Model.Rent UpdateFinish(int id)
        {
            return (_service as IRentService).UpdateFinsih(id);
        }
        [HttpGet("Actions/{id}")]
        public List<Services.Enums.Action> AllowedActions(int id)
        {
            return (_service as IRentService).AllowedActions(id);
        }
    }
}
