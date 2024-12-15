using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Model.Model
{
    public class Vehicle
    {
        public int Id { get; set; }

        public bool? Available { get; set; }

        public double? AverageConsumption { get; set; }

        public string? Name { get; set; }

       // public byte[]? Image { get; set; }

        public decimal Price { get; set; }

       // public virtual ICollection<DriverVehicle> DriverVehicles { get; set; } = new List<DriverVehicle>();

        //public virtual ICollection<Rent> Rents { get; set; } = new List<Rent>();
    }
}
