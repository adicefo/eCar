using Microsoft.Extensions.DependencyInjection;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eCar.Model.Requests;
using eCar.Services.Database;
using eCar.Services.StateMachine.RentStateMachine;
using eCar.Model.Helper;
namespace eCar.Services.StateMachine.RouteStateMachine
{
    public class BaseRouteState
    {
        public ECarDbContext Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }
        public BaseRouteState(ECarDbContext context, IMapper mapper,IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }
        //state wait
        public virtual Model.Model.Route Insert(RouteInsertRequest request)
        {
            throw new UserException("Not allowed");
        }
        //state active
        public virtual Model.Model.Route Update(int id,RouteUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }
        //state finished
        public virtual Model.Model.Route UpdateFinish(int id)
        {
            throw new UserException("Not allowed");
        }
        public virtual Model.Model.Route UpdatePayment(int id)
        {
            throw new UserException("Not allowed");

        }
        public virtual List<Enums.Action> AllowedActions(Database.Route entity)
        {
            throw new UserException("Not allowed");
        }
        public BaseRouteState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return ServiceProvider.GetService<InitialRouteState>();
                case "wait":
                    return ServiceProvider.GetService<WaitRouteState>();
                case "active":
                    return ServiceProvider.GetService<FinishedRouteState>();
                case "finished":
                    return ServiceProvider.GetService<WaitRouteState>();
                default:
                    throw new Exception("State not recognized");
            }
        }
    }
}
