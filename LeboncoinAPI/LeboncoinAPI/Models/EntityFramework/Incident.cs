using LeboncoinAPI.Models.EntityFramework;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("incident")]
public partial class Incident
{
    [Key]
    [Column("idincident")]
    public int IncidentId { get; set; }

    [Column("idutilisateur")]
    public int UtilisateurId { get; set; }

    [Column("idreservation")]
    public int ReservationId { get; set; }

    [Column("iddate")]
    public int DateId { get; set; }

    [Column("motifincident")]
    [StringLength(100)]
    public string? MotifIncident { get; set; }

    [Column("descriptionincident")]
    [StringLength(2000)]
    public string? DescriptionIncident { get; set; }

    [Column("etape")]
    public int Etape { get; set; }

    [Column("estclasse")]
    public bool EstClasse { get; set; }

    [Column("estrembourse")]
    public bool EstRembourse { get; set; }

    [Column("estremisaucontentieux")]
    public bool EstRemisAuContentieux { get; set; }

    [Column("explicationproprietaire")]
    [StringLength(2000)]
    public string? ExplicationProprietaire { get; set; }

    // --- Navigation Properties ---

    [ForeignKey(nameof(ReservationId))]
    [InverseProperty("Incidents")]
    public virtual Reservation ReservationConcernee { get; set; } = null!;

    [ForeignKey(nameof(UtilisateurId))]
    public virtual Utilisateur UtilisateurDeclarant { get; set; } = null!;
}