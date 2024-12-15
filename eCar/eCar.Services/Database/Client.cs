using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Client
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public byte[]? Image { get; set; }

    public virtual ICollection<ClientNotification> ClientNotifications { get; set; } = new List<ClientNotification>();

    public virtual ICollection<Rent> Rents { get; set; } = new List<Rent>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual ICollection<Route> Routes { get; set; } = new List<Route>();

    public virtual User User { get; set; } = null!;
}
