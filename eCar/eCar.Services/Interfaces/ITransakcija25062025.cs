using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface ITransakcija25062025:ICRUDService<Model.Model.Transakcija250602025,
        Transkacija25062025SearchObject,Transakcija250602025InsertRequest,Transakcija25062025UpdateRequest>
    {
        IActionResult GetTotalHrana(Transkacija25062025SearchObject search);
        IActionResult GetTotalZabava(Transkacija25062025SearchObject search);
        IActionResult GetTotalPlata(Transkacija25062025SearchObject search);
    }
}
