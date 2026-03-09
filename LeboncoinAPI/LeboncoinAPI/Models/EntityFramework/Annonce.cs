using LeboncoinAPI.Models.EntityFramework;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("annonce")]
public partial class Annonce
{
    [Key]
    [Column("idannonce")]
    public int AnnonceId { get; set; }

    [Column("idadresse")]
    public int AdresseId { get; set; }

    [Column("iddate")]
    public int DateId { get; set; }

    [Column("idheuredepart")]
    public int HeureDepartId { get; set; }

    [Column("idtypehebergement")]
    public int TypeHebergementId { get; set; }

    [Column("idheurearrivee")]
    public int HeureArriveeId { get; set; }

    [Column("idutilisateur")]
    public int UtilisateurId { get; set; }

    [Required]
    [Column("titreannonce")]
    [StringLength(50)]
    public string TitreAnnonce { get; set; } = null!;

    [Required]
    [Column("descriptionannonce")]
    [StringLength(4000)]
    public string DescriptionAnnonce { get; set; } = null!;

    [Column("nombreetoilesleboncoin")]
    [Range(1, 5)]
    public int? NombreEtoilesLeBonCoin { get; set; }

    [Column("montantacompte", TypeName = "decimal(10,2)")]
    [Range(0, double.MaxValue)]
    public decimal? MontantAcompte { get; set; }

    [Column("pourcentageacompte")]
    [Range(0, 100)]
    public int? PourcentageAcompte { get; set; }

    [Column("prixnuitee", TypeName = "decimal(10,2)")]
    [Range(0.01, double.MaxValue, ErrorMessage = "Le prix de la nuitée doit être strictement positif.")]
    public decimal PrixNuitee { get; set; }

    [Column("capacite")]
    public int? Capacite { get; set; }

    [Column("nbchambres")]
    public int? NbChambres { get; set; }

    [Column("minimumnuitee")]
    [Range(1, int.MaxValue)]
    public int? MinimumNuitee { get; set; }

    [Column("possibiliteanimaux")]
    public bool PossibiliteAnimaux { get; set; }

    [Column("nombrebebesmax")]
    [Range(0, int.MaxValue)]
    public int? NombreBebesMax { get; set; }

    [Column("possibilitefumeur")]
    public bool PossibiliteFumeur { get; set; }

    [Column("estverifie")]
    public bool EstVerifie { get; set; }

    [Column("smsverifie")]
    public bool SmsVerifie { get; set; }

    // --- Navigation Properties ---

    [ForeignKey(nameof(UtilisateurId))]
    [InverseProperty("AnnoncesPubliees")]
    public virtual Utilisateur UtilisateurAuteur { get; set; } = null!;

    [ForeignKey(nameof(AdresseId))]
    public virtual Adresse AdresseAnnonce { get; set; } = null!;

    [InverseProperty("AnnonceConcernee")]
    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

    [InverseProperty("AnnonceEvaluee")]
    public virtual ICollection<Avis> Avis { get; set; } = new List<Avis>();

    // Table de liaison "favoriser"
    public virtual ICollection<Utilisateur> UtilisateursFavoris { get; set; } = new List<Utilisateur>();
}