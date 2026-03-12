using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("departement")]
[Index("Idregion", Name = "idx_departement_idregion")]
public partial class Departement
{
    [Key]
    [Column("iddepartement")]
    public int Iddepartement { get; set; }

    [Column("idregion")]
    public int Idregion { get; set; }

    [Column("numerodepartement")]
    [StringLength(3)]
    public string? Numerodepartement { get; set; }

    [Column("nomdepartement")]
    [StringLength(25)]
    public string? Nomdepartement { get; set; }

    [ForeignKey("Idregion")]
    [InverseProperty("Departements")]
    public virtual Region IdregionNavigation { get; set; } = null!;

    [InverseProperty("IddepartementNavigation")]
    public virtual ICollection<Recherche> Recherches { get; set; } = new List<Recherche>();

    [InverseProperty("IddepartementNavigation")]
    public virtual ICollection<Ville> Villes { get; set; } = new List<Ville>();
}
