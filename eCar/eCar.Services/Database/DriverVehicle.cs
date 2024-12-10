using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class DriverVehicle
{
    public int Id { get; set; }

    public int DriverId { get; set; }

    public string VehicleId { get; set; } = null!;

    public DateOnly? DateOfUsing { get; set; }

    public virtual Vehicle Id1 { get; set; } = null!;

    public virtual Driver IdNavigation { get; set; } = null!;
}
