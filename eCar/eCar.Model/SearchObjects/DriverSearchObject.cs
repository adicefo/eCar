using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObjects
{
    public class DriverSearchObject:BaseSearchObject
    {
        public string? NameGTE { get; set; }
        public string? SurnameGTE { get; set; }
        public bool IsUserIncluded { get; set; }
    }
}
