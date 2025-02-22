using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObjects
{
    public class RentSearchObject:BaseSearchObject
    {
        public string? Status { get; set; }
        public string? StatusNot { get; set; }
        public int? VehicleId { get; set; }
        public int? ClientId { get; set; }

        public DateTime? RentingDate { get; set; }
        public DateTime? EndingDate { get; set; }


    }
}
