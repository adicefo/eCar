﻿using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Mvc.RazorPages;
using RentACar.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Services
{
    public abstract class BaseService<TModel,TSearch,TDbEntity>:IService<TModel,TSearch> where TSearch : BaseSearchObject  where TDbEntity:class where TModel : class
    {
        public ECarDbContext Context { get; set; }
        public IMapper Mapper { get; set; }
        public BaseService(ECarDbContext context,IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public  virtual PagedResult<TModel> Get(TSearch search)
        {
            List<TModel> result = new List<TModel>();
            var query = Context.Set<TDbEntity>().AsQueryable();

            query=AddFilter(search, query);
            query=AddInclude(search, query);

            int count = query.Count();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
                query = query.Skip(search.Page.Value * search.PageSize.Value)
                   .Take(search.PageSize.Value);


            var list = query.ToList();

            result = Map(list, result);

            PagedResult<TModel> pageResult = new PagedResult<TModel>();
            pageResult.Result= result;
            pageResult.Count= count;

            return pageResult;
        }

     

        public virtual TModel GetById(int id)
        {
            var entity= Context.Set<TDbEntity>().Find(id);
            if (entity == null)
                    throw new Exception("Non-existed entity");
            return Mapper.Map<TModel>(entity);
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch search,IQueryable<TDbEntity> query)
        {
            return query;
        }
        public virtual IQueryable<TDbEntity> AddInclude(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }
        //Implemented for the purposes of manually mapping in Model.Model.Route 
        public virtual List<TModel> Map(List<TDbEntity> list, List<TModel> result)
        {
            return Mapper.Map(list,result);
        }
    }
}
