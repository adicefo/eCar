using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class NotificationUpdateRequest
    {
        public string? Heading { get; set; }

        public string? Content_ { get; set; }

        public byte[]? Image { get; set; }

        public bool? IsForClient { get; set; }

        public string? Status { get; set; }
    }
}
