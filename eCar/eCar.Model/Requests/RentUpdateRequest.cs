﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Requests
{
    public class RentUpdateRequest
    {
       public  DateTime? EndingDate { get; set; }
        public int VehicleId { get; set; }
    }
}
