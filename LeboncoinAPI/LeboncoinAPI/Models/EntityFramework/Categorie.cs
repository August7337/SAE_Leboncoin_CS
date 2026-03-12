using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("categorie")]
public partial class Categorie
{
    [Key]
    [Column("idcategorie")]
    public int Idcategorie { get; set; }

    [Column("nomcategorie")]
    [StringLength(50)]
    public string? Nomcategorie { get; set; }

    [InverseProperty("IdcategorieNavigation")]
    public virtual ICollection<Commodite> Commodites { get; set; } = new List<Commodite>();

    [InverseProperty("IdcategorieNavigation")]
    public virtual ICollection<Typehebergement> Typehebergements { get; set; } = new List<Typehebergement>();
}
