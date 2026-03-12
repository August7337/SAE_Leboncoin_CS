using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("commodite")]
[Index("Idcategorie", Name = "idx_commodite_idcategorie")]
public partial class Commodite
{
    [Key]
    [Column("idcommodite")]
    public int Idcommodite { get; set; }

    [Column("idcategorie")]
    public int Idcategorie { get; set; }

    [Column("nomcommodite")]
    [StringLength(50)]
    public string? Nomcommodite { get; set; }

    [ForeignKey("Idcategorie")]
    [InverseProperty("Commodites")]
    public virtual Categorie IdcategorieNavigation { get; set; } = null!;

    [ForeignKey("Idcommodite")]
    [InverseProperty("Idcommodites")]
    public virtual ICollection<Annonce> Idannonces { get; set; } = new List<Annonce>();

    [ForeignKey("Idcommodite")]
    [InverseProperty("Idcommodites")]
    public virtual ICollection<Recherche> Idrecherches { get; set; } = new List<Recherche>();
}
