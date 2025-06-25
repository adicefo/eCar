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
    public class FinansijskiLimit25062025Service : BaseCRUDService<Model.Model.FinansijskiLimit25062025,
        FinansijskiLimit25062025SearchObject, Database.FinansijskiLimit250602025, FinansijskiLimit25062025InsertRequest, FinansijskiLimit25062025UpdateRequest>, IFinansijskiLimit25062025
    {
        public FinansijskiLimit25062025Service(ECarDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
