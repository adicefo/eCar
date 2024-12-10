using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class CompanyPrice
{
    public int Id { get; set; }

    public decimal PricePerKilometar { get; set; }

    public virtual CompanyDetail? CompanyDetail { get; set; }

    public virtual Route? Route { get; set; }
}
