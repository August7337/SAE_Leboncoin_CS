using LeboncoinAPI.Models.EntityFramework;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("particulier")]
public partial class Particulier
{
    // C'est à la fois une clé primaire et une clé étrangère vers Utilisateur
    [Key]
    [Column("idutilisateur")]
    public int UtilisateurId { get; set; }

    [Required]
    [Column("nomutilisateur")]
    [StringLength(50)]
    public string NomUtilisateur { get; set; } = null!;

    [Required]
    [Column("prenomutilisateur")]
    [StringLength(50)]
    public string PrenomUtilisateur { get; set; } = null!;

    [Required]
    [Column("civilite")]
    [StringLength(15)]
    public string Civilite { get; set; } = null!;

    [Column("iddate")]
    public int DateNaissanceId { get; set; }

    [ForeignKey(nameof(UtilisateurId))]
    public virtual Utilisateur UtilisateurBase { get; set; } = null!;
}