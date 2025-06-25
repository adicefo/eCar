using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{
    [ApiController]
    public class KategorijaTranskacije25062025Controller : BaseCRUDController<Model.Model.KategorijaTranskacije25062025,
        KategorijaTransakcije25062025SearchObject,KategorijaTransakcije25062025InsertRequest,KategorijaTransakcije250602025UpdateRequest>
    {
        public KategorijaTranskacije25062025Controller(IKategorijaTranskacije25062025 service):base(service)
        {
        }

        
    }
}
