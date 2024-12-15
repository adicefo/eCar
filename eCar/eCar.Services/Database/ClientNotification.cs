using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class ClientNotification
{
    public int Id { get; set; }

    public int ClientId { get; set; }

    public int NotificationId { get; set; }

    public virtual Client Client { get; set; } = null!;

    public virtual Notification Notification { get; set; } = null!;
}
