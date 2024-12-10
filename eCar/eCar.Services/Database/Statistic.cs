using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Statistic
{
    public int Id { get; set; }

    public byte? NumberOfHours { get; set; }

    public byte? NumberOfClients { get; set; }

    public decimal? PriceAmount { get; set; }

    public DateTime? BeginningOfWork { get; set; }

    public DateTime? EndOfWork { get; set; }

    public int DriverId { get; set; }

    public virtual Driver IdNavigation { get; set; } = null!;
}
