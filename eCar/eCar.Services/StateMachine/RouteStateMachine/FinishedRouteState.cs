using eCar.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.StateMachine.RouteStateMachine
{
    public class FinishedRouteState:BaseRouteState
    {
        public FinishedRouteState(ECarDbContext context, IMapper mapper, IServiceProvider serviceProvider) :
           base(context, mapper, serviceProvider)
        {

        }

        public override Model.Model.Route UpdateFinish(int id)
        {
            var entity = Context.Routes.Find(id);
            if (entity == null)
                throw new Exception("Non-existed route");

            entity.EndDate = DateTime.Now;
            entity.Duration = (int)(entity.EndDate.Value - entity.StartDate!.Value).TotalMinutes;
            entity.Status = "finished";

            Context.Routes.Update(entity);
            Context.SaveChanges();

            var result = Mapper.Map<Model.Model.Route>(entity);

            return result;
        }
    }
}
