using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("statutdemande")]
public partial class StatutDemande
{
    [Key]
    [Column("idstatut")]
    public int IdStatut { get; set; }

    [Column("nomstatut")]
    [StringLength(50)]
    public string NomStatut { get; set; } = null!;

    [InverseProperty("StatutNavigation")]
    public virtual ICollection<DemandeSuppressionCompte> Demandes { get; set; } = new List<DemandeSuppressionCompte>();
}