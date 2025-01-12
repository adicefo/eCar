using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IRevieweService:ICRUDService<Model.Model.Review,
        ReviewSearchObject,ReviewInsertRequest,ReviewUpdateRequest>
    {

    }
}
