using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class DriverNotification
{
    public int Id { get; set; }

    public int DriverId { get; set; }

    public int NotifiactionId { get; set; }

    public virtual Driver Driver { get; set; } = null!;

    public virtual Notification Notifiaction { get; set; } = null!;
}
