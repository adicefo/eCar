using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Driver
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public int? NumberOfHoursAmount { get; set; }

    public int? NumberOfClientsAmount { get; set; }

    public virtual DriverNotification? DriverNotification { get; set; }

    public virtual DriverVehicle? DriverVehicle { get; set; }

    public virtual User IdNavigation { get; set; } = null!;

    public virtual Request? Request { get; set; }

    public virtual Review? Review { get; set; }

    public virtual Route? Route { get; set; }

    public virtual Statistic? Statistic { get; set; }
}
