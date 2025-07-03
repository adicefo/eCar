using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database
{
    public class TranskacijaLog25062025
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public double StariIznos { get; set; }
        public string StariOpis { get; set; }
        public string StariStatus { get; set; }
        public double NoviIznos { get; set; }
        public string NoviOpis { get; set; }
        public string NoviStatus { get; set; }

        public string Kategorija { get; set; }
        public TimeOnly VrijemeLog { get; set; }
        public virtual User Korisnik { get; set; } = null!;

    }
}
