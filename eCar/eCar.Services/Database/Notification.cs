using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Notification
{
    public int Id { get; set; }

    public string? Heading { get; set; }

    public string? Content_ { get; set; }

    public byte[]? Image { get; set; }

    public DateTime? AddingDate { get; set; }

    public bool? IsForClient { get; set; }

    public string? Status { get; set; }

    public virtual ICollection<ClientNotification> ClientNotifications { get; set; } = new List<ClientNotification>();

    public virtual ICollection<DriverNotification> DriverNotifications { get; set; } = new List<DriverNotification>();
}
