using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("transaction")]
[Index("Idcartebancaire", Name = "idx_transaction_idcartebancaire")]
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

    [Column("idcartebancaire")]
    public int Idcartebancaire { get; set; }

    [Column("montanttransaction")]
    [Precision(10, 2)]
    public decimal Montanttransaction { get; set; }

    [ForeignKey("Idcartebancaire")]
    [InverseProperty("Transactions")]
    public virtual Cartebancaire IdcartebancaireNavigation { get; set; } = null!;

    [ForeignKey("Iddate")]
    [InverseProperty("Transactions")]
    public virtual Date IddateNavigation { get; set; } = null!;

    [ForeignKey("Idreservation")]
    [InverseProperty("Transactions")]
    public virtual Reservation IdreservationNavigation { get; set; } = null!;
}
