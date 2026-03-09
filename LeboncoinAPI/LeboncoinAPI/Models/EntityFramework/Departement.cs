using LeboncoinAPI.Models.EntityFramework;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("departement")]
public partial class Departement
{
    [Key]
    [Column("iddepartement")]
    public int DepartementId { get; set; }

    [Column("idregion")]
    public int RegionId { get; set; }

    [Column("numerodepartement")]
    [StringLength(3, ErrorMessage = "Le numero du département ne doit pas dépasser 3 caractères")]
    public string? NumeroDepartement { get; set; }

    [Column("nomdepartement")]
    [StringLength(25, ErrorMessage = "Le nom du département ne doit pas dépasser 25 caractères")]
    public string? NomDepartement { get; set; }

    [ForeignKey(nameof(RegionId))]
    public virtual Region RegionAssociee { get; set; } = null!;

    [InverseProperty("DepartementAssocie")]
    public virtual ICollection<Ville> Villes { get; set; } = new List<Ville>();
}