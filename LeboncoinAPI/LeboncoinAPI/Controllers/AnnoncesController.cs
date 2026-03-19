using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AnnoncesController : ControllerBase
{
    private readonly IAnnonceRepository _annonceRepository;
    private readonly LeboncoinDBContext _dbContext;

    public AnnoncesController(IAnnonceRepository annonceRepository, LeboncoinDBContext dbContext)
    {
        _annonceRepository = annonceRepository;
        _dbContext = dbContext;
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

    // GET: api/Annonces/user/{userId}
    [HttpGet("user/{userId:int}")]
    public async Task<ActionResult<IEnumerable<AnnonceSearchResultDto>>> GetAnnoncesByUser(int userId)
    {
        var results = await _annonceRepository.GetByUserIdAsync(userId);
        return Ok(results);
    }

    // GET: api/Annonces/5/similaires
    [HttpGet("{id}/similaires")]
    public async Task<ActionResult<IEnumerable<AnnonceSearchResultDto>>> GetSimilaires(int id)
    {
        var results = await _annonceRepository.GetSimilairesAsync(id);
        return Ok(results);
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
    public async Task<ActionResult> GetAnnonce(int id)
    {
        var annonce = await _annonceRepository.GetByIdAsync(id);
        if (annonce == null) return NotFound("Annonce introuvable.");

        var result = new
        {
            annonce.Idannonce,
            annonce.Titreannonce,
            annonce.Descriptionannonce,
            annonce.Prixnuitee,
            annonce.Capacite,
            annonce.Nbchambres,
            annonce.Minimumnuitee,
            annonce.Nombrebebesmax,
            annonce.Possibiliteanimaux,
            annonce.Possibilitefumeur,
            annonce.Smsverifie,
            annonce.Nombreetoilesleboncoin,
            annonce.Idutilisateur,
            IdheurearriveeNavigation = annonce.IdheurearriveeNavigation == null ? null : new { Heure = annonce.IdheurearriveeNavigation.Heure1 },
            IdheuredepartNavigation = annonce.IdheuredepartNavigation == null ? null : new { Heure = annonce.IdheuredepartNavigation.Heure1 },
            IdtypehebergementNavigation = annonce.IdtypehebergementNavigation == null ? null : new { annonce.IdtypehebergementNavigation.Nomtypehebergement },
            IdadresseNavigation = annonce.IdadresseNavigation == null ? null : new
            {
                annonce.IdadresseNavigation.Nomrue,
                IdvilleNavigation = annonce.IdadresseNavigation.IdvilleNavigation == null ? null : new
                {
                    annonce.IdadresseNavigation.IdvilleNavigation.Nomville,
                    annonce.IdadresseNavigation.IdvilleNavigation.Codepostal
                }
            },
            IdutilisateurNavigation = annonce.IdutilisateurNavigation == null ? null : new
            {
                annonce.IdutilisateurNavigation.Pseudonyme,
                annonce.IdutilisateurNavigation.ProfilePhotoPath,
                DateInscription = annonce.IdutilisateurNavigation.IddateNavigation?.Date1,
                NombreAnnonces = annonce.IdutilisateurNavigation.Annonces.Count,
                annonce.IdutilisateurNavigation.IdentityVerified,
                annonce.IdutilisateurNavigation.PhoneVerified,
                NoteMoyenne = annonce.IdutilisateurNavigation.Avis.Any() ? (decimal?)annonce.IdutilisateurNavigation.Avis.Average(a => a.Nombreetoiles) : null,
                NombreAvis = annonce.IdutilisateurNavigation.Avis.Count
            },
            Photos = annonce.Photos.Select(p => new { p.Idphoto, p.Idannonce, p.Lienphoto }),
            Idcommodites = annonce.Idcommodites.Select(c => new
            {
                c.Idcommodite,
                c.Nomcommodite,
                IdcategorieNavigation = new { c.IdcategorieNavigation.Nomcategorie }
            }),
            Reservations = annonce.Reservations.Select(r => new
            {
                IddatedebutreservationNavigation = r.IddatedebutreservationNavigation == null ? null : new { r.IddatedebutreservationNavigation.Date1 },
                IddatefinreservationNavigation = r.IddatefinreservationNavigation == null ? null : new { r.IddatefinreservationNavigation.Date1 }
            })
        };

        return Ok(result);
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

    // GET: api/Annonces/favorites/{userId}
    [HttpGet("favorites/{userId}")]
    public async Task<ActionResult<IEnumerable<AnnonceSearchResultDto>>> GetFavorites(int userId)
    {
        var favorites = await _annonceRepository.GetFavoritesByUserIdAsync(userId);
        return Ok(favorites);
    }

    // GET: api/Annonces/favorites/ids/{userId}
    [HttpGet("favorites/ids/{userId}")]
    public async Task<ActionResult<IEnumerable<int>>> GetFavoriteIds(int userId)
    {
        var ids = await _annonceRepository.GetFavoriteIdsByUserIdAsync(userId);
        return Ok(ids);
    }

    // POST: api/Annonces/{annonceId}/favorite/{userId}
    [HttpPost("{annonceId}/favorite/{userId}")]
    public async Task<IActionResult> AddFavorite(int annonceId, int userId)
    {
        await _annonceRepository.AddFavoriteAsync(userId, annonceId);
        return Ok();
    }

    // DELETE: api/Annonces/{annonceId}/favorite/{userId}
    [HttpDelete("{annonceId}/favorite/{userId}")]
    public async Task<IActionResult> RemoveFavorite(int annonceId, int userId)
    {
        await _annonceRepository.RemoveFavoriteAsync(userId, annonceId);
        return NoContent();
    }
}