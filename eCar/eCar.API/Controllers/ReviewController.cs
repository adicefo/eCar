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
    public class ReviewController :BaseCRUDController<Model.Model.Review,
        ReviewSearchObject,ReviewInsertRequest,ReviewUpdateRequest>
    {
        public ReviewController(IRevieweService service):base(service)
        {
        }

        [Authorize(Roles ="Client")]
        public override Review Insert(ReviewInsertRequest request)
        {
            return base.Insert(request);
        }
    }
}
