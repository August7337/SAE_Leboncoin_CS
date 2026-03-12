using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("cartebancaire")]
public partial class Cartebancaire
{
    [Key]
    [Column("idcartebancaire")]
    public int Idcartebancaire { get; set; }

    [Column("idutilisateur")]
    public int Idutilisateur { get; set; }

    [Column("nomtitulaire")]
    [StringLength(50)]
    public string? Nomtitulaire { get; set; }

    [Column("prenomtitulaire")]
    [StringLength(50)]
    public string? Prenomtitulaire { get; set; }

    [Column("numerocartebancaire")]
    [Precision(16, 0)]
    public decimal? Numerocartebancaire { get; set; }

    [Column("dateexpiration")]
    public DateOnly? Dateexpiration { get; set; }

    [Column("numerocvv")]
    [Precision(3, 0)]
    public decimal? Numerocvv { get; set; }

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Cartebancaires")]
    public virtual Utilisateur IdutilisateurNavigation { get; set; } = null!;

    [InverseProperty("IdcartebancaireNavigation")]
    public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();

    [InverseProperty("IdcartebancaireNavigation")]
    public virtual ICollection<Utilisateur> Utilisateurs { get; set; } = new List<Utilisateur>();
}
