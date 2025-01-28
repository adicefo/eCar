using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObjects
{
    public class DriverVehicleSearchObject:BaseSearchObject
    {
        public int? DriverId { get; set; }
        public int? VechicleId { get; set; }
        public DateTime? DatePickUp { get; set; }
    }
}
