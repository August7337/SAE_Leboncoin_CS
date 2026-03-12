using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("message")]
[Index("Idutilisateurexpediteur", Name = "idx_message_idutilisateurexpediteur")]
[Index("Idutilisateurreceveur", Name = "idx_message_idutilisateurreceveur")]
public partial class Message
{
    [Key]
    [Column("idmessage")]
    public int Idmessage { get; set; }

    [Column("idutilisateurreceveur")]
    public int Idutilisateurreceveur { get; set; }

    [Column("iddate")]
    public int Iddate { get; set; }

    [Column("idutilisateurexpediteur")]
    public int Idutilisateurexpediteur { get; set; }

    [Column("contenumessage")]
    [StringLength(1000)]
    public string Contenumessage { get; set; } = null!;

    [ForeignKey("Iddate")]
    [InverseProperty("Messages")]
    public virtual Date IddateNavigation { get; set; } = null!;

    [ForeignKey("Idutilisateurexpediteur")]
    [InverseProperty("MessageIdutilisateurexpediteurNavigations")]
    public virtual Utilisateur IdutilisateurexpediteurNavigation { get; set; } = null!;

    [ForeignKey("Idutilisateurreceveur")]
    [InverseProperty("MessageIdutilisateurreceveurNavigations")]
    public virtual Utilisateur IdutilisateurreceveurNavigation { get; set; } = null!;
}
