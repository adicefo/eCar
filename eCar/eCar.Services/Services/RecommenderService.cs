using eCar.Model.Model;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using MapsterMapper;
using Microsoft.ML;
using Microsoft.ML.Data;
using EFCore = Microsoft.EntityFrameworkCore;
using Nest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.ML.Trainers;
using System.Data.Entity;

namespace eCar.Services.Services
{
    public class RecommenderService : IRecommenderService
    {
        ECarDbContext Context;
        IMapper Mapper;

        public RecommenderService(ECarDbContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }



       static MLContext mlContext = null;
         static object isLocked = new object();
         static ITransformer model = null;

         public List<Model.Model.Rent> Recommend(int vehicleId)
         {
             lock (isLocked)
             {
                 //if (mlContext == null)  //removed because Vehicle cannot be included 
                 //{                       //cause UI problem in Flutter
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
             //}

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
        }
    }
}
