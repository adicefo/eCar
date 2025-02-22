using eCar.Model.Helper;
using eCar.Model.Requests;
using eCar.Services.Database;
using eCar.Services.StateMachine.RouteStateMachine;
using MapsterMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.StateMachine.RentStateMachine
{
    public class BaseRentState
    {
        public ECarDbContext Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }
        public BaseRentState(ECarDbContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }

        //state wait
        public virtual Model.Model.Rent Insert(RentInsertRequest request)
        {
            throw new UserException("Not allowed");
        }
        //state active
        public virtual Model.Model.Rent Update(int id, RentUpdateRequest request)
        {
            throw new UserException("Action not allowed");
        }
        //state wait
        public virtual Model.Model.Rent UpdateActive(int id)
        {
            throw new UserException("Action not allowed");
        }
        public virtual Model.Model.Rent UpdatePayment(int id)
        {
            throw new UserException("Action not allowed");
        }
        //state finished
        public virtual Model.Model.Rent UpdateFinish(int id)
        {
            throw new UserException("Action not allowed");
        }
        //from only status wait  you can delete
        public virtual Model.Model.Rent Delete(int id)
        {
            throw new UserException("Action not allowed");
        }
        public virtual IActionResult ChechAvailability(int id,RentAvailabilityRequest request)
        {
            throw new UserException("Action not allowed");
        }
        public virtual List<Enums.Action> AllowedActions(Database.Rent entity)
        {
            throw new UserException ("Not allowed");
        }
        public BaseRentState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return ServiceProvider.GetService<InitialRentState>();
                case "wait":
                    return ServiceProvider.GetService<WaitRentState>();
                case "active":
                   return ServiceProvider.GetService<FinishedRentState>();
                case "finished":
                    return ServiceProvider.GetService<WaitRentState>(); //allowing update and delete
                default:
                    throw new Exception("State not recognized");
            }
        }
    }
}
