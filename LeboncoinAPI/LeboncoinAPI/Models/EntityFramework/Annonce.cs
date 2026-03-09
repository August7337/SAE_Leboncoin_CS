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
    [Required]
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
    [StringLength(50,ErrorMessage ="Le titre de l'annonce ne doit pas depasser 50 caractères")]
    public string TitreAnnonce { get; set; } = null!;

    [Required]
    [Column("descriptionannonce")]
    [StringLength(4000,ErrorMessage ="La description de l'annonce ne doit pas depasser 4000 caractères")]
    public string DescriptionAnnonce { get; set; } = null!;

    [Column("nombreetoilesleboncoin")]
    [Range(1, 5,ErrorMessage ="La note doit être compris entre 1 et 5")]
    public int? NombreEtoilesLeBonCoin { get; set; }


    [Column("lienphoto")]
    [StringLength(50, ErrorMessage = "Le lien de l'image ne peut pas depasser 50 caractères")]
    public string LienPhoto { get; set; } 

    [Column("montantacompte", TypeName = "decimal(10,2)")]
    [Range(0, double.MaxValue,ErrorMessage ="Le montant acompte doit être un nombre positif")]
    public decimal? MontantAcompte { get; set; }

    [Column("pourcentageacompte")]
    [Range(0, 100,ErrorMessage = "Le pourcentage doit être compris entre 1 et 100")]
    public int? PourcentageAcompte { get; set; }

    [Column("prixnuitee", TypeName = "decimal(10,2)")]
    [Range(0.01, double.MaxValue, ErrorMessage = "Le prix de la nuitée doit être strictement positif.")]
    public decimal PrixNuitee { get; set; }

    [Column("capacite")]
    [Range(1,int.MaxValue,ErrorMessage = "La capacité doit être supérieure ou egale à 1")]
    public int? Capacite { get; set; }

    [Column("nbchambres")]

    public int? NbChambres { get; set; }

    [Column("minimumnuitee")]
    [Range(1, int.MaxValue, ErrorMessage = "Le minimum de nuitée doit être supérieur ou egal à 1")]
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

    [ForeignKey(nameof(DateId))]
    public virtual DateReference DatePublication { get; set; } = null!;

    [ForeignKey(nameof(HeureDepartId))]
    public virtual Heure HeureDepart { get; set; } = null!;

    [ForeignKey(nameof(HeureArriveeId))]
    public virtual Heure HeureArrivee { get; set; } = null!;

    [ForeignKey(nameof(TypeHebergementId))]
    [InverseProperty("Annonces")]
    public virtual TypeHebergement TypeHebergementAssocie { get; set; } = null!;

    // Collections inverses
    [InverseProperty("AnnonceConcernee")]
    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

    [InverseProperty("AnnonceEvaluee")]
    public virtual ICollection<Avis> Avis { get; set; } = new List<Avis>();

    // Table de liaison "favoriser"
    public virtual ICollection<Utilisateur> UtilisateursFavoris { get; set; } = new List<Utilisateur>();

    // Table de liaison "proposer"
    public virtual ICollection<Commodite> CommoditesProposees { get; set; } = new List<Commodite>();
}