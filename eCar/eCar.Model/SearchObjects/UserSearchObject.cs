using eCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObject
{
    public class UserSearchObject:BaseSearchObject
    {
        public string? NameGTE { get; set; }
        public string? SurnameGTE { get; set; }
        public string? Email { get; set; }
        public string? Username { get; set; }
     
    }
}
