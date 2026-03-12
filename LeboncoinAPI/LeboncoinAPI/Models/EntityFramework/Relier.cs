using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[PrimaryKey("Idannonce", "Iddate")]
[Table("relier")]
[Index("Iddate", Name = "idx_relier_iddate")]
public partial class Relier
{
    [Key]
    [Column("idannonce")]
    public int Idannonce { get; set; }

    [Key]
    [Column("iddate")]
    public int Iddate { get; set; }

    [Column("estdisponible")]
    public bool Estdisponible { get; set; }

    [ForeignKey("Idannonce")]
    [InverseProperty("Reliers")]
    public virtual Annonce IdannonceNavigation { get; set; } = null!;

    [ForeignKey("Iddate")]
    [InverseProperty("Reliers")]
    public virtual Date IddateNavigation { get; set; } = null!;
}
