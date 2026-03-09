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
    [StringLength(50, ErrorMessage = "Le nom ne doit pas dépasser 50 caractères")]
    public string NomUtilisateur { get; set; } = null!;

    [Required]
    [Column("prenomutilisateur")]
    [StringLength(50, ErrorMessage = "Le prenom ne doit pas dépasser 50 caractères")]
    public string PrenomUtilisateur { get; set; } = null!;

    [Required]
    [Column("civilite")]
    [StringLength(15, ErrorMessage ="Le message ne doit pas dépasser 15 caractères")]
    public string Civilite { get; set; } = null!;

    [Column("iddate")]
    public int DateNaissanceId { get; set; }

    [ForeignKey(nameof(UtilisateurId))]
    public virtual Utilisateur UtilisateurBase { get; set; } = null!;
}