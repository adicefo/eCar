﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.SearchObjects
{
    public class RouteSearchObject:BaseSearchObject
    {
        public string? Status { get; set; }
        public decimal? NumberOfKilometarsGTE { get; set; }
   

    }
}