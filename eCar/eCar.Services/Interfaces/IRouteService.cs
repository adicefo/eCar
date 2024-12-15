using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IRouteService
    {
        List<Route> GetRoutes(RouteSearchObject searchObject);
        Model.Model.Route Insert(RouteInsertRequest request);

        Model.Model.Route UpdateBegin(int id);

        Model.Model.Route UpdateFinsih(int id);
    }
}
