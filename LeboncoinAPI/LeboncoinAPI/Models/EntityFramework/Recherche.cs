using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("recherche")]
public partial class Recherche
{
    [Key]
    [Column("idrecherche")]
    public int Idrecherche { get; set; }

    [Column("idutilisateur")]
    public int Idutilisateur { get; set; }

    [Column("idville")]
    public int? Idville { get; set; }

    [Column("iddatefinrecherche")]
    public int? Iddatefinrecherche { get; set; }

    [Column("iddepartement")]
    public int? Iddepartement { get; set; }

    [Column("idregion")]
    public int? Idregion { get; set; }

    [Column("iddatedebutrecherche")]
    public int? Iddatedebutrecherche { get; set; }

    [Column("paiementenligne")]
    public bool Paiementenligne { get; set; }

    [Column("capaciteminimumvoyageur")]
    public int? Capaciteminimumvoyageur { get; set; }

    [Column("prixminimum")]
    [Precision(10, 2)]
    public decimal? Prixminimum { get; set; }

    [Column("prixmaximum")]
    [Precision(10, 2)]
    public decimal? Prixmaximum { get; set; }

    [Column("nombreminimumchambre")]
    public int? Nombreminimumchambre { get; set; }

    [Column("nombremaximumchambre")]
    public int? Nombremaximumchambre { get; set; }

    [ForeignKey("Iddatedebutrecherche")]
    [InverseProperty("RechercheIddatedebutrechercheNavigations")]
    public virtual Date? IddatedebutrechercheNavigation { get; set; }

    [ForeignKey("Iddatefinrecherche")]
    [InverseProperty("RechercheIddatefinrechercheNavigations")]
    public virtual Date? IddatefinrechercheNavigation { get; set; }

    [ForeignKey("Iddepartement")]
    [InverseProperty("Recherches")]
    public virtual Departement? IddepartementNavigation { get; set; }

    [ForeignKey("Idregion")]
    [InverseProperty("Recherches")]
    public virtual Region? IdregionNavigation { get; set; }

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Recherches")]
    public virtual Utilisateur IdutilisateurNavigation { get; set; } = null!;

    [ForeignKey("Idville")]
    [InverseProperty("Recherches")]
    public virtual Ville? IdvilleNavigation { get; set; }

    [ForeignKey("Idrecherche")]
    [InverseProperty("Idrecherches")]
    public virtual ICollection<Commodite> Idcommodites { get; set; } = new List<Commodite>();

    [ForeignKey("Idrecherche")]
    [InverseProperty("Idrecherches")]
    public virtual ICollection<Typehebergement> Idtypehebergements { get; set; } = new List<Typehebergement>();
}
