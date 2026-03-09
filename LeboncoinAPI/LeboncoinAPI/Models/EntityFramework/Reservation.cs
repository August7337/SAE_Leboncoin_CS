using LeboncoinAPI.Models.EntityFramework;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("reservation")]
public partial class Reservation
{
    [Key]
    [Column("idreservation")]
    public int ReservationId { get; set; }

    [Column("idannonce")]
    public int AnnonceId { get; set; }

    [Column("iddatedebutreservation")]
    public int DateDebutId { get; set; }

    [Column("iddatefinreservation")]
    public int DateFinId { get; set; }

    [Column("idutilisateur")]
    public int UtilisateurId { get; set; }

    [Required]
    [Column("nomclient")]
    [StringLength(50, ErrorMessage = "Le nom ne doit pas dépasser 50 caractères")]
    public string NomClient { get; set; } = null!;

    [Required]
    [Column("prenomclient")]
    [StringLength(50, ErrorMessage = "Le prenom ne doit pas dépasser 50 caractères")]
    public string PrenomClient { get; set; } = null!;

    [Column("telephoneclient", TypeName = "char(10)")]
    [RegularExpression(@"^0[1-9][0-9]{8}$", ErrorMessage = "Le numéro de téléphone doit contenir 10 chiffres et commencer par 0.")]
    public string? TelephoneClient { get; set; }

    // --- Navigation Properties ---

    [ForeignKey(nameof(AnnonceId))]
    [InverseProperty("Reservations")]
    public virtual Annonce AnnonceConcernee { get; set; } = null!;

    [ForeignKey(nameof(UtilisateurId))]
    [InverseProperty("Reservations")]
    public virtual Utilisateur Client { get; set; } = null!;

    [InverseProperty("ReservationConcernee")]
    public virtual ICollection<Incident> Incidents { get; set; } = new List<Incident>();
}