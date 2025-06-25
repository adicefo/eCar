using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class Transakcija250602025InsertRequest
    {
        public double Iznos { get; set; }
        public DateTime DatumTransakcije { get; set; }
        public string Opis { get; set; }
        public string Status { get; set; }
        public int KorisnikId { get; set; }
        public int KategorijaId { get; set; }
    }
}
