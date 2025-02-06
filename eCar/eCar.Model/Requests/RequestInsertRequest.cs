using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class RequestInsertRequest
    {
        public int RouteId { get; set; }
        public int DriverId { get; set; }
    }
}
