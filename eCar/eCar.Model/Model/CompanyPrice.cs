using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class CompanyPrice
    {
        public int Id { get; set; }

        public decimal PricePerKilometar { get; set; }
        public DateTime? AddingDate { get; set; }
    }
}
