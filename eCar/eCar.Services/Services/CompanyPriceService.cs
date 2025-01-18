using eCar.Model.Helper;
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
    public class CompanyPriceService:BaseCRUDService<Model.Model.CompanyPrice,
        CompanyPriceSearchObject,Database.CompanyPrice,CompanyPriceInsertRequest,CompanyPriceUpdateRequest>,ICompanyPriceService
    {
        public CompanyPriceService(ECarDbContext context,IMapper mapper):base(context,mapper) 
        {
            
        }
        public Model.Model.CompanyPrice GetCurrentPrice()
        {
            var entity = Context.CompanyPrices.OrderBy(x=>x.Id).LastOrDefault();
            return Mapper.Map<Model.Model.CompanyPrice>(entity);
        }
        public override Model.Model.CompanyPrice Update(int id, CompanyPriceUpdateRequest request)
        {
            //update disabled
            var entity = Context.CompanyPrices.Find(id);
            if (entity == null)
                return null ;
            return Mapper.Map<Model.Model.CompanyPrice>(entity);
        }
        public override IQueryable<CompanyPrice> AddFilter(CompanyPriceSearchObject search, IQueryable<CompanyPrice> query)
        {
            var filteredQuery= base.AddFilter(search, query);
            if (search.PricePerKilometarGTE != null)
                filteredQuery = filteredQuery.Where(x => x.PricePerKilometar >= search.PricePerKilometarGTE);
            if (search.PricePerKilometarLTE != null)
                filteredQuery = filteredQuery.Where(x => x.PricePerKilometar <= search.PricePerKilometarLTE);
            return filteredQuery;
        }
        public override void BeforeInsert(CompanyPriceInsertRequest request, CompanyPrice entity)
        {
            if (request.PricePerKilometar < 1 || request.PricePerKilometar > 15)
                throw new UserException("Invalid price... Might be too low or too high");
            entity.AddingDate= DateTime.Now;
            base.BeforeInsert(request, entity);
        }
    }
}
