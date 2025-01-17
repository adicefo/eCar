using eCar.Model.Helper;
using eCar.Model.Requests;
using eCar.Services.Database;
using MapsterMapper;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
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
        public override Model.Model.Rent UpdateActive(int id)
        {
            var entity = Context.Rents.Find(id);
            if (entity == null)
                throw new Exception("Non-existed model");
            entity.Status = "active";
            Context.Rents.Update(entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Model.Rent>(entity);

        }

        public override IActionResult ChechAvailability(int id, RentAvailabilityRequest request)
        {
            var entity= Context.Rents.Find(id);
            if (entity == null) throw new UserException("Non-existed model");
            var vehicle= Context.Vehicles.Find(request.VehicleId);
            if (vehicle == null || request.EndingDate.Date <= request.RentingDate.Date||
                (request.RentingDate.Date!=entity.RentingDate.Value.Date)||
                (request.EndingDate.Date!=entity.EndingDate.Value.Date))
                throw new UserException("Input valid data");
            bool isAvailable= Context.Rents.Any(x=>x.VehicleId==vehicle.Id&&x.Status=="active"&&request.RentingDate<x.EndingDate&&request.EndingDate>x.RentingDate);
            return new OkObjectResult (new {IsAvailable=!isAvailable});

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
        public override List<Enums.Action> AllowedActions(Database.Rent entity)
        {
            return new List<Enums.Action>() { Enums.Action.Update,Enums.Action.UpdateActive,Enums.Action.Delete };
        }
    }
}
