using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class Review
    {
        public int Id { get; set; }

        public int? Value { get; set; }

        public string? Description { get; set; }

        public int ReviewsId { get; set; }

        public int ReviewedId { get; set; }

        public int RouteId { get; set; }

        public virtual Driver Reviewed { get; set; } = null!;

        public virtual Client Reviews { get; set; } = null!;

        public virtual Route Route { get; set; } = null!;
    }
}
