﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public  class Rent
    {
        public int Id { get; set; }

        public DateTime? RentingDate { get; set; }

        public DateTime? EndingDate { get; set; }

        public int? NumberOfDays { get; set; }

        public decimal? FullPrice { get; set; }

        public string? Status { get; set; }

        public int VehicleId { get; set; }

        public int ClientId { get; set; }

        public virtual Client Client { get; set; } = null!;

        public virtual Vehicle Vehicle { get; set; } = null!;
    }
}