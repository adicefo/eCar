using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class RentAvailabilityRequest
    {
        public int VehicleId { get; set; }
        public DateTime RentingDate { get; set; }
        public DateTime EndingDate { get; set; }
    }
}
