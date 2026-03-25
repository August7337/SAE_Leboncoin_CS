using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace LeboncoinAPI.Services;

public class IncidentWorkflowService
{
    public const string SIGNALE = "SIGNALE";
    public const string EN_ANALYSE_SERVICE_LOCATION = "EN_ANALYSE_SERVICE_LOCATION";
    public const string CLASSE_SANS_SUITE = "CLASSE_SANS_SUITE";
    public const string EN_ATTENTE_EXPLICATION_PROPRIETAIRE = "EN_ATTENTE_EXPLICATION_PROPRIETAIRE";
    public const string EXPLICATION_PROPRIETAIRE_RECUE = "EXPLICATION_PROPRIETAIRE_RECUE";
    public const string REMBOURSEMENT_ACCEPTE = "REMBOURSEMENT_ACCEPTE";
    public const string REFUS_REMBOURSEMENT = "REFUS_REMBOURSEMENT";
    public const string TRANSFERE_CONTENTIEUX = "TRANSFERE_CONTENTIEUX";
    public const string CLOTURE_SANS_REMBOURSEMENT = "CLOTURE_SANS_REMBOURSEMENT";
    public const string PROCEDURE_JURIDIQUE_ENGAGEE = "PROCEDURE_JURIDIQUE_ENGAGEE";
    public const string REMBOURSEMENT_EFFECTUE = "REMBOURSEMENT_EFFECTUE";

    private static readonly Dictionary<string, HashSet<string>> TransitionsAutorisees = new()
    {
        [SIGNALE] = new() { EN_ANALYSE_SERVICE_LOCATION },
        [EN_ANALYSE_SERVICE_LOCATION] = new() { CLASSE_SANS_SUITE, EN_ATTENTE_EXPLICATION_PROPRIETAIRE },
        [EN_ATTENTE_EXPLICATION_PROPRIETAIRE] = new() { EXPLICATION_PROPRIETAIRE_RECUE },
        [EXPLICATION_PROPRIETAIRE_RECUE] = new() { REMBOURSEMENT_ACCEPTE, REFUS_REMBOURSEMENT },
        [REMBOURSEMENT_ACCEPTE] = new() { REMBOURSEMENT_EFFECTUE },
        [REFUS_REMBOURSEMENT] = new() { CLOTURE_SANS_REMBOURSEMENT, TRANSFERE_CONTENTIEUX },
        [TRANSFERE_CONTENTIEUX] = new() { CLOTURE_SANS_REMBOURSEMENT, PROCEDURE_JURIDIQUE_ENGAGEE },
        [CLASSE_SANS_SUITE] = new(),
        [CLOTURE_SANS_REMBOURSEMENT] = new(),
        [PROCEDURE_JURIDIQUE_ENGAGEE] = new(),
        [REMBOURSEMENT_EFFECTUE] = new(),
    };

    private readonly LeboncoinDBContext _dbContext;

