using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("transaction")]
[Index("Idutilisateur", Name = "idx_transaction_idutilisateur")]
[Index("Iddate", Name = "idx_transaction_iddate")]
[Index("Idreservation", Name = "idx_transaction_idreservation")]
public partial class Transaction
{
    [Key]
    [Column("idtransaction")]
    public int Idtransaction { get; set; }

    [Column("iddate")]
    public int Iddate { get; set; }

    [Column("idreservation")]
    public int Idreservation { get; set; }

    [Column("idutilisateur")]
    public int Idutilisateur { get; set; }

    [Column("montanttransaction")]
    [Precision(10, 2)]
    public decimal Montanttransaction { get; set; }

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Transactions")]
    public virtual Utilisateur IdutilisateurNavigation { get; set; } = null!;

    [ForeignKey("Iddate")]
    [InverseProperty("Transactions")]
    public virtual Date IddateNavigation { get; set; } = null!;

    [ForeignKey("Idreservation")]
    [InverseProperty("Transactions")]
    public virtual Reservation IdreservationNavigation { get; set; } = null!;
}
