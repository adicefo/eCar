using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class Vehicle
{
    public int Id { get; set; }

    public bool? Available { get; set; }

    public double? AverageConsumption { get; set; }

    public string? Name { get; set; }

    public byte[]? Image { get; set; }

    public decimal Price { get; set; }

    public virtual DriverVehicle? DriverVehicle { get; set; }

    public virtual Rent? Rent { get; set; }
}
