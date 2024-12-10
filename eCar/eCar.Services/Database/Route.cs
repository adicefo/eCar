using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Route
{
    public int Id { get; set; }

    public DateTime? StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public int? Duration { get; set; }

    public int? NumberOfKilometars { get; set; }

    public decimal FullPrice { get; set; }

    public string? Status { get; set; }

    public int ClientId { get; set; }

    public int DriverId { get; set; }

    public int CompanyPricesId { get; set; }

    public virtual CompanyPrice Id1 { get; set; } = null!;

    public virtual Driver Id2 { get; set; } = null!;

    public virtual Client IdNavigation { get; set; } = null!;

    public virtual Request? Request { get; set; }

    public virtual Review? Review { get; set; }
}
