using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;
namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AnnoncesController : ControllerBase
{
    private readonly IAnnonceRepository _annonceRepository;
    private readonly LeboncoinDBContext _dbContext;
    private readonly Cloudinary _cloudinary;

    public AnnoncesController(IAnnonceRepository annonceRepository, LeboncoinDBContext dbContext, IConfiguration config)
    {
        _annonceRepository = annonceRepository;
        _dbContext = dbContext;

        var acc = new Account(
            config["CloudinarySettings:CloudName"],
            config["CloudinarySettings:ApiKey"],
            config["CloudinarySettings:ApiSecret"]
        );
        _cloudinary = new Cloudinary(acc);
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
            Estverifie = a.Estverifie,
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

        // COUNT séparé pour éviter de charger toutes les annonces du propriétaire en mémoire
        var nombreAnnonces = annonce.IdutilisateurNavigation != null
            ? await _dbContext.Annonces.CountAsync(a => a.Idutilisateur == annonce.Idutilisateur)
            : 0;

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
            annonce.Idtypehebergement,
            annonce.Idheurearrivee,
            annonce.Idheuredepart,
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
                NombreAnnonces = nombreAnnonces,
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
    public async Task<ActionResult<Annonce>> PostAnnonce(AnnonceDTO dto)
    {
        var adresse = await CreateOrGetAdresseAsync(dto);

        var nouvelleAnnonce = new Annonce
        {
            Titreannonce = dto.Titreannonce,
            Descriptionannonce = dto.Descriptionannonce,
            Prixnuitee = dto.Prixnuitee,
            Nbchambres = dto.Nbchambres,
            Capacite = dto.Nombrepersonnesmax,
            Nombrebebesmax = dto.Nombrebebesmax,
            Minimumnuitee = dto.Minimumnuitee,
            Montantacompte = dto.Acomptefixe,
            Pourcentageacompte = dto.Acomptepourcentage,
            Possibiliteanimaux = dto.Possibiliteanimaux,
            Possibilitefumeur = dto.Possibilitefumeur,
            Idheurearrivee = dto.Idheurearrivee,
            Idheuredepart = dto.Idheuredepart,
            Idutilisateur = dto.Idutilisateur,
            Idtypehebergement = dto.Idtypehebergement,
            IdadresseNavigation = adresse
        };

        if (dto.Idcommodites != null && dto.Idcommodites.Any())
        {
            var commodites = await _dbContext.Commodites
                .Where(c => dto.Idcommodites.Contains(c.Idcommodite))
                .ToListAsync();
            foreach (var c in commodites)
            {
                nouvelleAnnonce.Idcommodites.Add(c);
            }
        }


        if (dto.Liensphoto != null && dto.Liensphoto.Any())
        {
            foreach (var base64Data in dto.Liensphoto)
            {
                string base64Image;
                if (base64Data.Contains(","))
                {

                    base64Image = base64Data.Split(',')[1]; 
                }
                else
                {
                    base64Image = base64Data;
                }

                byte[] imageBytes = Convert.FromBase64String(base64Image);

                
                using (var ms = new MemoryStream(imageBytes))
                {
                    var uploadParams = new ImageUploadParams()
                    {
                        File = new FileDescription(Guid.NewGuid().ToString(), ms),
                        Folder = "annonces"
                    };

                    var uploadResult = await _cloudinary.UploadAsync(uploadParams);

                    if (uploadResult.StatusCode == System.Net.HttpStatusCode.OK)
                    {
                        nouvelleAnnonce.Photos.Add(new Photo
                        {
                            Lienphoto = uploadResult.SecureUrl.ToString()
                        });
                    }
                }
            }
        }

        await _annonceRepository.AddAsync(nouvelleAnnonce);

        return CreatedAtAction(nameof(GetAnnonce), new { id = nouvelleAnnonce.Idannonce }, nouvelleAnnonce);
    }


    private async Task<Adresse> CreateOrGetAdresseAsync(AnnonceDTO dto)
    {
        var match = Regex.Match(dto.Rue ?? string.Empty, @"^(\d+)\s*(.*)$");

        int num = 0;
        string street = dto.Rue ?? string.Empty;

        if (match.Success && match.Groups.Count >= 3)
        {
            int.TryParse(match.Groups[1].Value, out num);
            street = match.Groups[2].Value.Trim();
        }

        string depCode = (dto.CodePostal?.Length >= 2) ? dto.CodePostal.Substring(0, 2) : "00";
        string depName = "Inconnu";
        string regName = "Inconnue";

        if (UtilisateurManager.GeoData.TryGetValue(depCode, out var geo))
        {
            depName = geo.DepName;
            regName = geo.RegName;
        }
        var region = await _dbContext.Regions.FirstOrDefaultAsync(r => r.Nomregion == regName)
                     ?? new Region { Nomregion = regName };

        var departement = await _dbContext.Departements.FirstOrDefaultAsync(d => d.Numerodepartement == depCode)
                          ?? new Departement
                          {
                              Numerodepartement = depCode,
                              Nomdepartement = depName,
                              IdregionNavigation = region
                          };

        var ville = await _dbContext.Villes.FirstOrDefaultAsync(v =>
                        v.Nomville.ToLower() == dto.Ville.ToLower() && v.Codepostal == dto.CodePostal)
                    ?? new Ville
                    {
                        Nomville = dto.Ville,
                        Codepostal = dto.CodePostal,
                        IddepartementNavigation = departement
                    };

        return new Adresse
        {
            Numerorue = num,
            Nomrue = street,
            IdvilleNavigation = ville
        };
    }



    // PUT: api/Annonces/5
    [HttpPut("{id}")]
    public async Task<IActionResult> PutAnnonce(int id, UpdateAnnonceRequestDTO dto)
    {
        var annonceToUpdate = await _annonceRepository.GetByIdAsync(id);

        if (annonceToUpdate == null)
        {
            return NotFound();
        }

        await _annonceRepository.UpdateFromDtoAsync(annonceToUpdate, dto);

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

    // POST: api/Annonces/{id}/photos
    [HttpPost("{id}/photos")]
    public async Task<IActionResult> AddPhoto(int id, [FromBody] AddPhotoRequest request)
    {
        var photo = await _annonceRepository.AddPhotoAsync(id, request.Url);
        return Ok(new { photo.Idphoto, photo.Idannonce, photo.Lienphoto });
    }

    // POST: api/Annonces/{id}/upload-photo
    [HttpPost("{id}/upload-photo")]
    public async Task<IActionResult> UploadPhoto(int id, IFormFile file)
    {
        if (file == null || file.Length == 0) return BadRequest("No file.");

        using var stream = file.OpenReadStream();

        var uploadParams = new ImageUploadParams()
        {
            File = new FileDescription(file.FileName, stream),
            Folder = "annonce_photos",
            PublicId = $"annonce_{id}_{Guid.NewGuid()}",
            Overwrite = true
        };

        var uploadResult = await _cloudinary.UploadAsync(uploadParams);

        if (uploadResult.Error != null) return BadRequest(uploadResult.Error.Message);

        var photo = await _annonceRepository.AddPhotoAsync(id, uploadResult.SecureUrl.ToString());
        return Ok(new { photo.Idphoto, photo.Idannonce, photo.Lienphoto });
    }

    // DELETE: api/Annonces/photos/{photoId}
    [HttpDelete("photos/{photoId}")]
    public async Task<IActionResult> RemovePhoto(int photoId)
    {
        await _annonceRepository.RemovePhotoAsync(photoId);
        return NoContent();
    }

    // GET: api/Annonces/{id}/indisponibilites
    [HttpGet("{id}/indisponibilites")]
    public async Task<ActionResult<IEnumerable<string>>> GetIndisponibilites(int id)
    {
        var dates = await _annonceRepository.GetIndisponibilitesAsync(id);
        return Ok(dates.Select(d => d.ToString("yyyy-MM-dd")));
    }

    // POST: api/Annonces/{id}/indisponibilites
    [HttpPost("{id}/indisponibilites")]
    public async Task<IActionResult> AddIndisponibilite(int id, [FromBody] UnavailabilityRequest request)
    {
        if (DateOnly.TryParse(request.StartDate, out var start) && DateOnly.TryParse(request.EndDate, out var end))
        {
            await _annonceRepository.SetIndisponibleAsync(id, start, end);
            return Ok();
        }
        return BadRequest("Invalid date format. Use YYYY-MM-DD.");
    }

    // DELETE: api/Annonces/{id}/indisponibilites/{date}
    [HttpDelete("{id}/indisponibilites/{date}")]
    public async Task<IActionResult> RemoveIndisponibilite(int id, string date)
    {
        if (DateOnly.TryParse(date, out var parsedDate))
        {
            await _annonceRepository.RemoveIndisponibiliteAsync(id, parsedDate);
            return NoContent();
        }
        return BadRequest("Invalid date format. Use YYYY-MM-DD.");
    }
}

public class AddPhotoRequest
{
    public string Url { get; set; } = string.Empty;
}

public class UnavailabilityRequest
{
    public string StartDate { get; set; } = string.Empty;
    public string EndDate { get; set; } = string.Empty;
}