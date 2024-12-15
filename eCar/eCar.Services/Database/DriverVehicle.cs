using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class DriverVehicle
{
    public int Id { get; set; }

    public int DriverId { get; set; }

    public int VehicleId { get; set; }

    public DateOnly? DateOfUsing { get; set; }

    public virtual Driver Driver { get; set; } = null!;

    public virtual Vehicle Vehicle { get; set; } = null!;
}
