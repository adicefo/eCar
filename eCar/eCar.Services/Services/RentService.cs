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
    public class RentService:BaseCRUDService<Model.Model.Rent,
        RentSearchObject,Database.Rent,RentInsertRequest,RentUpdateRequest>,IRentService
    {
        public RentService(ECarDbContext context,IMapper mapper):base(context,mapper) 
        {
            
        }
        public Model.Model.Rent UpdateFinsih(int id)
        {
            var entity = Context.Rents.Find(id);
            if (entity == null)
                throw new Exception("Non-existed model");
            entity.Status = "finished";
            Context.Rents.Update(entity);
            Context.SaveChanges();

            var result = Mapper.Map<Model.Model.Rent>(entity);

            return result;
        }
        public override IQueryable<Rent> AddFilter(RentSearchObject search, IQueryable<Rent> query)
        {
            //TODO:Fix condition for VehicleId
            var filteredQuery = base.AddFilter(search, query);
            if (!string.IsNullOrWhiteSpace(search.Status))
                filteredQuery = filteredQuery.Where(x => x.Status == search.Status);
            if (Context.Rents.Find(search.VehicleId)!=null)
                filteredQuery = filteredQuery.Where(x=>x.VehicleId==search.VehicleId);
            if (search.NumberOfDaysLETE!=null&&search.NumberOfDaysLETE>0)
                filteredQuery = filteredQuery.Where(x => x.NumberOfDays <= search.NumberOfDaysLETE);
            if (search.NumberOfDaysGETE!=null)
                filteredQuery = filteredQuery.Where(x => x.NumberOfDays >= search.NumberOfDaysGETE);
            if (search.FullPriceLTE != null)
                filteredQuery = filteredQuery.Where(x => x.FullPrice < search.FullPriceLTE);
            if(search.FullPriceGTE!=null)
                filteredQuery=filteredQuery.Where(x=>x.FullPrice>search.FullPriceGTE);
            if(search.RentingDate!=null)
                filteredQuery=filteredQuery.Where(x=>x.Equals(search.RentingDate));
            if (search.EndingDate != null)
                filteredQuery = filteredQuery.Where(x => x.Equals(search.EndingDate));
            return filteredQuery;
        }
        public override void BeforeInsert(RentInsertRequest request, Rent entity)
        {
            
            entity.Status = "wait";
            if(request.EndingDate!=null&&request.RentingDate!=null)
                entity.NumberOfDays = (int)(request.EndingDate.Value - request.RentingDate.Value).TotalDays;
            else
                entity.NumberOfDays = 0;
            var vehicle=Context.Vehicles.Find(request.VehicleId);
            if(vehicle!=null)
                entity.FullPrice = entity.NumberOfDays * vehicle.Price;
            else
                entity.FullPrice= 0;
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(RentUpdateRequest request, Rent entity)
        {
            entity.Status = "active";
            base.BeforeUpdate(request, entity);
        }

        
    }
}
