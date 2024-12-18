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
    public  class WaitRentState:BaseRentState
    {
        public WaitRentState(ECarDbContext context, IMapper mapper, IServiceProvider serviceProvider) :
           base(context, mapper, serviceProvider)
        {

        }

        public override Model.Model.Rent Update(int id, RentUpdateRequest request)
        {
            var set = Context.Set<Database.Rent>();
            var entity = set.Find(id);
            if (entity == null)
                throw new Exception("Non-existed model");

            entity = Mapper.Map(request, entity);

            entity.Status = "active";

            Context.SaveChanges();

            return Mapper.Map<Model.Model.Rent>(entity);
        }
        public override Model.Model.Rent Delete(int id)
        {
            var set = Context.Set<Database.Rent>();

            var entity = set.Find(id);

            if (entity == null)
                throw new Exception("Non-existed model");

            set.Remove(entity);
            Context.SaveChanges();
            return Mapper.Map<Model.Model.Rent>(entity);
        }
    }
}
