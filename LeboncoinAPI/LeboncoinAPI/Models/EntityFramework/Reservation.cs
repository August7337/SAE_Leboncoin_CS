using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("reservation")]
[Index("Idannonce", Name = "idx_reservation_idannonce")]
[Index("Iddatedebutreservation", Name = "idx_reservation_iddatedebutres")]
[Index("Iddatefinreservation", Name = "idx_reservation_iddatefinres")]
[Index("Idutilisateur", Name = "idx_reservation_idutilisateur")]
public partial class Reservation
{
    [Key]
    [Column("idreservation")]
    public int Idreservation { get; set; }

    [Column("idannonce")]
    public int Idannonce { get; set; }

    [Column("iddatedebutreservation")]
    public int Iddatedebutreservation { get; set; }

    [Column("iddatefinreservation")]
    public int Iddatefinreservation { get; set; }

    [Column("idutilisateur")]
    public int Idutilisateur { get; set; }

    [Column("nomclient")]
    [StringLength(50)]
    public string Nomclient { get; set; } = null!;

    [Column("prenomclient")]
    [StringLength(50)]
    public string Prenomclient { get; set; } = null!;

    [Column("telephoneclient")]
    [StringLength(10)]
    public string? Telephoneclient { get; set; }

    [ForeignKey("Idannonce")]
    [InverseProperty("Reservations")]
    public virtual Annonce? IdannonceNavigation { get; set; } = null!;

    [ForeignKey("Iddatedebutreservation")]
    [InverseProperty("ReservationIddatedebutreservationNavigations")]
    public virtual Date? IddatedebutreservationNavigation { get; set; } = null!;

    [ForeignKey("Iddatefinreservation")]
    [InverseProperty("ReservationIddatefinreservationNavigations")]
    public virtual Date? IddatefinreservationNavigation { get; set; } = null!;

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Reservations")]
    public virtual Utilisateur? IdutilisateurNavigation { get; set; } = null!;

    [InverseProperty("IdreservationNavigation")]
    public virtual ICollection<Incident> Incidents { get; set; } = new List<Incident>();

    [InverseProperty("IdreservationNavigation")]
    public virtual ICollection<Inclure> Inclures { get; set; } = new List<Inclure>();

    [InverseProperty("IdreservationNavigation")]
    public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();
}
