using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class CompanyPrice
{
    public int Id { get; set; }

    public decimal PricePerKilometar { get; set; }
    public DateTime? AddingDate { get; set; }

    public virtual ICollection<CompanyDetail> CompanyDetails { get; set; } = new List<CompanyDetail>();

    public virtual ICollection<Route> Routes { get; set; } = new List<Route>();
}
