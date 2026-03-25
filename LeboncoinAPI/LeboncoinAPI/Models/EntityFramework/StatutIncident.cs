using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("statut_incident")]
public partial class StatutIncident
{
    [Key]
    [Column("idstatutincident")]
    public int Idstatutincident { get; set; }

    [Column("code")]
    [StringLength(60)]
    public string Code { get; set; } = null!;

    [Column("libelle")]
    [StringLength(120)]
    public string Libelle { get; set; } = null!;

    [Column("ordre")]
    public int Ordre { get; set; }

    [Column("estfinal")]
    public bool Estfinal { get; set; }

    [InverseProperty("StatutIncidentNavigation")]
    public virtual ICollection<Incident> Incidents { get; set; } = new List<Incident>();

    [InverseProperty("IdstatutincidentNavigation")]
    public virtual ICollection<IncidentHistorique> HistoriquesStatut { get; set; } = new List<IncidentHistorique>();
}
