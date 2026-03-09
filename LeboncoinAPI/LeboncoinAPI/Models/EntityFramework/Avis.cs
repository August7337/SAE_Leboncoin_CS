using LeboncoinAPI.Models.EntityFramework;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("avis")]
public partial class Avis
{
    [Key]
    [Column("idavis")]
    public int AvisId { get; set; }

    [Column("idannonce")]
    public int AnnonceId { get; set; }

    [Column("iddate")]
    public int DateId { get; set; }

    [Column("idutilisateur")]
    public int UtilisateurId { get; set; }

    [Column("texteavis")]
    [StringLength(500)]
    public string? TexteAvis { get; set; }

    [Column("nombreetoiles", TypeName = "decimal(2,1)")]
    [Range(1.0, 5.0)]
    public decimal NombreEtoiles { get; set; }

    // --- Navigation Properties ---

    [ForeignKey(nameof(AnnonceId))]
    [InverseProperty("Avis")]
    public virtual Annonce AnnonceEvaluee { get; set; } = null!;

    [ForeignKey(nameof(UtilisateurId))]
    public virtual Utilisateur AuteurAvis { get; set; } = null!;
}