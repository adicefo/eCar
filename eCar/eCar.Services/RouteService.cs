using eCar.Model;
using Microsoft.SqlServer.Types;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services

{
    public class RouteService : IRouteService
    {
        public List<Route> Routes = new List<Route>()
            {
                new Route()
                {
                    Id=1,
                    SourcePoint=null,
                    DestinationPoint=null,
                    StartDate=DateTime.Now,
                    EndDate=DateTime.Now,
                    Duration=200,
                    NumberOfKilometars=1,
                    FullPrice=20202,
                    Status="active"

                },
                new Route()
                {
                    Id=2,
                    SourcePoint=null,
                    DestinationPoint=null,
                    StartDate=DateTime.Now,
                    EndDate=DateTime.Now,
                    Duration=300,
                    NumberOfKilometars=2,
                    FullPrice=33332,
                    Status="active"

                }
            };
        public List<Route> GetRoutes()
        { return Routes; }
    };


}
