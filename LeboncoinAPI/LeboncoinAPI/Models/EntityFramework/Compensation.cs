using LeboncoinAPI.Models.EntityFramework;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("compensation")]
public partial class Compensation
{
    [Key]
    [Column("idcompensation")]
    public int CompensationId { get; set; }

    [Column("nomcompensation")]
    [StringLength(100)]
    public string? NomCompensation { get; set; }

    // Table de liaison Many-to-Many "demander" (Incident <-> Compensation)
    public virtual ICollection<Incident> IncidentsLies { get; set; } = new List<Incident>();
}