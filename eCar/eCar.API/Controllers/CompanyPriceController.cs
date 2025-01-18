using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RentACar.Model;

namespace eCar.API.Controllers
{
    [ApiController]
    public class CompanyPriceController :BaseCRUDController<Model.Model.CompanyPrice,
        CompanyPriceSearchObject,CompanyPriceInsertRequest,CompanyPriceUpdateRequest>
    {
        public CompanyPriceController(ICompanyPriceService service):base(service)
        {
        }
        [Authorize(Roles = "Admin,Driver")]
        [HttpGet("/CompanyPrice/GetCurrenPrice")]
        public Model.Model.CompanyPrice GetCurrentPrice()
        {
            return (_service as ICompanyPriceService).GetCurrentPrice();
        }


        [Authorize(Roles ="Admin,Driver")]
        public override PagedResult<CompanyPrice> Get([FromQuery] CompanyPriceSearchObject searchObject)
        {
            return base.Get(searchObject);

        }
        [Authorize(Roles = "Admin")]
        public override CompanyPrice GetById(int id)
        {
            return base.GetById(id);
        }
        [Authorize(Roles ="Admin")]
        public override CompanyPrice Insert(CompanyPriceInsertRequest request)
        {
            return base.Insert(request);
        }
        [Authorize(Roles = "Admin")]

        public override CompanyPrice Delete(int id)
        {
            return base.Delete(id);
        }

    }
}
