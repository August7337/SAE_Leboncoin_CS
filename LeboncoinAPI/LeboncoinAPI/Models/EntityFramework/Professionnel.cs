using LeboncoinAPI.Models.EntityFramework;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("professionnel")]
public partial class Professionnel
{
    [Key]
    [Column("idutilisateur")]
    public int UtilisateurId { get; set; }

    [Column("numsiret", TypeName = "numeric(14)")]
    public decimal NumSiret { get; set; }

    [Required]
    [Column("nomsociete")]
    [StringLength(30, ErrorMessage = "Le nom ne doit pas dépasser 30 caractères")]
    public string NomSociete { get; set; } = null!;

    [Required]
    [Column("secteuractivite")]
    [StringLength(50, ErrorMessage = "Le secteur ne doit pas dépasser 50 caractères")]
    public string SecteurActivite { get; set; } = null!;

    [ForeignKey(nameof(UtilisateurId))]
    public virtual Utilisateur UtilisateurBase { get; set; } = null!;
}