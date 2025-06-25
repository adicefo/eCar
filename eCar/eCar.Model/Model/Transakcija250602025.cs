using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class Transakcija250602025
    {
        public int Id { get; set; }
        public double Iznos { get; set; }
        public DateTime DatumTransakcije { get; set; }
        public string Opis { get; set; }
        public string Status { get; set; }
        public int KorisnikId { get; set; }
        public int KategorijaId { get; set; }
        public virtual User Korisnik { get; set; } = null!;
        public virtual KategorijaTranskacije25062025 Kategorija { get; set; } = null!;
    }
}
