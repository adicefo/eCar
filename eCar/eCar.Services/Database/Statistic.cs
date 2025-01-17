using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Statistic
{
    public int Id { get; set; }

    public int? NumberOfHours { get; set; }

    public int? NumberOfClients { get; set; }

    public decimal? PriceAmount { get; set; }

    public DateTime? BeginningOfWork { get; set; }

    public DateTime? EndOfWork { get; set; }

    public int DriverId { get; set; }

    public virtual Driver Driver { get; set; } = null!;
}
