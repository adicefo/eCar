using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Services
{
    public class KategorijaTransakcije25062025Service : BaseCRUDService<Model.Model.KategorijaTranskacije25062025,
        KategorijaTransakcije25062025SearchObject, Database.KategorijaTransakcije250602025, KategorijaTransakcije25062025InsertRequest, KategorijaTransakcije250602025UpdateRequest>,IKategorijaTranskacije25062025
    {
        public KategorijaTransakcije25062025Service(ECarDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
