using eCar.Model.Requests;
using eCar.Services.Database;
using eCar.Services.StateMachine.RouteStateMachine;
using MapsterMapper;
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
            throw new Exception("Not allowed");
        }
        //state active
        public virtual Model.Model.Rent Update(int id, RentUpdateRequest request)
        {
            throw new Exception("Action not allowed");
        }
        //state finished
        public virtual Model.Model.Rent UpdateFinish(int id)
        {
            throw new Exception("Action not allowed");
        }
        //from status wait only you can delete
        public virtual Model.Model.Rent Delete(int id)
        {
            throw new Exception("Action not allowed");
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
