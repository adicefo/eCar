using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Review
{
    public int Id { get; set; }

    public byte? Value { get; set; }

    public string? Description { get; set; }

    public int ReviewsId { get; set; }

    public int ReviewedId { get; set; }

    public int RouteId { get; set; }

    public virtual Driver Id1 { get; set; } = null!;

    public virtual Route Id2 { get; set; } = null!;

    public virtual Client IdNavigation { get; set; } = null!;
}
