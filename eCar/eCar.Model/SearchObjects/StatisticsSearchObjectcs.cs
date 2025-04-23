using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObjects
{
    public class StatisticsSearchObjectcs:BaseSearchObject
    {
        public int? DriverId { get; set; }
        public string? DriverName { get; set; }
        public DateTime? BeginningOfWork { get; set; }
    }
}
