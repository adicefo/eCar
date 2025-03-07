﻿using eCar.Model.SearchObjects;
using NetTopologySuite.IO;
using RentACar.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IService<TModel,TSearch> where TModel : class where TSearch : BaseSearchObject
    {
        public PagedResult<TModel> Get(TSearch search);
        public TModel GetById(int id);
    }
}
