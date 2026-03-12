using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("region")]
[Index("Nomregion", Name = "region_nomregion_key", IsUnique = true)]
public partial class Region
{
    [Key]
    [Column("idregion")]
    public int Idregion { get; set; }

    [Column("nomregion")]
    [StringLength(30)]
    public string Nomregion { get; set; } = null!;

    [InverseProperty("IdregionNavigation")]
    public virtual ICollection<Departement> Departements { get; set; } = new List<Departement>();

    [InverseProperty("IdregionNavigation")]
    public virtual ICollection<Recherche> Recherches { get; set; } = new List<Recherche>();
}
