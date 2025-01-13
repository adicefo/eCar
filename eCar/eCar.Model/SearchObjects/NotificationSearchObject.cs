using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObjects
{
    public class NotificationSearchObject:BaseSearchObject
    {
        public string? HeadingGTE { get; set; }

        public bool? IsForClient { get; set; }
    }
}
