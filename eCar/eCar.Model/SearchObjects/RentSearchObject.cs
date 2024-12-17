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
        public int? VehicleId { get; set; }
        public int? NumberOfDaysLETE { get; set; }
        public int? NumberOfDaysGETE { get; set; }
        public decimal? FullPriceGTE { get; set; }
        public decimal? FullPriceLTE { get; set; }
        public DateTime? RentingDate { get; set; }
        public DateTime? EndingDate { get; set; }


    }
}
