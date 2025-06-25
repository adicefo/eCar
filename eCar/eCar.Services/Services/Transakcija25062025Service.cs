using eCar.Model.Helper;
using eCar.Model.Requests;
using eCar.Model.SearchObjects;
using eCar.Services.Database;
using eCar.Services.Interfaces;
using MapsterMapper;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Nest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EFCore = Microsoft.EntityFrameworkCore;
namespace eCar.Services.Services
{
    public class Transakcija25062025Service : BaseCRUDService<Model.Model.Transakcija250602025,
        Transkacija25062025SearchObject, Database.Transakcija250602025, Transakcija250602025InsertRequest, Transakcija25062025UpdateRequest>, ITransakcija25062025
    {
        public Transakcija25062025Service(ECarDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Transakcija250602025> AddFilter(Transkacija25062025SearchObject search, IQueryable<Transakcija250602025> query)
        {
            var filteredQuery = base.AddFilter(search, query);
            if (search.KategorijaId.HasValue)
                filteredQuery = filteredQuery.Where(x => x.KategorijaId == search.KategorijaId);
            if (search.DatumPocetka != null)
                filteredQuery = filteredQuery.Where(x => x.DatumTransakcije.Date >search.DatumPocetka.Value.Date);
            if (search.DatumZavrsetka != null)
                filteredQuery = filteredQuery.Where(x => x.DatumTransakcije.Date<search.DatumZavrsetka.Value.Date);
            return filteredQuery;
        }

        public override IQueryable<Transakcija250602025> AddInclude(Transkacija25062025SearchObject search, IQueryable<Transakcija250602025> query)
        {
            var filteredQuery = base.AddInclude(search, query);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Kategorija);
            filteredQuery = EFCore.EntityFrameworkQueryableExtensions.Include(filteredQuery, x => x.Korisnik);
         
            return filteredQuery;
        }

        public IActionResult GetTotalHrana(Transkacija25062025SearchObject search)
        {
            var kategorije = Context.Transakcija250602025e.Where(x => x.Kategorija.Naziv == "Hrana" &&

            (search.KategorijaId.HasValue && search.KategorijaId == x.KategorijaId));
            if (search.DatumPocetka != null)
                kategorije = kategorije.Where(x => x.DatumTransakcije.Date > search.DatumPocetka.Value.Date);
            if (search.DatumZavrsetka != null)
                kategorije = kategorije.Where(x => x.DatumTransakcije.Date < search.DatumZavrsetka.Value.Date);
            if (kategorije==null)
                return new OkObjectResult(new {value=0 });
            return new OkObjectResult(new { value = kategorije.Count() });
        }

        public IActionResult GetTotalPlata(Transkacija25062025SearchObject search)
        {
            var kategorije = Context.Transakcija250602025e.Where(x => x.Kategorija.Naziv == "Plata" &&

            (search.KategorijaId.HasValue && search.KategorijaId == x.KategorijaId));
            if (search.DatumPocetka != null)
                kategorije = kategorije.Where(x => x.DatumTransakcije.Date > search.DatumPocetka.Value.Date);
            if (search.DatumZavrsetka != null)
                kategorije = kategorije.Where(x => x.DatumTransakcije.Date < search.DatumZavrsetka.Value.Date);
            if (kategorije == null)
                return new OkObjectResult(new { value = 0 });
            return new OkObjectResult(new { value = kategorije.Count() });
        }

        public IActionResult GetTotalZabava(Transkacija25062025SearchObject search)
        {
            var kategorije = Context.Transakcija250602025e.Where(x => x.Kategorija.Naziv == "Zabava" &&

            (search.KategorijaId.HasValue && search.KategorijaId == x.KategorijaId));
            if (search.DatumPocetka != null)
                kategorije = kategorije.Where(x => x.DatumTransakcije.Date > search.DatumPocetka.Value.Date);
            if (search.DatumZavrsetka != null)
                kategorije = kategorije.Where(x => x.DatumTransakcije.Date < search.DatumZavrsetka.Value.Date);
            if (kategorije == null)
                return new OkObjectResult(new { value = 0 });
            return new OkObjectResult(new { value = kategorije.Count() });
        }

        public override Model.Model.Transakcija250602025 Insert(Transakcija250602025InsertRequest request)
        {

            var set = Context.Set<Database.Transakcija250602025>();
            Transakcija250602025 entity = Mapper.Map<Database.Transakcija250602025>(request);
            Mapper.Map(request, entity);

            var limit = Context.FinansijskiLimit250602025e.Where(x => x.KorisnikId == entity.KorisnikId && x.KategorijaId == entity.KategorijaId).FirstOrDefault();
            if (limit != null)
            {
                if (request.Iznos > limit.Limit)
                {
                    throw new UserException("Transkacija je prešla limit");
                }

            }


            



            set.Add(entity);
            Context.SaveChanges();


            var result = Mapper.Map<Model.Model.Transakcija250602025>(entity);


            return result;

        }
    }
}
