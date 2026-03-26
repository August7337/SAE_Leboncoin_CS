namespace LeboncoinAPI.Models.DTOs;

public class IncidentCreateDTO
{
    public int Idreservation { get; set; }
    public string? Motifincident { get; set; }
    public string? Descriptionincident { get; set; }
}

public class PhotoIncidentDTO
{
    public int Idphoto { get; set; }
    public string? Urlphoto { get; set; }
    public int Originephoto { get; set; }
}

public class IncidentDetailDTO
{
    public int Idincident { get; set; }
    public int Idreservation { get; set; }
    public int Idutilisateur { get; set; }
    public int? IdagentAssigne { get; set; }
    public string? Motifincident { get; set; }
    public string? Descriptionincident { get; set; }
    public string? Explicationproprietaire { get; set; }
    public StatutIncidentDTO Statut { get; set; } = null!;
    public string? DateSignalement { get; set; }
    public List<PhotoIncidentDTO> Photos { get; set; } = new();
}

public class StatutIncidentDTO
{
    public int Id { get; set; }
    public string Code { get; set; } = null!;
    public string Libelle { get; set; } = null!;
    public int Ordre { get; set; }
    public bool EstFinal { get; set; }
}

public class IncidentTransitionDTO
{
    public string CodeStatutCible { get; set; } = null!;
}

public class IncidentExplicationDTO
{
    public string Explication { get; set; } = null!;
}

public class UtilisateurMiniDTO
{
    public int Idutilisateur { get; set; }
    public string Pseudonyme { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
}

public class IncidentTimelineDTO
{
    public int Idincidentshistorique { get; set; }
    public int Idincident { get; set; }
    public DateTime Datechangement { get; set; }
    public StatutIncidentDTO Statut { get; set; } = new();
    public UtilisateurMiniDTO Modificateur { get; set; } = new();
}

public class AssignAgentRequestDTO
{
    public int IdagentAssigne { get; set; }
}

public class IncidentAssignmentDTO
{
    public int Idincident { get; set; }
    public int? IdagentAssigne { get; set; }
    public UtilisateurMiniDTO? AgentAssigne { get; set; }
    public DateTime? DateAssignation { get; set; }
}
