using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Database
{
    public class FinansijskiLimit250602025
    {
        public int Id { get; set; }
        public double Limit { get; set; }

        public int KorisnikId { get; set; }
        public int KategorijaId { get; set; }

        public virtual User Korisnik { get; set; } = null!;
        public virtual KategorijaTransakcije250602025 Kategorija { get; set; } = null!;
    }

}
