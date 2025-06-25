using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database
{
    public class KategorijaTransakcije250602025
    {
        public int Id { get; set; }
        public string Naziv { get; set; }
        public string Tip { get; set; }
        public virtual ICollection<Transakcija250602025> Transakcija250602025e { get; set; } = new List<Transakcija250602025>();
        public virtual ICollection<FinansijskiLimit250602025> FinansijskiLimit250602025e { get; set; } = new List<FinansijskiLimit250602025>();
    }
}