    public IncidentWorkflowService(LeboncoinDBContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task AppliquerTransitionAsync(Incident incident, string codeStatutCible, ClaimsPrincipal user)
    {
        var statutCourant = incident.StatutIncidentNavigation
            ?? await _dbContext.StatutsIncident.FindAsync(incident.Idstatutincident)
            ?? throw new InvalidOperationException("Statut courant introuvable.");

        if (!TransitionsAutorisees.TryGetValue(statutCourant.Code, out var cibles) || !cibles.Contains(codeStatutCible))
        {
            throw new InvalidOperationException($"Transition interdite : '{statutCourant.Code}' -> '{codeStatutCible}'.");
        }

        var nouveauStatut = await _dbContext.StatutsIncident.FirstOrDefaultAsync(s => s.Code == codeStatutCible)
            ?? throw new InvalidOperationException($"Statut cible '{codeStatutCible}' introuvable en base.");

        VerifierAutorisationTransition(incident, statutCourant.Code, codeStatutCible, user);

        incident.Idstatutincident = nouveauStatut.Idstatutincident;
        incident.StatutIncidentNavigation = nouveauStatut;

        var historique = new IncidentHistorique
        {
            Idincident = incident.Idincident,
            Idstatutincident = nouveauStatut.Idstatutincident,
            Datechangement = DateTime.UtcNow,
            Idutilisateurmodificateur = GetCurrentUserId(user)
        };
        await _dbContext.IncidentHistoriques.AddAsync(historique);
    }

    public async Task AssignerAgentAsync(Incident incident, int idAgent, ClaimsPrincipal user)
    {
        if (!EstService(user))
            throw new UnauthorizedAccessException("Seul un service peut assigner un agent.");

        var agent = await _dbContext.Utilisateurs.FindAsync(idAgent);
        if (agent == null)
            throw new InvalidOperationException("Agent introuvable.");

        incident.IdagentAssigne = idAgent;

        var historique = new IncidentHistorique
        {
            Idincident = incident.Idincident,
            Idstatutincident = incident.Idstatutincident,
            Datechangement = DateTime.UtcNow,
            Idutilisateurmodificateur = GetCurrentUserId(user)
        };
        await _dbContext.IncidentHistoriques.AddAsync(historique);
    }

    public bool PeutConsulterIncident(ClaimsPrincipal user, Incident incident)
    {
        if (EstService(user))
        {
            return true;
        }

        var currentUserId = GetCurrentUserId(user);
        if (currentUserId == incident.Idutilisateur)
        {
            return true;
        }

        var idProprietaire = incident.IdreservationNavigation?.IdannonceNavigation?.Idutilisateur;
        return idProprietaire.HasValue && currentUserId == idProprietaire.Value;
    }

    public void VerifierPeutCreerIncident(Reservation reservation, ClaimsPrincipal user)
    {
        if (GetCurrentUserId(user) != reservation.Idutilisateur)
        {
            throw new UnauthorizedAccessException("Seul l'auteur de la reservation peut signaler un incident.");
        }
    }

    public void VerifierPeutSoumettreExplication(Incident incident, ClaimsPrincipal user)
    {
        var idProprietaire = incident.IdreservationNavigation?.IdannonceNavigation?.Idutilisateur
            ?? throw new InvalidOperationException("Proprietaire de l'annonce introuvable.");

        if (GetCurrentUserId(user) != idProprietaire)
        {
            throw new UnauthorizedAccessException("Vous ne pouvez repondre qu'aux incidents de vos annonces.");
        }
    }

    public bool TransitionEstAutorisee(string codeStatutCourant, string codeStatutCible)
    {
        return TransitionsAutorisees.TryGetValue(codeStatutCourant, out var cibles) && cibles.Contains(codeStatutCible);
    }

    private void VerifierAutorisationTransition(Incident incident, string codeStatutCourant, string codeStatutCible, ClaimsPrincipal user)
    {
        switch (codeStatutCible)
        {
            case EN_ANALYSE_SERVICE_LOCATION:
                ExigerRole(user, AppRoles.ServiceLocation);
                ExigerPermission(user, AppPermissions.IncidentTakeInCharge);
                return;

            case CLASSE_SANS_SUITE:
                ExigerRole(user, AppRoles.ServiceLocation);
                ExigerPermission(user, AppPermissions.IncidentClassWithoutFollowUp);
                return;

            case EN_ATTENTE_EXPLICATION_PROPRIETAIRE:
                ExigerRole(user, AppRoles.ServiceLocation);
                ExigerPermission(user, AppPermissions.IncidentRequestOwnerExplanation);
                return;

            case REMBOURSEMENT_ACCEPTE:
            case REFUS_REMBOURSEMENT:
                ExigerRole(user, AppRoles.ServiceLocation);
                ExigerPermission(user, AppPermissions.IncidentDecideRefund);
                return;

            case REMBOURSEMENT_EFFECTUE:
                ExigerRole(user, AppRoles.ServiceComptabilite);
                ExigerPermission(user, AppPermissions.IncidentProcessRefund);
                return;

            case TRANSFERE_CONTENTIEUX:
                ExigerAuteurReservation(user, incident);
                return;

            case CLOTURE_SANS_REMBOURSEMENT:
                if (codeStatutCourant == REFUS_REMBOURSEMENT)
                {
                    ExigerAuteurReservation(user, incident);
                    return;
                }

                ExigerRole(user, AppRoles.ServiceContentieux);
                ExigerPermission(user, AppPermissions.IncidentContentieuxClose);
                return;

            case PROCEDURE_JURIDIQUE_ENGAGEE:
                ExigerRole(user, AppRoles.ServiceContentieux);
                ExigerPermission(user, AppPermissions.IncidentContentieuxLegal);
                return;

            case EXPLICATION_PROPRIETAIRE_RECUE:
                VerifierPeutSoumettreExplication(incident, user);
                return;

            default:
                throw new UnauthorizedAccessException("Transition non autorisee pour votre role.");
        }
    }

    private static void ExigerAuteurReservation(ClaimsPrincipal user, Incident incident)
    {
        if (GetCurrentUserId(user) != incident.Idutilisateur)
        {
            throw new UnauthorizedAccessException("Vous ne pouvez agir que sur vos propres incidents.");
        }
    }

    private static bool EstService(ClaimsPrincipal user)
    {
        return user.IsInRole(AppRoles.ServiceLocation)
            || user.IsInRole(AppRoles.ServiceComptabilite)
            || user.IsInRole(AppRoles.ServiceContentieux);
    }

    private static int GetCurrentUserId(ClaimsPrincipal user)
    {
        var claim = user.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(claim, out var id) ? id : throw new UnauthorizedAccessException("Utilisateur authentifie introuvable.");
    }

    private static void ExigerRole(ClaimsPrincipal user, string role)
    {
        if (!user.IsInRole(role))
        {
            throw new UnauthorizedAccessException($"Le role '{role}' est requis.");
        }
    }

    private static void ExigerPermission(ClaimsPrincipal user, string permission)
    {
        if (!user.Claims.Any(c => c.Type == AuthorizationClaimTypes.Permission && string.Equals(c.Value, permission, StringComparison.OrdinalIgnoreCase)))
        {
            throw new UnauthorizedAccessException($"La permission '{permission}' est requise.");
        }
    }
}
