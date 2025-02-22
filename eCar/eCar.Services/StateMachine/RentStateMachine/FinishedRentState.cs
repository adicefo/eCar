using eCar.Model.Requests;
using eCar.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.StateMachine.RentStateMachine
{
    public class FinishedRentState:BaseRentState
    {
        public FinishedRentState(ECarDbContext context,IMapper mapper,IServiceProvider serviceProvider)
            :base(context,mapper,serviceProvider)
        {
            
        }
        public override Model.Model.Rent Update(int id, RentUpdateRequest request)
        {
            var set = Context.Set<Database.Rent>();
            var entity = set.Find(id);
            if (entity == null)
                throw new Exception("Non-existed model");

            entity = Mapper.Map(request, entity);

            if (request.EndingDate != null)
            {
                if (entity.EndingDate < entity.RentingDate)
                    throw new Exception("Input valid dates");
                if (entity.EndingDate != null && entity.RentingDate != null)
                    entity.NumberOfDays = (int)(request.EndingDate.Value - entity.RentingDate.Value).TotalDays;
                else
                    entity.NumberOfDays = 0;
            }
            var vehicle = Context.Vehicles.Find(request.VehicleId);
            if (vehicle != null)
                entity.FullPrice = entity.NumberOfDays * vehicle.Price;
            else
                entity.FullPrice = 0;

            Context.SaveChanges();

            return Mapper.Map<Model.Model.Rent>(entity);
        }
        public override Model.Model.Rent UpdatePayment(int id)
        {
            var set = Context.Set<Database.Rent>().AsQueryable();
            var entity = set.Include(x => x.Client).ThenInclude(x => x.User).Include(x=>x.Vehicle).FirstOrDefault(x => x.Id == id);
            if (entity == null)
                throw new Exception("Non-existed model");

            entity.Paid = true;

            Context.Rents.Update(entity);
            Context.SaveChanges();

            var result = Mapper.Map<Model.Model.Rent>(entity);

            return result;
        }
        public override Model.Model.Rent UpdateFinish(int id)
        {
            var entity = Context.Rents.Find(id);
            if (entity == null)
                throw new Exception("Non-existed model");
            entity.Status = "finished";
            Context.Rents.Update(entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Model.Rent>(entity); 
        
        }
        public override List<Enums.Action> AllowedActions(Database.Rent entity)
        {
            return new List<Enums.Action>() { Enums.Action.UpdateFinish};
        }

    }
}
