using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public  class Notification
    {
        public int Id { get; set; }

        public string? Heading { get; set; }

        public string? Content_ { get; set; }

        public byte[]? Image { get; set; }

        public DateTime? AddingDate { get; set; }

        public bool? IsForClient { get; set; }

        public string? Status { get; set; }
    }
}
