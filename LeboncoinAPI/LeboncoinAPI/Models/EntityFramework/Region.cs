using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("region")]
public partial class Region
{
    [Key]
    [Column("idregion")]
    public int RegionId { get; set; }

    [Required]
    [Column("nomregion")]
    [StringLength(30)]
    public string NomRegion { get; set; } = null!;

    [InverseProperty("RegionAssociee")]
    public virtual ICollection<Departement> Departements { get; set; } = new List<Departement>();
}