using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AnnoncesController : ControllerBase
{
    private readonly IAnnonceRepository _annonceRepository;

    public AnnoncesController(IAnnonceRepository annonceRepository)
    {
        _annonceRepository = annonceRepository;
    }

    // GET: api/Annonces
    [HttpGet]
    public async Task<ActionResult<IEnumerable<AnnonceSearchResultDto>>> GetAnnonces()
    {
        var annonces = await _annonceRepository.GetAllAsync();

        var result = annonces.Select(a => new AnnonceSearchResultDto
        {
            Idannonce = a.Idannonce,
            Titreannonce = a.Titreannonce,
            TypeHebergement = a.IdtypehebergementNavigation?.Nomtypehebergement,
            Nomville = a.IdadresseNavigation?.IdvilleNavigation?.Nomville,
            Codepostal = a.IdadresseNavigation?.IdvilleNavigation?.Codepostal,
            Prixnuitee = a.Prixnuitee,
            Capacite = a.Capacite,
            Nombreetoilesleboncoin = a.Nombreetoilesleboncoin,
            Photos = a.Photos.Select(p => new Photo
            {
                Idphoto = p.Idphoto,
                Idannonce = p.Idannonce,
                Lienphoto = p.Lienphoto
            }).ToList(),
        });

        return Ok(result);
    }

    // GET: api/Annonces/search?q={query}&minPrice=10&maxPrice=500&nbChambres=2&typeHebergementIds=1,2&dateArrivee=2024-01-01&dateDepart=2024-01-10
    [HttpGet("search")]
    public async Task<ActionResult<IEnumerable<AnnonceSearchResultDto>>> SearchAnnonces(
        [FromQuery] string q = "",
        [FromQuery] decimal? minPrice = null,
        [FromQuery] decimal? maxPrice = null,
        [FromQuery] int? nbChambres = null,
        [FromQuery] string? typeHebergementIds = null,
        [FromQuery] DateTime? dateArrivee = null,
        [FromQuery] DateTime? dateDepart = null,
        [FromQuery] string? commoditeIds = null)
    {
        List<int>? typeIds = null;
        if (!string.IsNullOrEmpty(typeHebergementIds))
        {
            typeIds = typeHebergementIds.Split(',').Select(int.Parse).ToList();
        }

        List<int>? commoIds = null;
        if (!string.IsNullOrEmpty(commoditeIds))
        {
            commoIds = commoditeIds.Split(',').Select(int.Parse).ToList();
        }

        var results = await _annonceRepository.GetByLocalisationAsync(q, minPrice, maxPrice, nbChambres, typeIds, dateArrivee, dateDepart, commoIds);
        return Ok(results);
    }

    // GET: api/Annonces/5
    [HttpGet("{id}")]
    public async Task<ActionResult<Annonce>> GetAnnonce(int id)
    {
        var annonce = await _annonceRepository.GetByIdAsync(id);

        if (annonce == null)
        {
            return NotFound("Annonce introuvable.");
        }

        return Ok(annonce);
    }

    // POST: api/Annonces
    [HttpPost]
    public async Task<ActionResult<Annonce>> PostAnnonce(Annonce annonce)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        await _annonceRepository.AddAsync(annonce);

        return CreatedAtAction(nameof(GetAnnonce), new { id = annonce.Idannonce }, annonce);
    }

    // PUT: api/Annonces/5
    [HttpPut("{id}")]
    public async Task<IActionResult> PutAnnonce(int id, Annonce annonce)
    {
        if (id != annonce.Idannonce)
        {
            return BadRequest();
        }

        var annonceToUpdate = await _annonceRepository.GetByIdAsync(id);

        if (annonceToUpdate == null)
        {
            return NotFound();
        }

        await _annonceRepository.UpdateAsync(annonceToUpdate, annonce);

        return NoContent();
    }

    // DELETE: api/Annonces/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteAnnonce(int id)
    {
        var annonce = await _annonceRepository.GetByIdAsync(id);

        if (annonce == null)
        {
            return NotFound();
        }

        await _annonceRepository.DeleteAsync(annonce);

        return NoContent();
    }
}