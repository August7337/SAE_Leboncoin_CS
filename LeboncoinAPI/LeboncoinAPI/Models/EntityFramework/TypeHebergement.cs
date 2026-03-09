using LeboncoinAPI.Models.EntityFramework;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("typehebergement")]
public partial class TypeHebergement
{
    [Key]
    [Column("idtypehebergement")]
    public int TypeHebergementId { get; set; }

    [Column("idcategorie")]
    public int CategorieId { get; set; }

    [Column("nomtypehebergement")]
    [StringLength(30, ErrorMessage = "Le nom ne doit pas dépasser 30 caractères")]
    public string? NomTypeHebergement { get; set; }

    [ForeignKey(nameof(CategorieId))]
    public virtual Categorie CategorieHebergement { get; set; } = null!;

    [InverseProperty("TypeHebergementAssocie")]
    public virtual ICollection<Annonce> Annonces { get; set; } = new List<Annonce>();
}