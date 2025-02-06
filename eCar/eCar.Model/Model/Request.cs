using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class Request
    {
        public int Id { get; set; }

        public bool? IsAccepted { get; set; }

        public int RouteId { get; set; }

        public int DriverId { get; set; }

        public virtual Driver Driver { get; set; } = null!;

        public virtual Route Route { get; set; } = null!;
    }
}
