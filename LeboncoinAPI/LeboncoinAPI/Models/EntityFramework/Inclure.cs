using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[PrimaryKey("Idreservation", "Idtypevoyageur")]
[Table("inclure")]
[Index("Idtypevoyageur", Name = "idx_inclure_idtypevoyageur")]
public partial class Inclure
{
    [Key]
    [Column("idreservation")]
    public int Idreservation { get; set; }

    [Key]
    [Column("idtypevoyageur")]
    public int Idtypevoyageur { get; set; }

    [Column("nombrevoyageur")]
    public int Nombrevoyageur { get; set; }

    [ForeignKey("Idreservation")]
    [InverseProperty("Inclures")]
    public virtual Reservation IdreservationNavigation { get; set; } = null!;

    [ForeignKey("Idtypevoyageur")]
    [InverseProperty("Inclures")]
    public virtual Typevoyageur IdtypevoyageurNavigation { get; set; } = null!;
}
