using eCar.Model.Model;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eCar.API.Controllers
{
    [ApiController]
    public class NotificationController :BaseCRUDController<Model.Model.Notification,
        NotificationSearchObject,NotificationInsertRequest,NotificationUpdateRequest>
    {
        public NotificationController(INotificationService service):base(service)
        {
        }

        [Authorize(Roles ="Admin")]
        public override Notification Insert(NotificationInsertRequest request)
        {
            return base.Insert(request);
        }
    }
}
