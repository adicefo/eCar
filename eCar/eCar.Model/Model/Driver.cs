using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class Driver
    {
        public int Id { get; set; }

        public int UserID { get; set; }

        public int? NumberOfHoursAmount { get; set; }

        public int? NumberOfClientsAmount { get; set; }

        public virtual User User { get; set; } = null!;
    }
}
