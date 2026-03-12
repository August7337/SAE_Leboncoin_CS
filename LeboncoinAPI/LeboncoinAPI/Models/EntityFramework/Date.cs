using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("date")]
[Index("Date1", Name = "idx_date_date")]
public partial class Date
{
    [Key]
    [Column("iddate")]
    public int Iddate { get; set; }

    [Column("date")]
    public DateOnly? Date1 { get; set; }

    [InverseProperty("IddateNavigation")]
    public virtual ICollection<Annonce> Annonces { get; set; } = new List<Annonce>();

    [InverseProperty("IddateNavigation")]
    public virtual ICollection<Avi> Avis { get; set; } = new List<Avi>();

    [InverseProperty("IddateNavigation")]
    public virtual ICollection<Incident> Incidents { get; set; } = new List<Incident>();

    [InverseProperty("IddateNavigation")]
    public virtual ICollection<Message> Messages { get; set; } = new List<Message>();

    [InverseProperty("IddateNavigation")]
    public virtual ICollection<Particulier> Particuliers { get; set; } = new List<Particulier>();

    [InverseProperty("IddatedebutrechercheNavigation")]
    public virtual ICollection<Recherche> RechercheIddatedebutrechercheNavigations { get; set; } = new List<Recherche>();

    [InverseProperty("IddatefinrechercheNavigation")]
    public virtual ICollection<Recherche> RechercheIddatefinrechercheNavigations { get; set; } = new List<Recherche>();

    [InverseProperty("IddateNavigation")]
    public virtual ICollection<Relier> Reliers { get; set; } = new List<Relier>();

    [InverseProperty("IddatedebutreservationNavigation")]
    public virtual ICollection<Reservation> ReservationIddatedebutreservationNavigations { get; set; } = new List<Reservation>();

    [InverseProperty("IddatefinreservationNavigation")]
    public virtual ICollection<Reservation> ReservationIddatefinreservationNavigations { get; set; } = new List<Reservation>();

    [InverseProperty("IddateNavigation")]
    public virtual ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();

    [InverseProperty("IddateNavigation")]
    public virtual ICollection<Utilisateur> Utilisateurs { get; set; } = new List<Utilisateur>();
}
