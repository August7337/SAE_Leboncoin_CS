using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("ville")]
[Index("Iddepartement", Name = "idx_ville_iddepartement")]
public partial class Ville
{
    [Key]
    [Column("idville")]
    public int Idville { get; set; }

    [Column("iddepartement")]
    public int Iddepartement { get; set; }

    [Column("codepostal")]
    [StringLength(5)]
    public string Codepostal { get; set; } = null!;

    [Column("nomville")]
    [StringLength(40)]
    public string Nomville { get; set; } = null!;

    [Column("taxedesejour")]
    [Precision(10, 2)]
    public decimal Taxedesejour { get; set; }

    [InverseProperty("IdvilleNavigation")]
    public virtual ICollection<Adresse> Adresses { get; set; } = new List<Adresse>();

    [ForeignKey("Iddepartement")]
    [InverseProperty("Villes")]
    public virtual Departement IddepartementNavigation { get; set; } = null!;

    [InverseProperty("IdvilleNavigation")]
    public virtual ICollection<Recherche> Recherches { get; set; } = new List<Recherche>();
}
