using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("utilisateur")]
public partial class Utilisateur
{
    [Key]
    [Column("idutilisateur")]
    public int UtilisateurId { get; set; }

    [Column("idadresse")]
    public int AdresseId { get; set; }

    [Column("iddate")]
    public int DateId { get; set; }

    [Required]
    [Column("pseudonyme")]
    [StringLength(50, MinimumLength = 2, ErrorMessage = "Le pseudonyme doit faire entre 2 et 50 caractères.")]
    public string Pseudonyme { get; set; } = null!;

    [Required]
    [Column("email")]
    [EmailAddress(ErrorMessage = "Le format de l'adresse email est invalide.")]
    [StringLength(320)]
    public string Email { get; set; } = null!;

    [Column("email_verified_at")]
    public DateTime? EmailVerifiedAt { get; set; }

    [Required]
    [Column("password")]
    [StringLength(255)]
    [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{12,}$",
        ErrorMessage = "Le mot de passe doit contenir au moins 12 caractères, une majuscule, une minuscule, un chiffre et un caractère spécial.")]
    public string Password { get; set; } = null!;

    [Required]
    [Column("telephoneutilisateur", TypeName = "char(10)")]
    [RegularExpression(@"^0[1-9][0-9]{8}$", ErrorMessage = "Le numéro de téléphone doit contenir 10 chiffres et commencer par 0.")]
    public string TelephoneUtilisateur { get; set; } = null!;

    [Column("phone_verified")]
    public bool PhoneVerified { get; set; }

    [Column("identity_verified")]
    public bool IdentityVerified { get; set; }

    [Column("solde", TypeName = "decimal(10,2)")]
    [Range(0, double.MaxValue, ErrorMessage = "Le solde ne peut pas être négatif.")]
    public decimal Solde { get; set; }

    [Column("remember_token")]
    [StringLength(100,ErrorMessage = "Le remember token ne peut pas dépasser 100 caractères")]
    public string? RememberToken { get; set; }

    [Column("two_factor_secret", TypeName = "text")]
    public string? TwoFactorSecret { get; set; }

    [Column("two_factor_recovery_codes", TypeName = "text")]
    public string? TwoFactorRecoveryCodes { get; set; }

    [Column("two_factor_confirmed_at")]
    public DateTime? TwoFactorConfirmedAt { get; set; }

    [Column("profile_photo_path")]
    [StringLength(2048)]
    public string? ProfilePhotoPath { get; set; }

    // --- Navigation Properties ---

    [ForeignKey(nameof(AdresseId))]
    public virtual Adresse AdresseUtilisateur { get; set; } = null!;


    [ForeignKey(nameof(DateId))]
    public virtual DateReference DateInscription { get; set; } = null!;

    // 1 to 1 relationships (Particulier / Professionnel)
    [InverseProperty("UtilisateurBase")]
    public virtual Particulier? ProfilParticulier { get; set; }

    [InverseProperty("UtilisateurBase")]
    public virtual Professionnel? ProfilProfessionnel { get; set; }

    [InverseProperty("UtilisateurAuteur")]
    public virtual ICollection<Annonce> AnnoncesPubliees { get; set; } = new List<Annonce>();

    [InverseProperty("Client")]
    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

    // Table de liaison "favoriser"
    public virtual ICollection<Annonce> AnnoncesFavorites { get; set; } = new List<Annonce>();
}