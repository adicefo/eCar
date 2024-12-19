using eCar.Model.Requests;
using eCar.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.StateMachine.RouteStateMachine
{
    public  class WaitRouteState:BaseRouteState
    {
        public WaitRouteState(ECarDbContext context, IMapper mapper, IServiceProvider serviceProvider) :
           base(context, mapper, serviceProvider)
        {

        }

        public override Model.Model.Route Update(int id, RouteUpdateRequest request)
        {
            var set = Context.Set<Database.Route>();
            var entity = set.Find(id);
            if (entity == null)
                throw new Exception("Non-existed model");

            entity = Mapper.Map(request, entity);

            entity.StartDate = DateTime.Now;
            entity.Status = "active";

            Context.SaveChanges();

            return Mapper.Map<Model.Model.Route>(entity);
        }
        public override List<Enums.Action> AllowedActions(Route entity)
        {
            return new List<Enums.Action> { Enums.Action.Update,Enums.Action.Delete };
        }
    }
}
