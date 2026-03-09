using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

// Remarque : J'ai renommé la classe "DateReference" au lieu de "Date" 
// pour éviter le conflit avec le type System.Date/DateTime de C#.
[Table("date")]
public partial class DateReference
{
    [Key]
    [Column("iddate")]
    public int DateId { get; set; }

    [Column("date", TypeName = "date")]
    public DateTime? DateValeur { get; set; }
}