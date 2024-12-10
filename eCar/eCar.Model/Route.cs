using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.SqlServer.Types;

namespace eCar.Model
{
    public class Route
    {
        public int Id { get; set; }
        public SqlGeography? SourcePoint { get; set; }
        public SqlGeography? DestinationPoint { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? Duration { get; set; }
        public int NumberOfKilometars { get; set; }
        public decimal FullPrice { get; set; }
        public string? Status { get; set; }


    }
}
