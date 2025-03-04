using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using eCar.Services.StateMachine.RentStateMachine;
using eCar.Services.StateMachine.RouteStateMachine;
using EFCore=Microsoft.EntityFrameworkCore;
using MapsterMapper;
using Nest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System.Data.Entity;

namespace eCar.Services.Services
{
    public class RentService:BaseCRUDService<Model.Model.Rent,
        RentSearchObject,Database.Rent,RentInsertRequest,RentUpdateRequest>,IRentService
    {
        public IRecommenderService _recommenderService { get; set; }
        public BaseRentState BaseRentState { get; set; }
        public RentService(ECarDbContext context,IMapper mapper,BaseRentState baseRentState,IRecommenderService recommenderService):base(context,mapper) 
        {
            BaseRentState = baseRentState;
            _recommenderService = recommenderService;
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
        public Model.Model.Rent UpdateActive(int id)
        {
            var entity = GetById(id);
            var state = BaseRentState.CreateState(entity.Status);
            return state.UpdateActive(id);
        }
        public Model.Model.Rent UpdatePayment(int id)
        {
            var entity = GetById(id);
            var state = BaseRentState.CreateState(entity.Status);
            return state.UpdatePayment(id);
        }
        public Model.Model.Rent UpdateFinsih(int id)
        {
            var entity= GetById(id);
            var state=BaseRentState.CreateState(entity.Status);
            return state.UpdateFinish(id);
        }
        public IActionResult CheckAvailability(int id,RentAvailabilityRequest request)
        {
            var entity = GetById(id);
            var state = BaseRentState.CreateState(entity.Status);
            return state.ChechAvailability(id,request);
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

        public List<Model.Model.Rent> Recommend(int vehicleId)
        {
            return _recommenderService.Recommend(vehicleId);
        }

       
       

        /* static MLContext mlContext = null;
         static object isLocked = new object();
         static ITransformer model = null;

         public List<Model.Model.Rent> Recommend(int vehicleId)
         {
             lock (isLocked)
             {
                 if (mlContext == null)
                 {
                     mlContext = new MLContext();
                     //these three steps are required due to CS0121 amgious error
                     var tmpDataPrev = Context.Rents.AsQueryable();
                     tmpDataPrev = EFCore.EntityFrameworkQueryableExtensions.Include(tmpDataPrev, x => x.Vehicle);
                     var tmpData = tmpDataPrev.ToList();

                     var data = new List<RentEntry>();

                     foreach (var x in tmpData)
                     {
                         var distinctVehicleId = x.VehicleId;
                         var relatedRents = Context.Rents
                             .Where(r => r.ClientId != x.ClientId && r.VehicleId != distinctVehicleId)
                             .ToList()
                             .GroupBy(r => r.VehicleId)
                             .Where(g => g.Count() >= 2)
                             .SelectMany(g => g)
                             .ToList();

                         foreach (var related in relatedRents)
                         {
                             data.Add(new RentEntry()
                             {
                                 RentId = (uint)x.Id,
                                 CoPurchaseRentID = (uint)related.VehicleId,
                             });
                         }
                     }

                     var traindata = mlContext.Data.LoadFromEnumerable(data);

                     MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                     options.MatrixColumnIndexColumnName = nameof(RentEntry.RentId);
                     options.MatrixRowIndexColumnName = nameof(RentEntry.CoPurchaseRentID);
                     options.LabelColumnName = "Label";
                     options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                     options.Alpha = 0.01;
                     options.Lambda = 0.025;
                     options.NumberOfIterations = 100;
                     options.C = 0.00001;

                     var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                     model = est.Fit(traindata);
                 }
             }

             var clients = Context.Rents
                 .Where(r => r.VehicleId == vehicleId)
                 .Select(r => r.ClientId)
                 .Distinct()
                 .ToList();

             var predictionResult = new List<Tuple<Database.Rent, float>>();

             var relatedVehicles = Context.Rents
                  .Where(r => clients.Contains(r.ClientId) && r.VehicleId != vehicleId)
                  .ToList()
                  .GroupBy(r => r.VehicleId)
                  .Where(g => g.Count() >= 2)
                  .Select(g => g.Key)
                  .ToList();

             foreach (var relatedVehicleId in relatedVehicles)
             {
                 var predictionengine = mlContext.Model.CreatePredictionEngine<RentEntry, Copurchase_prediction>(model);
                 var prediction = predictionengine.Predict(
                     new RentEntry()
                     {
                         RentId = (uint)vehicleId,
                         CoPurchaseRentID = (uint)relatedVehicleId
                     });

                 var relatedVozilo = Context.Rents.FirstOrDefault(r => r.VehicleId == relatedVehicleId);

                 predictionResult.Add(new Tuple<Database.Rent, float>(relatedVozilo, prediction.Score));
             }

             var finalResult = predictionResult
                 .OrderByDescending(x => x.Item2)
                 .Select(x => x.Item1)
                 .Take(3)
                 .ToList();

             return Mapper.Map<List<Model.Model.Rent>>(finalResult);
         }

         public class Copurchase_prediction
         {
             public float Score { get; set; }
         }

         public class RentEntry
         {
             [KeyType(count: 20)]
             public uint RentId { get; set; }

             [KeyType(count: 20)]
             public uint CoPurchaseRentID { get; set; }

             public float Label { get; set; }
         }*/


        public override IQueryable<Rent> AddFilter(RentSearchObject search, IQueryable<Rent> query)
        {
            var filteredQuery = base.AddFilter(search, query);
            if (!string.IsNullOrWhiteSpace(search.Status))
                filteredQuery = filteredQuery.Where(x => x.Status == search.Status);
            if (!string.IsNullOrWhiteSpace(search.StatusNot))
                filteredQuery = filteredQuery.Where(x => x.Status != search.StatusNot);
            if (search.VehicleId!=null)
                filteredQuery = filteredQuery.Where(x=>x.VehicleId==search.VehicleId);
            if (search.ClientId.HasValue)
                filteredQuery = filteredQuery.Where(x => x.ClientId == search.ClientId);
            if (search.UserId.HasValue)
                filteredQuery = filteredQuery.Where(x => x.Client.UserId == search.UserId);
            if (search.RentingDate!=null)
                filteredQuery=filteredQuery.Where(x=>x.RentingDate.Value.Date==search.RentingDate.Value.Date);
            if (search.EndingDate != null)
                filteredQuery = filteredQuery.Where(x => x.EndingDate.Value.Date== search.EndingDate.Value.Date);
            return filteredQuery;
        }

       

        public override IQueryable<Rent> AddInclude(RentSearchObject search, IQueryable<Rent> query)
        {
            var filteredQuery = base.AddInclude(search, query);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Client).ThenInclude(x => x.User);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Vehicle);
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
