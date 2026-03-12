using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("avis")]
public partial class Avi
{
    [Key]
    [Column("idavis")]
    public int Idavis { get; set; }

    [Column("idannonce")]
    public int Idannonce { get; set; }

    [Column("iddate")]
    public int Iddate { get; set; }

    [Column("idutilisateur")]
    public int Idutilisateur { get; set; }

    [Column("texteavis")]
    [StringLength(500)]
    public string? Texteavis { get; set; }

    [Column("nombreetoiles")]
    [Precision(2, 1)]
    public decimal Nombreetoiles { get; set; }

    [ForeignKey("Idannonce")]
    [InverseProperty("Avis")]
    public virtual Annonce IdannonceNavigation { get; set; } = null!;

    [ForeignKey("Iddate")]
    [InverseProperty("Avis")]
    public virtual Date IddateNavigation { get; set; } = null!;

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Avis")]
    public virtual Utilisateur IdutilisateurNavigation { get; set; } = null!;
}
