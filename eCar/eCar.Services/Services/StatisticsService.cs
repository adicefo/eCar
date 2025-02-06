using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using EFCore = Microsoft.EntityFrameworkCore;
using MapsterMapper;
using Nest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using eCar.Model.Model;
using eCar.Model.Helper;

namespace eCar.Services.Services
{
    public class StatisticsService:BaseCRUDService<Model.Model.Statistics,
        StatisticsSearchObjectcs,Database.Statistic,StatisticsInsertRequest,StatisticsUpdateRequest>,IStatisticsService
    {
        public StatisticsService(ECarDbContext context,IMapper mapper):base(context,mapper)
        {
            
        }
        public Statistics UpdateFinsih(int id)
        {
            var set = Context.Set<Database.Statistic>().AsQueryable();
            var entity = set.Include(x => x.Driver).ThenInclude(x => x.User).FirstOrDefault(x => x.Id == id);
            if (entity == null)
                throw new UserException("Non-existed model");

            entity.EndOfWork = DateTime.Now;
            
            //update for driver
            var driver = Context.Drivers.FirstOrDefault(x=>x.Id==entity.DriverId);
            if (driver == null)
                throw new UserException("Non existed driver");
            var drives= Context.Routes.Where(r => r.DriverID == entity.DriverId &&
            r.Status == "finished" && r.StartDate.Value.Date == entity.BeginningOfWork.Value.Date);

            driver.NumberOfClientsAmount+= drives.Count();
            driver.NumberOfHoursAmount += (int)entity.EndOfWork.Value.Hour - entity.BeginningOfWork.Value.Hour;

            Context.Statistics.Update(entity);
            Context.Drivers.Update(driver);
            Context.SaveChanges();

            var result = Mapper.Map<Model.Model.Statistics>(entity);

            return result;
        }
        public override IQueryable<Statistic> AddFilter(StatisticsSearchObjectcs search, IQueryable<Statistic> query)
        {
            var filteredQuery = base.AddFilter(search, query);
            if (search.DriverId!=null)
                filteredQuery = filteredQuery.Where(x => x.DriverId == search.DriverId);
            if (search.BeginningOfWork != null)
                filteredQuery = filteredQuery.Where(x => x.BeginningOfWork.Value.Date == search.BeginningOfWork.Value.Date);
            return filteredQuery;
        }
        public override IQueryable<Statistic> AddInclude(StatisticsSearchObjectcs search, IQueryable<Statistic> query)
        {
            var filteredQuery = base.AddInclude(search, query);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Driver).ThenInclude(x => x.User);
            return filteredQuery;
        }
        public override void BeforeInsert(StatisticsInsertRequest request, Statistic entity)
        {
            entity.BeginningOfWork = DateTime.Now;//DateTime.Parse("2025 - 01 - 26T07: 00:00.148Z");
            entity.NumberOfHours = 0;
            entity.NumberOfClients = 0;
            entity.PriceAmount=0;
        }

        public override void BeforeUpdate(StatisticsUpdateRequest request, Statistic entity)
        {
            //number of hourse at work on that day
            entity.NumberOfHours = (int)DateTime.Now.Hour - entity.BeginningOfWork!.Value.Hour;

            //all drives for driver on that day
            var drives = Context.Routes.Where(r => r.DriverID == entity.DriverId &&
            r.Status == "finished" && r.StartDate.Value.Date == entity.BeginningOfWork.Value.Date);

            //total number of clients for that day
            entity.NumberOfClients= drives.Count();

            //sum of prices for all clients
            entity.PriceAmount = drives.Sum(x => x.FullPrice);

        }

     
    }
}
