﻿using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IRouteService:ICRUDService<Model.Model.Route,
        RouteSearchObject,RouteInsertRequest,RouteUpdateRequest>
    {
       Model.Model.Route UpdateFinsih(int id);
       List<Enums.Action> AllowedActions(int id);
    }
}
