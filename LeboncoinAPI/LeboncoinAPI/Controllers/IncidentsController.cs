using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using LeboncoinAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize]
public class IncidentsController : ControllerBase
{
    private readonly IIncidentRepository _incidentRepository;
    private readonly IncidentWorkflowService _workflowService;
    private readonly LeboncoinDBContext _dbContext;

    public IncidentsController(IIncidentRepository incidentRepository, IncidentWorkflowService workflowService, LeboncoinDBContext dbContext)
    {
        _incidentRepository = incidentRepository;
        _workflowService = workflowService;
        _dbContext = dbContext;
    }

    private int GetCurrentUserId() => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    private bool EstServiceInterne()
    {
        return User.IsInRole(AppRoles.ServiceLocation)
            || User.IsInRole(AppRoles.ServiceComptabilite)
            || User.IsInRole(AppRoles.ServiceContentieux);
    }

    private static IncidentDetailDTO MapToDetail(Incident incident) => new()
    {
        Idincident = incident.Idincident,
        Idreservation = incident.Idreservation,
        Idutilisateur = incident.Idutilisateur,
        IdagentAssigne = incident.IdagentAssigne,
        Motifincident = incident.Motifincident,
        Descriptionincident = incident.Descriptionincident,
        Explicationproprietaire = incident.Explicationproprietaire,
        DateSignalement = incident.IddateNavigation?.Date1?.ToString("yyyy-MM-dd"),
        Statut = new StatutIncidentDTO
        {
            Id = incident.StatutIncidentNavigation.Idstatutincident,
            Code = incident.StatutIncidentNavigation.Code,
            Libelle = incident.StatutIncidentNavigation.Libelle,
            EstFinal = incident.StatutIncidentNavigation.Estfinal,
        },
        Photos = incident.Photos.Select(p => new PhotoIncidentDTO
        {
            Idphoto = p.Idphoto,
            Urlphoto = p.Lienphoto,
            Originephoto = p.Originephoto ?? 1,
        }).ToList(),
    };

    [HttpGet("{id:int}")]
    public async Task<ActionResult<IncidentDetailDTO>> GetById(int id)
    {
        var incident = await _incidentRepository.GetByIdAsync(id);
        if (incident == null) return NotFound("Incident introuvable.");
        if (!_workflowService.PeutConsulterIncident(User, incident)) return Forbid();
        return Ok(MapToDetail(incident));
    }

    [HttpGet("mes-incidents")]
    public async Task<ActionResult<IEnumerable<IncidentDetailDTO>>> GetMesIncidents()
    {
        IEnumerable<Incident> incidents;

        if (EstServiceInterne())
        {
            incidents = await _incidentRepository.GetAllAsync();
        }
        else
        {
            var currentUserId = GetCurrentUserId();
            var incidentsCommeLocataire = await _incidentRepository.GetByUtilisateurAsync(currentUserId);
            var incidentsCommeProprietaire = await _incidentRepository.GetByProprietaireAsync(currentUserId);
            incidents = incidentsCommeLocataire
                .Concat(incidentsCommeProprietaire)
                .GroupBy(incident => incident.Idincident)
                .Select(group => group.First())
                .OrderByDescending(incident => incident.Idincident)
                .ToList();
        }

        return Ok(incidents.Select(MapToDetail));
    }

    [HttpGet("reservation/{idReservation:int}")]
    public async Task<ActionResult<IEnumerable<IncidentDetailDTO>>> GetByReservation(int idReservation)
    {
        var incidents = await _incidentRepository.GetByReservationAsync(idReservation);
        var visibles = incidents.Where(incident => _workflowService.PeutConsulterIncident(User, incident));
        if (incidents.Any() && !visibles.Any()) return Forbid();
        return Ok(visibles.Select(MapToDetail));
    }

