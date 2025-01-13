using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Interfaces
{
    public interface INotificationService:ICRUDService<Model.Model.Notification,
        NotificationSearchObject,NotificationInsertRequest,NotificationUpdateRequest>
    {
    }
}
