using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("typevoyageur")]
public partial class TypeVoyageur
{
    [Key]
    [Column("idtypevoyageur")]
    public int TypeVoyageurId { get; set; }

    [Required]
    [Column("nomtypevoyageur")]
    [StringLength(30)]
    public string NomTypeVoyageur { get; set; } = null!;
}