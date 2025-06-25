using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class FinansijskiLimit25062025
    {

        public int Id { get; set; }
        public double Limit { get; set; }

        public int KorisnikId { get; set; }
        public int KategorijaId { get; set; }

        public virtual User Korisnik { get; set; } = null!;
        public virtual KategorijaTranskacije25062025 Kategorija { get; set; } = null!;
    }
}
