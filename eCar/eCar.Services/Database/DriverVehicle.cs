using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class DriverVehicle
{
    public int Id { get; set; }

    public int DriverId { get; set; }

    public int VehicleId { get; set; }

    public DateTime? DatePickUp { get; set; }
    public DateTime? DateDropOff { get; set; }

    public virtual Driver Driver { get; set; } = null!;

    public virtual Vehicle Vehicle { get; set; } = null!;
}
