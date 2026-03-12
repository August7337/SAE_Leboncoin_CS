using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("professionnel")]
[Index("Numsiret", Name = "professionnel_numsiret_key", IsUnique = true)]
public partial class Professionnel
{
    [Key]
    [Column("idutilisateur")]
    public int Idutilisateur { get; set; }

    [Column("numsiret")]
    [Precision(14, 0)]
    public decimal Numsiret { get; set; }

    [Column("nomsociete")]
    [StringLength(30)]
    public string Nomsociete { get; set; } = null!;

    [Column("secteuractivite")]
    [StringLength(50)]
    public string Secteuractivite { get; set; } = null!;

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Professionnel")]
    public virtual Utilisateur IdutilisateurNavigation { get; set; } = null!;
}
