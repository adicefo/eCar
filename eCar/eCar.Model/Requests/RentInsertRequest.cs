using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class RentInsertRequest
    {
        public DateTime? RentingDate { get; set; }
        public DateTime? EndingDate { get; set; }
        public int VehicleId { get; set; }
        public int ClientId{ get; set; }
    }
}
