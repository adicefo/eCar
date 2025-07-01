using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Helpers;
using eCar.Services.Interfaces;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Services
{
    public abstract class BaseCRUDService<TModel,TSearch,TDbEntity,TInsert,TUpdate>:BaseService<TModel,TSearch,TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity: class
    {
        public BaseCRUDService(ECarDbContext context,IMapper mapper):
            base(context,mapper) 
        {
            
        }

        public virtual TModel Insert(TInsert request)
        {

            var set = Context.Set<TDbEntity>();
            TDbEntity entity = Mapper.Map<TDbEntity>(request);
            Mapper.Map(request, entity);


            BeforeInsert(request, entity);

            

            set.Add(entity);
            Context.SaveChanges();


            var result= Mapper.Map<TModel>(entity);
           
            
            return result;

        }

        public virtual TModel Update(int id,TUpdate request)
        {
            var set = Context.Set<TDbEntity>();
            var entity=set.Find(id);
            if (entity == null)
                throw new Exception("Non-existed model");

            entity = Mapper.Map(request, entity);
            BeforeUpdate(request, entity);

            Context.SaveChanges();
            
            var result=Mapper.Map<TModel>(entity);
          
            return result;
        }

        public virtual  TModel Delete(int id)
        {
            var set = Context.Set<TDbEntity>();

            var entity=set.Find(id);

            if (entity == null)
                throw new Exception("Non-existed model");

            set.Remove(entity);
            Context.SaveChanges();
            return Mapper.Map<TModel>(entity) ;
            
        }

        public virtual void BeforeInsert(TInsert request, TDbEntity entity) 
        { 
        }
        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity)
        { 
        }
        public virtual void AfterInsert(TInsert request, TDbEntity entity)
        {
        }
       




    }
}
