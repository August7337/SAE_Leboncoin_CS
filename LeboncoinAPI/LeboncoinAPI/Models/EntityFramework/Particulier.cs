using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("particulier")]
public partial class Particulier
{
    [Key]
    [Column("idutilisateur")]
    public int Idutilisateur { get; set; }

    [Column("nomutilisateur")]
    [StringLength(50)]
    public string Nomutilisateur { get; set; } = null!;

    [Column("prenomutilisateur")]
    [StringLength(50)]
    public string Prenomutilisateur { get; set; } = null!;

    [Column("civilite")]
    [StringLength(15)]
    public string Civilite { get; set; } = null!;

    [Column("iddate")]
    public int Iddate { get; set; }

    [ForeignKey("Iddate")]
    [InverseProperty("Particuliers")]
    public virtual Date IddateNavigation { get; set; } = null!;

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Particulier")]
    public virtual Utilisateur IdutilisateurNavigation { get; set; } = null!;
}
