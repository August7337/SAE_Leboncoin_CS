using LeboncoinAPI.Models.EntityFramework;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("commodite")]
public partial class Commodite
{
    [Key]
    [Column("idcommodite")]
    public int CommoditeId { get; set; }

    [Column("idcategorie")]
    public int CategorieId { get; set; }

    [Column("nomcommodite")]
    [StringLength(50)]
    public string? NomCommodite { get; set; }

    [ForeignKey(nameof(CategorieId))]
    public virtual Categorie CategorieCommodite { get; set; } = null!;

    // Table de liaison Many-to-Many "proposer" (Annonce <-> Commodite)
    public virtual ICollection<Annonce> AnnoncesQuiProposent { get; set; } = new List<Annonce>();
}