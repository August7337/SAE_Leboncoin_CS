using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("categorie")]
public partial class Categorie
{
    [Key]
    [Column("idcategorie")]
    public int CategorieId { get; set; }

    [Column("nomcategorie")]
    [StringLength(24)]
    public string? NomCategorie { get; set; }

    [InverseProperty("CategorieHebergement")]
    public virtual ICollection<TypeHebergement> TypesHebergements { get; set; } = new List<TypeHebergement>();

    [InverseProperty("CategorieCommodite")]
    public virtual ICollection<Commodite> Commodites { get; set; } = new List<Commodite>();
}