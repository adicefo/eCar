using eCar.Model.Requests;
using eCar.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.StateMachine.RentStateMachine
{
    public class InitialRentState:BaseRentState
    {
        public InitialRentState(ECarDbContext context,IMapper mapper,IServiceProvider serviceProvider)
            :base(context,mapper,serviceProvider) 
        { 
        }
        public override Model.Model.Rent Insert(RentInsertRequest request)
        {
            var set = Context.Set<Database.Rent>();
            Rent entity = Mapper.Map<Database.Rent>(request);
            Mapper.Map(request, entity);


            entity.Status = "wait";

            if (request.EndingDate < request.RentingDate)
                throw new Exception("Input valid dates");
            if (request.EndingDate != null && request.RentingDate != null)
                entity.NumberOfDays = (int)(request.EndingDate.Value - request.RentingDate.Value).TotalDays;
            else
                entity.NumberOfDays = 0;
            var vehicle = Context.Vehicles.Find(request.VehicleId);
            if (vehicle != null)
                entity.FullPrice = entity.NumberOfDays * vehicle.Price;
            else
                entity.FullPrice = 0;

            set.Add(entity);
            Context.SaveChanges();


            return Mapper.Map<Model.Model.Rent>(entity);
            
        }
        public override List<Enums.Action> AllowedActions(Database.Rent entity)
        {
            return new List<Enums.Action>() { Enums.Action.Insert };
        }

    }
}