    [HttpPost]
    public async Task<ActionResult<IncidentDetailDTO>> Create([FromBody] IncidentCreateDTO dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var idUtilisateur = GetCurrentUserId();
        var reservation = await _dbContext.Reservations.FindAsync(dto.Idreservation);
        if (reservation == null) return NotFound("Reservation introuvable.");

        try
        {
            _workflowService.VerifierPeutCreerIncident(reservation, User);
        }
        catch (UnauthorizedAccessException ex)
        {
            return Forbid(ex.Message);
        }

        var statutSignale = await _dbContext.StatutsIncident.FirstOrDefaultAsync(s => s.Code == IncidentWorkflowService.SIGNALE);
        if (statutSignale == null)
        {
            return StatusCode(500, "Statut initial 'SIGNALE' introuvable en base.");
        }

        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var date = await _dbContext.Dates.FirstOrDefaultAsync(d => d.Date1 == today) ?? new Date { Date1 = today };

        var incident = new Incident
        {
            Idutilisateur = idUtilisateur,
            Idreservation = dto.Idreservation,
            Idstatutincident = statutSignale.Idstatutincident,
            StatutIncidentNavigation = statutSignale,
            Motifincident = dto.Motifincident,
            Descriptionincident = dto.Descriptionincident,
            IddateNavigation = date,
        };

        await _incidentRepository.AddAsync(incident);
        var created = await _incidentRepository.GetByIdAsync(incident.Idincident);
        return CreatedAtAction(nameof(GetById), new { id = incident.Idincident }, MapToDetail(created!));
    }

