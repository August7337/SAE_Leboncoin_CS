using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("compensation")]
public partial class Compensation
{
    [Key]
    [Column("idcompensation")]
    public int Idcompensation { get; set; }

    [Column("nomcompensation")]
    [StringLength(100)]
    public string? Nomcompensation { get; set; }

    [ForeignKey("Idcompensation")]
    [InverseProperty("Idcompensations")]
    public virtual ICollection<Incident> Idincidents { get; set; } = new List<Incident>();
}
