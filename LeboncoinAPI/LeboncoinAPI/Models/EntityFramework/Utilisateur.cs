using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("utilisateur")]
[Index("Idadresse", Name = "idx_utilisateur_idadresse")]
[Index("Idcartebancaire", Name = "idx_utilisateur_idcartebancaire")]
[Index("Iddate", Name = "idx_utilisateur_iddate")]
[Index("Email", Name = "utilisateur_email_key", IsUnique = true)]
[Index("Telephoneutilisateur", Name = "utilisateur_telephoneutilisateur_key", IsUnique = true)]
public partial class Utilisateur
{
    [Key]
    [Column("idutilisateur")]
    public int Idutilisateur { get; set; }

    [Column("idadresse")]
    public int Idadresse { get; set; }

    [Column("idcartebancaire")]
    public int? Idcartebancaire { get; set; }

    [Column("iddate")]
    public int Iddate { get; set; }

    [Column("pseudonyme")]
    [StringLength(50)]
    public string Pseudonyme { get; set; } = null!;

    [Column("email")]
    [StringLength(320)]
    public string Email { get; set; } = null!;

    [Column("email_verified_at", TypeName = "timestamp without time zone")]
    public DateTime? EmailVerifiedAt { get; set; }

    [Column("password")]
    [StringLength(255)]
    public string Password { get; set; } = null!;

    [Column("telephoneutilisateur")]
    [StringLength(10)]
    public string Telephoneutilisateur { get; set; } = null!;

    [Column("phone_verified")]
    public bool PhoneVerified { get; set; }

    [Column("identity_verified")]
    public bool IdentityVerified { get; set; }

    [Column("solde")]
    [Precision(10, 2)]
    public decimal Solde { get; set; }

    [Column("remember_token")]
    [StringLength(100)]
    public string? RememberToken { get; set; }

    [Column("two_factor_secret")]
    public string? TwoFactorSecret { get; set; }

    [Column("two_factor_recovery_codes")]
    public string? TwoFactorRecoveryCodes { get; set; }

    [Column("two_factor_confirmed_at", TypeName = "timestamp without time zone")]
    public DateTime? TwoFactorConfirmedAt { get; set; }

    [Column("profile_photo_path")]
    [StringLength(2048)]
    public string? ProfilePhotoPath { get; set; }

    [InverseProperty("IdutilisateurNavigation")]
    public virtual ICollection<Annonce> Annonces { get; set; } = new List<Annonce>();

    [InverseProperty("IdutilisateurNavigation")]
    public virtual ICollection<Avi> Avis { get; set; } = new List<Avi>();

    [InverseProperty("IdutilisateurNavigation")]
    public virtual ICollection<Cartebancaire> Cartebancaires { get; set; } = new List<Cartebancaire>();

    [ForeignKey("Idadresse")]
    [InverseProperty("Utilisateurs")]
    public virtual Adresse IdadresseNavigation { get; set; } = null!;

    [ForeignKey("Idcartebancaire")]
    [InverseProperty("Utilisateurs")]
    public virtual Cartebancaire? IdcartebancaireNavigation { get; set; }

    [ForeignKey("Iddate")]
    [InverseProperty("Utilisateurs")]
    public virtual Date IddateNavigation { get; set; } = null!;

    [InverseProperty("IdutilisateurNavigation")]
    public virtual ICollection<Incident> Incidents { get; set; } = new List<Incident>();

    [InverseProperty("IdutilisateurexpediteurNavigation")]
    public virtual ICollection<Message> MessageIdutilisateurexpediteurNavigations { get; set; } = new List<Message>();

    [InverseProperty("IdutilisateurreceveurNavigation")]
    public virtual ICollection<Message> MessageIdutilisateurreceveurNavigations { get; set; } = new List<Message>();

    [InverseProperty("IdutilisateurNavigation")]
    public virtual Particulier? Particulier { get; set; }

    [InverseProperty("IdutilisateurNavigation")]
    public virtual Professionnel? Professionnel { get; set; }

    [InverseProperty("IdutilisateurNavigation")]
    public virtual ICollection<Recherche> Recherches { get; set; } = new List<Recherche>();

    [InverseProperty("IdutilisateurNavigation")]
    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Idutilisateurs")]
    public virtual ICollection<Annonce> Idannonces { get; set; } = new List<Annonce>();

    [ForeignKey("Idutilisateur")]
    [InverseProperty("Idutilisateurs")]
    public virtual ICollection<Role> Idroles { get; set; } = new List<Role>();
}
