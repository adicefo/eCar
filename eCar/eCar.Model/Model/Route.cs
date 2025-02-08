using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.Spatial;
using System.Text;
using eCar.Model.DTO;
using Microsoft.Spatial;
using Microsoft.SqlServer.Types;
using NetTopologySuite.Geometries;

namespace eCar.Model.Model
{
    public class Route
    {
        public int Id { get; set; }

        public PointDTO? SourcePoint { get; set; }

        public PointDTO? DestinationPoint { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? Duration { get; set; }
        public decimal? NumberOfKilometars { get; set; }
        public decimal? FullPrice { get; set; }
        public bool? Paid { get; set; }
        public string? Status { get; set; }
        public int DriverID { get; set; }
        public virtual Driver Driver { get; set; } = null!;
        public int ClientId { get; set; }
        public virtual Client Client { get; set; } = null!;

       
    }
}
