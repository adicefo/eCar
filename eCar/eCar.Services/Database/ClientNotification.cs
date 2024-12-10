using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class ClientNotification
{
    public int Id { get; set; }

    public int ClientId { get; set; }

    public int NotificationId { get; set; }

    public virtual Notification Id1 { get; set; } = null!;

    public virtual Client IdNavigation { get; set; } = null!;
}
