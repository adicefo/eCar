using System;
using System.Collections.Generic;
using System.Data.Entity.Spatial;
using Nest;
using NetTopologySuite.Geometries;

namespace eCar.Services.Database;

public partial class Route
{
    public int Id { get; set; }

    public Point? SourcePoint { get; set; }

    public Point? DestinationPoint { get; set; }

    public DateTime? StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public int? Duration { get; set; }

    public decimal? NumberOfKilometars { get; set; }

    public decimal? FullPrice { get; set; }

    public string? Status { get; set; }

    public int ClientId { get; set; }

    public int DriverID { get; set; }

    public int CompanyPricesID { get; set; }

    public virtual Client Client { get; set; } = null!;

    public virtual CompanyPrice CompanyPrices { get; set; } = null!;

    public virtual Driver Driver { get; set; } = null!;

    public virtual ICollection<Request> Requests { get; set; } = new List<Request>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
}
