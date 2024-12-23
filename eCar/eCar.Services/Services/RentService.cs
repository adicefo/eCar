﻿using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using eCar.Services.StateMachine.RentStateMachine;
using eCar.Services.StateMachine.RouteStateMachine;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Services
{
    public class RentService:BaseCRUDService<Model.Model.Rent,
        RentSearchObject,Database.Rent,RentInsertRequest,RentUpdateRequest>,IRentService
    {
        public BaseRentState BaseRentState { get; set; }
        public RentService(ECarDbContext context,IMapper mapper,BaseRentState baseRentState):base(context,mapper) 
        {
            BaseRentState = baseRentState;
        }
        public override Model.Model.Rent Insert(RentInsertRequest request)
        {
            var state = BaseRentState.CreateState("initial");
            return state.Insert(request);
        }
        public override Model.Model.Rent Update(int id,RentUpdateRequest request)
        {
            var entity = GetById(id);
            var state = BaseRentState.CreateState(entity.Status);
            return state.Update(id,request);
        }
        public override Model.Model.Rent Delete(int id)
        {
            var entity = GetById(id);
            var state = BaseRentState.CreateState(entity.Status);
            return state.Delete(id);
        }
        public Model.Model.Rent UpdateFinsih(int id)
        {
            var entity= GetById(id);
            var state=BaseRentState.CreateState(entity.Status);
            return state.UpdateFinish(id);
        }
        public List<Enums.Action> AllowedActions(int id)
        {
            if (id <= 0)
            {
                var state = BaseRentState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = Context.Rents.Find(id);
                var state = BaseRentState.CreateState(entity.Status);
                return state.AllowedActions(entity);
            }
        }
        public override IQueryable<Rent> AddFilter(RentSearchObject search, IQueryable<Rent> query)
        {
            var filteredQuery = base.AddFilter(search, query);
            if (!string.IsNullOrWhiteSpace(search.Status))
                filteredQuery = filteredQuery.Where(x => x.Status == search.Status);
            if (search.VehicleId!=null)
                filteredQuery = filteredQuery.Where(x=>x.VehicleId==search.VehicleId);
            if (search.NumberOfDaysLETE!=null&&search.NumberOfDaysLETE>0)
                filteredQuery = filteredQuery.Where(x => x.NumberOfDays <= search.NumberOfDaysLETE);
            if (search.NumberOfDaysGETE!=null)
                filteredQuery = filteredQuery.Where(x => x.NumberOfDays >= search.NumberOfDaysGETE);
            if (search.FullPriceLTE != null)
                filteredQuery = filteredQuery.Where(x => x.FullPrice < search.FullPriceLTE);
            if(search.FullPriceGTE!=null)
                filteredQuery=filteredQuery.Where(x=>x.FullPrice>search.FullPriceGTE);
            if(search.RentingDate!=null)
                filteredQuery=filteredQuery.Where(x=>x.Equals(search.RentingDate));
            if (search.EndingDate != null)
                filteredQuery = filteredQuery.Where(x => x.Equals(search.EndingDate));
            return filteredQuery;
        }
        public override void BeforeInsert(RentInsertRequest request, Rent entity)
        {
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(RentUpdateRequest request, Rent entity)
        {
            
            base.BeforeUpdate(request, entity);
        }

        
    }
}
