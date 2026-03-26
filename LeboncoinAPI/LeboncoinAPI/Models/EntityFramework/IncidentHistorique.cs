using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("incident_historique")]
[Index("Idincident", Name = "idx_incident_historique_idincident")]
public partial class IncidentHistorique
{
    [Key]
    [Column("idincidentshistorique")]
    public int Idincidentshistorique { get; set; }

    [Column("idincident")]
    public int Idincident { get; set; }

    [Column("idstatutincident")]
    public int Idstatutincident { get; set; }

    [Column("datechangement")]
    public DateTime Datechangement { get; set; }

    [Column("idutilisateurmodificateur")]
    public int Idutilisateurmodificateur { get; set; }

    [ForeignKey("Idincident")]
    [InverseProperty("Historiques")]
    public virtual Incident IdincidentNavigation { get; set; } = null!;

    [ForeignKey("Idstatutincident")]
    [InverseProperty("HistoriquesStatut")]
    public virtual StatutIncident IdstatutincidentNavigation { get; set; } = null!;

    [ForeignKey("Idutilisateurmodificateur")]
    [InverseProperty("HistoriquesModifies")]
    public virtual Utilisateur IdutilisateurmodificateurNavigation { get; set; } = null!;
}
