﻿using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Rent
{
    public int Id { get; set; }

    public DateTime? RentingDate { get; set; }

    public DateTime? EndingDate { get; set; }

    public int? NumberOfDays { get; set; }

    public decimal FullPrice { get; set; }

    public string? Status { get; set; }

    public int VehicleId { get; set; }

    public int ClientId { get; set; }

    public virtual Vehicle Id1 { get; set; } = null!;

    public virtual Client IdNavigation { get; set; } = null!;
}