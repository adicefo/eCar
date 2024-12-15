using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObjects
{
    public class VehicleSearchObject:BaseSearchObject
    {
        public bool? IsAvailable { get; set; }
        public string? NameCTS { get; set; }

    }
}
