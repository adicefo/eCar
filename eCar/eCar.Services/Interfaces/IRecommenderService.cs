using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface IRecommenderService
    {
        List<Model.Model.Rent> Recommend(int vehicleId);

    }
}
