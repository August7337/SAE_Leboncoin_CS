using LeboncoinAPI.Models.EntityFramework;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("message")]
public partial class Message
{
    [Key]
    [Column("idmessage")]
    public int MessageId { get; set; }

    [Column("idutilisateurreceveur")]
    public int UtilisateurReceveurId { get; set; }

    [Column("iddate")]
    public int DateId { get; set; }

    [Column("idutilisateurexpediteur")]
    public int UtilisateurExpediteurId { get; set; }

    [Required]
    [Column("contenumessage")]
    [StringLength(1000)]
    public string ContenuMessage { get; set; } = null!;

    // --- Navigation Properties ---

    [ForeignKey(nameof(UtilisateurExpediteurId))]
    public virtual Utilisateur Expediteur { get; set; } = null!;

    [ForeignKey(nameof(UtilisateurReceveurId))]
    public virtual Utilisateur Receveur { get; set; } = null!;
}