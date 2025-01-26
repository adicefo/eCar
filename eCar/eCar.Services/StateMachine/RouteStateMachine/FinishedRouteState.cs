using eCar.Services.Database;
using MapsterMapper;
using EF=Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

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
            var set = Context.Set<Database.Route>().AsQueryable();
            var entity = set.Include(x => x.Client).ThenInclude(x=>x.User).Include(d=>d.Driver).ThenInclude(x=>x.User).FirstOrDefault(x => x.Id == id);
            if (entity == null)
                throw new Exception("Non-existed model");

            entity.EndDate = DateTime.Parse("2025 - 01 - 26T10: 00:00.148Z");
            entity.Duration = (int)(entity.EndDate.Value - entity.StartDate!.Value).TotalMinutes;
            entity.Status = "finished";

            Context.Routes.Update(entity);
            Context.SaveChanges();

            var result = Mapper.Map<Model.Model.Route>(entity);

            return result;
        }
        public override List<Enums.Action> AllowedActions(Route entity)
        {
            return new List<Enums.Action> { Enums.Action.UpdateFinish, Enums.Action.Delete };
        }
    }
}
