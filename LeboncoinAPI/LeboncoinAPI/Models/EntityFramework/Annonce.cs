using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("annonce")]
[Index("Capacite", Name = "idx_annonce_capacite")]
[Index("Idadresse", Name = "idx_annonce_idadresse")]
[Index("Iddate", Name = "idx_annonce_iddate")]
[Index("Idheurearrivee", Name = "idx_annonce_idheurearrivee")]
[Index("Idheuredepart", Name = "idx_annonce_idheuredepart")]
[Index("Idtypehebergement", Name = "idx_annonce_idtypehebergement")]
[Index("Idutilisateur", Name = "idx_annonce_idutilisateur")]
[Index("Nbchambres", Name = "idx_annonce_nbchambres")]
[Index("Prixnuitee", Name = "idx_annonce_prixnuitee")]
public partial class Annonce
{
    [Key]
    [Column("idannonce")]
    public int Idannonce { get; set; }

    [Column("idadresse")]
    public int Idadresse { get; set; }

    [Column("iddate")]
    public int Iddate { get; set; }

    [Column("idheuredepart")]
    public int Idheuredepart { get; set; }

    [Column("idtypehebergement")]
    public int Idtypehebergement { get; set; }

    [Column("idheurearrivee")]
    public int Idheurearrivee { get; set; }

    [Column("idutilisateur")]
    public int Idutilisateur { get; set; }

    [Column("titreannonce")]
    [StringLength(50)]
    public string Titreannonce { get; set; } = null!;

    [Column("descriptionannonce")]
    [StringLength(4000)]
    public string Descriptionannonce { get; set; } = null!;

    [Column("lienphoto")]
    [StringLength(200)]
    public string? Lienphoto { get; set; }

    [Column("nombreetoilesleboncoin")]
    public int? Nombreetoilesleboncoin { get; set; }

    [Column("montantacompte")]
    [Precision(10, 2)]
    public decimal? Montantacompte { get; set; }

    [Column("pourcentageacompte")]
    public int? Pourcentageacompte { get; set; }

    [Column("prixnuitee")]
    [Precision(10, 2)]
    public decimal Prixnuitee { get; set; }

    [Column("capacite")]
    public int? Capacite { get; set; }

    [Column("nbchambres")]
    public int? Nbchambres { get; set; }

    [Column("minimumnuitee")]
    public int? Minimumnuitee { get; set; }

    [Column("possibiliteanimaux")]
    public bool Possibiliteanimaux { get; set; }

    [Column("nombrebebesmax")]
    public int? Nombrebebesmax { get; set; }

    [Column("possibilitefumeur")]
    public bool Possibilitefumeur { get; set; }

    [Column("estverifie")]
    public bool Estverifie { get; set; }

    [Column("smsverifie")]
    public bool Smsverifie { get; set; }

    [InverseProperty("IdannonceNavigation")]
    public virtual ICollection<Avi> Avis { get; set; } = new List<Avi>();

    [ForeignKey("Idadresse")]
    [InverseProperty("Annonces")]
    public virtual Adresse IdadresseNavigation { get; set; } = null!;

    [ForeignKey("Iddate")]
    [InverseProperty("Annonces")]
    public virtual Date IddateNavigation { get; set; } = null!;

    [ForeignKey("Idheurearrivee")]
    [InverseProperty("AnnonceIdheurearriveeNavigations")]
    public virtual Heure IdheurearriveeNavigation { get; set; } = null!;

    [ForeignKey("Idheuredepart")]
    [InverseProperty("AnnonceIdheuredepartNavigations")]
    public virtual Heure IdheuredepartNavigation { get; set; } = null!;

    [ForeignKey("Idtypehebergement")]
    [InverseProperty("Annonces")]
    public virtual Typehebergement IdtypehebergementNavigation { get; set; } = null!;

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Annonces")]
    public virtual Utilisateur IdutilisateurNavigation { get; set; } = null!;

    [InverseProperty("IdannonceNavigation")]
    public virtual ICollection<Relier> Reliers { get; set; } = new List<Relier>();

    [InverseProperty("IdannonceNavigation")]
    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

    [ForeignKey("IdannonceB")]
    [InverseProperty("IdannonceBs")]
    public virtual ICollection<Annonce> IdannonceAs { get; set; } = new List<Annonce>();

    [ForeignKey("IdannonceA")]
    [InverseProperty("IdannonceAs")]
    public virtual ICollection<Annonce> IdannonceBs { get; set; } = new List<Annonce>();

    [ForeignKey("Idannonce")]
    [InverseProperty("Idannonces")]
    public virtual ICollection<Commodite> Idcommodites { get; set; } = new List<Commodite>();

    [ForeignKey("Idannonce")]
    [InverseProperty("Idannonces")]
    public virtual ICollection<Utilisateur> Idutilisateurs { get; set; } = new List<Utilisateur>();
}
