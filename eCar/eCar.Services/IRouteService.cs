using eCar.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services
{
    public interface IRouteService
    {
        List<Route> GetRoutes();
    }
}
