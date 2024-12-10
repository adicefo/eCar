using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Client
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public byte[]? Image { get; set; }

    public virtual ClientNotification? ClientNotification { get; set; }

    public virtual Rent? Rent { get; set; }

    public virtual Review? Review { get; set; }

    public virtual Route? Route { get; set; }

    public virtual User User { get; set; } = null!;
}
