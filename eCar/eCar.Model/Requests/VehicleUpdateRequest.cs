using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class VehicleUpdateRequest
    {
        public bool? Available { get; set; }

        public double? AverageConsumption { get; set; }

        public string? Name { get; set; }

        public byte[]? Image { get; set; }

        public decimal Price { get; set; }
    }
}
