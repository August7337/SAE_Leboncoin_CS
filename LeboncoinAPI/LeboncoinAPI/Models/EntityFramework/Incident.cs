using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("incident")]
[Index("Idreservation", Name = "idx_incident_idreservation")]
[Index("Idutilisateur", Name = "idx_incident_idutilisateur")]
[Index("Idstatutincident", Name = "idx_incident_idstatutincident")]
public partial class Incident
{
    [Key]
    [Column("idincident")]
    public int Idincident { get; set; }

    [Column("idutilisateur")]
    public int Idutilisateur { get; set; }

    [Column("idreservation")]
    public int Idreservation { get; set; }

    [Column("iddate")]
    public int Iddate { get; set; }

    [Column("idstatutincident")]
    public int Idstatutincident { get; set; }

    [Column("idagentassigne")]
    public int? IdagentAssigne { get; set; }

    [Column("motifincident")]
    [StringLength(100)]
    public string? Motifincident { get; set; }

    [Column("descriptionincident")]
    [StringLength(2000)]
    public string? Descriptionincident { get; set; }

    [Column("explicationproprietaire")]
    [StringLength(2000)]
    public string? Explicationproprietaire { get; set; }

    [ForeignKey("Iddate")]
    [InverseProperty("Incidents")]
    public virtual Date IddateNavigation { get; set; } = null!;

    [ForeignKey("Idreservation")]
    [InverseProperty("Incidents")]
    public virtual Reservation IdreservationNavigation { get; set; } = null!;

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Incidents")]
    public virtual Utilisateur IdutilisateurNavigation { get; set; } = null!;

    [ForeignKey("Idstatutincident")]
    [InverseProperty("Incidents")]
    public virtual StatutIncident StatutIncidentNavigation { get; set; } = null!;

    [ForeignKey("IdagentAssigne")]
    [InverseProperty("IncidentsAssignes")]
    public virtual Utilisateur? IdagentAssigneNavigation { get; set; }

    [InverseProperty("IdincidentNavigation")]
    public virtual ICollection<Photo> Photos { get; set; } = new List<Photo>();

    [ForeignKey("Idincident")]
    [InverseProperty("Idincidents")]
    public virtual ICollection<Compensation> Idcompensations { get; set; } = new List<Compensation>();

    [InverseProperty("IdincidentNavigation")]
    public virtual ICollection<IncidentHistorique> Historiques { get; set; } = new List<IncidentHistorique>();
}
