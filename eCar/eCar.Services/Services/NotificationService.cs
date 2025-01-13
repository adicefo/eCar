using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Services.Services
{
    public class NotificationService:BaseCRUDService<Model.Model.Notification,
        NotificationSearchObject,Database.Notification,NotificationInsertRequest,NotificationUpdateRequest>,INotificationService
    {
        public NotificationService(ECarDbContext context,IMapper mapper):base(context,mapper) 
        {
            
        }

        public override IQueryable<Notification> AddFilter(NotificationSearchObject search, IQueryable<Notification> query)
        {
            var filteredQuery= base.AddFilter(search, query);
            if (!string.IsNullOrWhiteSpace(search.HeadingGTE))
                filteredQuery = filteredQuery.Where(x => x.Heading.StartsWith(search.HeadingGTE))?? filteredQuery;
            if(search.IsForClient==true)
                filteredQuery=filteredQuery.Where(x=>x.IsForClient==search.IsForClient);
            if(search.IsForClient==false)
                filteredQuery=filteredQuery.Where(x=>x.IsForClient== search.IsForClient);
            return filteredQuery;
        }

        public override void BeforeInsert(NotificationInsertRequest request, Notification entity)
        {
            entity.AddingDate= DateTime.Now;
            entity.Status = "active";
        }
    }
}
