using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObjects
{
    public class CompanyPriceSearchObject:BaseSearchObject
    {
        public decimal? PricePerKilometarGTE { get; set; }
        public decimal? PricePerKilometarLTE { get; set; }
    }
}
