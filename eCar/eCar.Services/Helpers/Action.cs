using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Enums
{
    //list of action that are allowed for certain state
    public enum Action
    {
        Insert=1,
        Update,
        UpdateActive,
        UpdateFinish,
        Delete
    }
}
