using eCar.Services.Database;
using MapsterMapper;
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
