using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("heure")]
public partial class Heure
{
    [Key]
    [Column("idheure")]
    public int HeureId { get; set; }

    [Required]
    [Column("heure", TypeName = "time")]
    public TimeSpan HeureValeur { get; set; }
}