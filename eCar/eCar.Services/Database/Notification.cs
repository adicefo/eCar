using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Notification
{
    public int Id { get; set; }

    public string? Heading { get; set; }

    public string? Content { get; set; }

    public byte[]? Image { get; set; }

    public DateTime? AddingDate { get; set; }

    public bool? IsForClient { get; set; }

    public string? Status { get; set; }

    public virtual ClientNotification? ClientNotification { get; set; }

    public virtual DriverNotification? DriverNotification { get; set; }
}
