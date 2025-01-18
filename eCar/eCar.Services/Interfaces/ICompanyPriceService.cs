using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface ICompanyPriceService:ICRUDService<Model.Model.CompanyPrice,CompanyPriceSearchObject,
        CompanyPriceInsertRequest,CompanyPriceUpdateRequest>
    {
        Model.Model.CompanyPrice GetCurrentPrice();
    }
}
