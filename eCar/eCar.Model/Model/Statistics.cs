using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class Statistics
    {
        public int Id { get; set; }

        public int? NumberOfHours { get; set; }

        public int? NumberOfClients { get; set; }

        public decimal? PriceAmount { get; set; }

        public DateTime? BeginningOfWork { get; set; }

        public DateTime? EndOfWork { get; set; }

        public int DriverId { get; set; }

        public virtual Driver Driver { get; set; } = null!;
    }
}
