using System;
using System.Collections.Generic;

namespace eCar.Services.Database;

public partial class CompanyDetail
{
    public int Id { get; set; }

    public string CompanyName { get; set; } = null!;

    public int CompanyPricesId { get; set; }

    public virtual CompanyPrice CompanyPrices { get; set; } = null!;
}