    [HttpPost("{id:int}/prise-en-charge")]
    [Authorize(Roles = AppRoles.ServiceLocation)]
    public async Task<ActionResult<IncidentDetailDTO>> PrendreEnCharge(int id)
    {
        var incident = await _incidentRepository.GetByIdAsync(id);
        if (incident == null) return NotFound("Incident introuvable.");

        try
        {
            // Assigner l'agent courant à l'incident
            incident.IdagentAssigne = GetCurrentUserId();
            
            // Appliquer la transition de statut
            await _workflowService.AppliquerTransitionAsync(incident, IncidentWorkflowService.EN_ANALYSE_SERVICE_LOCATION, User);
            await _incidentRepository.UpdateAsync(incident);
        }
        catch (UnauthorizedAccessException ex)
        {
            return Forbid(ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            return UnprocessableEntity(new { message = ex.Message });
        }

        var updated = await _incidentRepository.GetByIdAsync(id);
        return Ok(MapToDetail(updated!));
    }

    [HttpPost("{id:int}/classe-sans-suite")]
    [Authorize(Roles = AppRoles.ServiceLocation)]
    public Task<ActionResult<IncidentDetailDTO>> ClasserSansSuite(int id)
    {
        return ExecuterTransitionAsync(id, IncidentWorkflowService.CLASSE_SANS_SUITE);
    }

    [HttpPost("{id:int}/demande-explication-proprietaire")]
    [Authorize(Roles = AppRoles.ServiceLocation)]
    public Task<ActionResult<IncidentDetailDTO>> DemanderExplicationProprietaire(int id)
    {
        return ExecuterTransitionAsync(id, IncidentWorkflowService.EN_ATTENTE_EXPLICATION_PROPRIETAIRE);
    }

    [HttpPost("{id:int}/decision-service-location")]
    [Authorize(Roles = AppRoles.ServiceLocation)]
    public Task<ActionResult<IncidentDetailDTO>> DecisionServiceLocation(int id, [FromBody] IncidentTransitionDTO dto)
    {
        if (dto.CodeStatutCible != IncidentWorkflowService.REMBOURSEMENT_ACCEPTE
            && dto.CodeStatutCible != IncidentWorkflowService.REFUS_REMBOURSEMENT)
        {
            return Task.FromResult<ActionResult<IncidentDetailDTO>>(BadRequest("Decision invalide pour le service location."));
        }

        return ExecuterTransitionAsync(id, dto.CodeStatutCible);
    }

    [HttpPost("{id:int}/decision-locataire")]
    public Task<ActionResult<IncidentDetailDTO>> DecisionLocataire(int id, [FromBody] IncidentTransitionDTO dto)
    {
        if (dto.CodeStatutCible != IncidentWorkflowService.CLOTURE_SANS_REMBOURSEMENT
            && dto.CodeStatutCible != IncidentWorkflowService.TRANSFERE_CONTENTIEUX)
        {
            return Task.FromResult<ActionResult<IncidentDetailDTO>>(BadRequest("Decision invalide pour le locataire."));
        }

        return ExecuterTransitionAsync(id, dto.CodeStatutCible);
    }

    [HttpPost("{id:int}/decision-contentieux")]
    [Authorize(Roles = AppRoles.ServiceContentieux)]
    public Task<ActionResult<IncidentDetailDTO>> DecisionContentieux(int id, [FromBody] IncidentTransitionDTO dto)
    {
        if (dto.CodeStatutCible != IncidentWorkflowService.CLOTURE_SANS_REMBOURSEMENT
            && dto.CodeStatutCible != IncidentWorkflowService.PROCEDURE_JURIDIQUE_ENGAGEE)
        {
            return Task.FromResult<ActionResult<IncidentDetailDTO>>(BadRequest("Decision invalide pour le contentieux."));
        }

        return ExecuterTransitionAsync(id, dto.CodeStatutCible);
    }

    [HttpPost("{id:int}/validation-remboursement")]
    [Authorize(Roles = AppRoles.ServiceComptabilite)]
    public Task<ActionResult<IncidentDetailDTO>> ValiderRemboursement(int id)
    {
        return ExecuterTransitionAsync(id, IncidentWorkflowService.REMBOURSEMENT_EFFECTUE);
    }

    private async Task<ActionResult<IncidentDetailDTO>> ExecuterTransitionAsync(int id, string codeStatutCible)
    {
        var incident = await _incidentRepository.GetByIdAsync(id);
        if (incident == null) return NotFound("Incident introuvable.");

        try
        {
            await _workflowService.AppliquerTransitionAsync(incident, codeStatutCible, User);
            await _incidentRepository.UpdateAsync(incident);
        }
        catch (UnauthorizedAccessException ex)
        {
            return Forbid(ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            return UnprocessableEntity(new { message = ex.Message });
        }

        var updated = await _incidentRepository.GetByIdAsync(id);
        return Ok(MapToDetail(updated!));
    }

    [HttpPost("{id:int}/explication-proprietaire")]
    public async Task<ActionResult<IncidentDetailDTO>> SoumettreExplication(int id, [FromBody] IncidentExplicationDTO dto)
    {
        var incident = await _incidentRepository.GetByIdAsync(id);
        if (incident == null) return NotFound("Incident introuvable.");
        if (string.IsNullOrWhiteSpace(dto.Explication)) return BadRequest("L'explication ne peut pas etre vide.");
        if (incident.StatutIncidentNavigation.Code != IncidentWorkflowService.EN_ATTENTE_EXPLICATION_PROPRIETAIRE)
        {
            return UnprocessableEntity(new { message = "L'incident n'est pas en attente d'explication proprietaire." });
        }

        incident.Explicationproprietaire = dto.Explication;

        try
        {
            _workflowService.VerifierPeutSoumettreExplication(incident, User);
            await _workflowService.AppliquerTransitionAsync(incident, IncidentWorkflowService.EXPLICATION_PROPRIETAIRE_RECUE, User);
            await _incidentRepository.UpdateAsync(incident);
        }
        catch (UnauthorizedAccessException ex)
        {
            return Forbid(ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            return UnprocessableEntity(new { message = ex.Message });
        }

        var updated = await _incidentRepository.GetByIdAsync(id);
        return Ok(MapToDetail(updated!));
    }

    [HttpGet("{id:int}/timeline")]
    public async Task<ActionResult<IEnumerable<IncidentTimelineDTO>>> GetTimeline(int id)
    {
        var incident = await _incidentRepository.GetByIdAsync(id);
        if (incident == null) return NotFound("Incident introuvable.");
        if (!_workflowService.PeutConsulterIncident(User, incident)) return Forbid();

        var historiques = await _dbContext.IncidentHistoriques
            .Where(h => h.Idincident == id)
            .Include(h => h.IdstatutincidentNavigation)
            .Include(h => h.IdutilisateurmodificateurNavigation)
            .OrderByDescending(h => h.Datechangement)
            .ToListAsync();

        var timeline = historiques.Select(h => new IncidentTimelineDTO
        {
            Idincidentshistorique = h.Idincidentshistorique,
            Idincident = h.Idincident,
            Datechangement = h.Datechangement,
            Statut = new StatutIncidentDTO
            {
                Id = h.IdstatutincidentNavigation.Idstatutincident,
                Code = h.IdstatutincidentNavigation.Code,
                Libelle = h.IdstatutincidentNavigation.Libelle,
                Ordre = h.IdstatutincidentNavigation.Ordre,
                EstFinal = h.IdstatutincidentNavigation.Estfinal
            },
            Modificateur = new UtilisateurMiniDTO
            {
                Idutilisateur = h.IdutilisateurmodificateurNavigation.Idutilisateur,
                Pseudonyme = h.IdutilisateurmodificateurNavigation.Pseudonyme,
                Email = h.IdutilisateurmodificateurNavigation.Email
            }
        }).ToList();

        return Ok(timeline);
    }

    [HttpPost("{id:int}/assigner-agent")]
    [Authorize(Roles = AppRoles.ServiceLocation)]
    public async Task<ActionResult<IncidentAssignmentDTO>> AssignerAgent(int id, [FromBody] AssignAgentRequestDTO dto)
    {
        var incident = await _incidentRepository.GetByIdAsync(id);
        if (incident == null) return NotFound("Incident introuvable.");

        try
        {
            await _workflowService.AssignerAgentAsync(incident, dto.IdagentAssigne, User);
            await _incidentRepository.UpdateAsync(incident);
        }
        catch (UnauthorizedAccessException ex)
        {
            return Forbid(ex.Message);
        }
        catch (InvalidOperationException ex)
        {
            return UnprocessableEntity(new { message = ex.Message });
        }

        var updated = await _incidentRepository.GetByIdAsync(id);
        var agent = updated?.IdagentAssigneNavigation;

        return Ok(new IncidentAssignmentDTO
        {
            Idincident = updated!.Idincident,
            IdagentAssigne = updated.IdagentAssigne,
            AgentAssigne = agent != null ? new UtilisateurMiniDTO
            {
                Idutilisateur = agent.Idutilisateur,
                Pseudonyme = agent.Pseudonyme,
                Email = agent.Email
            } : null,
            DateAssignation = DateTime.UtcNow
        });
    }

    [HttpGet("statuts")]
    [AllowAnonymous]
    public async Task<ActionResult<IEnumerable<StatutIncidentDTO>>> GetStatuts()
    {
        var statuts = await _dbContext.StatutsIncident
            .OrderBy(s => s.Ordre)
            .Select(s => new StatutIncidentDTO
            {
                Id = s.Idstatutincident,
                Code = s.Code,
                Libelle = s.Libelle,
                EstFinal = s.Estfinal,
            })
            .ToListAsync();

        return Ok(statuts);
    }

    [HttpPost("{id:int}/photos")]
    [Consumes("multipart/form-data")]
    public async Task<ActionResult<PhotoIncidentDTO>> AjouterPhoto(int id, IFormFile file, [FromForm] int origine = 1)
    {
        if (file == null || file.Length == 0)
            return BadRequest("Aucun fichier fourni.");

        var allowedTypes = new[] { "image/jpeg", "image/png", "image/webp", "image/gif" };
        if (!allowedTypes.Contains(file.ContentType.ToLower()))
            return BadRequest("Type de fichier non autorisé. Utilisez JPG, PNG, WEBP ou GIF.");

        if (file.Length > 10 * 1024 * 1024)
            return BadRequest("Le fichier dépasse la taille maximale autorisée (10 MB).");

        var incident = await _incidentRepository.GetByIdAsync(id);
        if (incident == null) return NotFound("Incident introuvable.");
        if (!_workflowService.PeutConsulterIncident(User, incident)) return Forbid();

        var uploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads", "incidents", id.ToString());
        Directory.CreateDirectory(uploadsDir);

        var ext = Path.GetExtension(file.FileName);
        var fileName = $"{Guid.NewGuid()}{ext}";
        var filePath = Path.Combine(uploadsDir, fileName);

        await using (var stream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(stream);
        }

        var relativeUrl = $"/uploads/incidents/{id}/{fileName}";

        var photo = new LeboncoinAPI.Models.EntityFramework.Photo
        {
            Idincident = id,
            Lienphoto = relativeUrl,
            Originephoto = origine,
        };

        _dbContext.Photos.Add(photo);
        await _dbContext.SaveChangesAsync();

        return Ok(new PhotoIncidentDTO
        {
            Idphoto = photo.Idphoto,
            Urlphoto = relativeUrl,
            Originephoto = origine,
        });
    }
}
