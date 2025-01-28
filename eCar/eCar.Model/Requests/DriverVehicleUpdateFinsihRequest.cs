using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class DriverVehicleUpdateFinsihRequest
    {
        public int DriverId { get; set; }
        public DateTime DatePickUp { get; set; }
    }
}
