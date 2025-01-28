using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class DriverVehicle
    {
        public int Id { get; set; }

        public int DriverId { get; set; }

        public int VehicleId { get; set; }

        public DateTime? DatePickUp { get; set; }
        public DateTime? DateDropOff { get; set; }

        public virtual Driver Driver { get; set; } = null!;

        public virtual Vehicle Vehicle { get; set; } = null!;
    }
}
