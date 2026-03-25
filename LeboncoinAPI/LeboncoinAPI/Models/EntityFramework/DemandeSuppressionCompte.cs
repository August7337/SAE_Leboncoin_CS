using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("demandesuppressioncompte")]
public partial class DemandeSuppressionCompte
{
    [Key]
    [Column("iddemande")]
    public int IdDemande { get; set; }

    [Column("idutilisateur")]
    public int IdUtilisateur { get; set; }

    [Column("idstatut")]
    public int IdStatut { get; set; } = 1;

    [Column("datedemande", TypeName = "timestamp without time zone")]
    public DateTime DateDemande { get; set; }

    [Column("motifrefus")]
    [StringLength(500)]
    public string? MotifRefus { get; set; }

    [ForeignKey("IdUtilisateur")]
    public virtual Utilisateur? UtilisateurNavigation { get; set; }

    [ForeignKey("IdStatut")]
    [InverseProperty("Demandes")]
    public virtual StatutDemande? StatutNavigation { get; set; }
}