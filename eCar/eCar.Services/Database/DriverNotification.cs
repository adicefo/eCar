using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class DriverNotification
{
    public int Id { get; set; }

    public int DriverId { get; set; }

    public int NotifiactionId { get; set; }

    public virtual Notification Id1 { get; set; } = null!;

    public virtual Driver IdNavigation { get; set; } = null!;
}
