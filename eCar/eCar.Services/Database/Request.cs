using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Request
{
    public int Id { get; set; }

    public bool IsAccepted { get; set; }

    public int RouteId { get; set; }

    public int DriverId { get; set; }

    public virtual Route Id1 { get; set; } = null!;

    public virtual Driver IdNavigation { get; set; } = null!;
}
