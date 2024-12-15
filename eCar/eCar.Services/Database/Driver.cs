using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Driver
{
    public int Id { get; set; }

    public int UserID { get; set; }

    public int? NumberOfHoursAmount { get; set; }

    public int? NumberOfClientsAmount { get; set; }

    public virtual ICollection<DriverNotification> DriverNotifications { get; set; } = new List<DriverNotification>();

    public virtual ICollection<DriverVehicle> DriverVehicles { get; set; } = new List<DriverVehicle>();

    public virtual ICollection<Request> Requests { get; set; } = new List<Request>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual ICollection<Route> Routes { get; set; } = new List<Route>();

    public virtual ICollection<Statistic> Statistics { get; set; } = new List<Statistic>();

    public virtual User User { get; set; } = null!;
}
