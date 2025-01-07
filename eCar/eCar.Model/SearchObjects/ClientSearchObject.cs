using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObjects
{
    public class ClientSearchObject:BaseSearchObject
    {
        public string? NameGTE { get; set; }
        public string? SurenameGTE { get; set; }
        public string? Username { get; set; }
        public bool IsUserIncluded { get; set; } = true;
    }
}
