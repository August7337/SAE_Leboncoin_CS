using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("typehebergement")]
[Index("Idcategorie", Name = "idx_typehebergement_idcategorie")]
public partial class Typehebergement
{
    [Key]
    [Column("idtypehebergement")]
    public int Idtypehebergement { get; set; }

    [Column("idcategorie")]
    public int Idcategorie { get; set; }

    [Column("nomtypehebergement")]
    [StringLength(30)]
    public string? Nomtypehebergement { get; set; }

    [InverseProperty("IdtypehebergementNavigation")]
    public virtual ICollection<Annonce> Annonces { get; set; } = new List<Annonce>();

    [ForeignKey("Idcategorie")]
    [InverseProperty("Typehebergements")]
    public virtual Categorie IdcategorieNavigation { get; set; } = null!;

    [ForeignKey("Idtypehebergement")]
    [InverseProperty("Idtypehebergements")]
    public virtual ICollection<Recherche> Idrecherches { get; set; } = new List<Recherche>();
}
