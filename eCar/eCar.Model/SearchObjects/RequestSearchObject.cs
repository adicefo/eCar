using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObjects
{
    public  class RequestSearchObject: BaseSearchObject
    {
        public bool? IsAccepted { get; set; }
        public int? RouteId { get; set; }
        public int DriverId { get; set; }
    }
}
