using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;

namespace LeboncoinAPI.Models.EntityFramework;

public partial class LeboncoinDBContext : DbContext
{
    public LeboncoinDBContext(DbContextOptions<LeboncoinDBContext> options)
        : base(options)
    { }

    public LeboncoinDBContext() { }

    // --- Déclaration des DbSets ---
    public virtual DbSet<Utilisateur> Utilisateurs { get; set; } = null!;
    public virtual DbSet<Annonce> Annonces { get; set; } = null!;
    public virtual DbSet<Reservation> Reservations { get; set; } = null!;
    public virtual DbSet<Avis> Avis { get; set; } = null!;
    public virtual DbSet<Incident> Incidents { get; set; } = null!;
    public virtual DbSet<Message> Messages { get; set; } = null!;
    public virtual DbSet<Adresse> Adresses { get; set; } = null!;
    public virtual DbSet<Ville> Villes { get; set; } = null!;
    public virtual DbSet<Particulier> Particuliers { get; set; } = null!;
    public virtual DbSet<Professionnel> Professionnels { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("public");

        // --- Configuration Utilisateur ---
        modelBuilder.Entity<Utilisateur>(entity =>
        {
            entity.HasKey(e => e.UtilisateurId).HasName("pk_utilisateur");
            entity.HasIndex(e => e.Email).IsUnique().HasDatabaseName("uq_utilisateur_email");
            entity.HasIndex(e => e.TelephoneUtilisateur).IsUnique().HasDatabaseName("uq_utilisateur_telephone");

            entity.Property(e => e.Solde).HasDefaultValue(0m);
            entity.Property(e => e.PhoneVerified).HasDefaultValue(false);
            entity.Property(e => e.IdentityVerified).HasDefaultValue(false);
        });

        // --- Configuration Annonce ---
        modelBuilder.Entity<Annonce>(entity =>
        {
            entity.HasKey(e => e.AnnonceId).HasName("pk_annonce");
            entity.Property(e => e.EstVerifie).HasDefaultValue(false);
            entity.Property(e => e.SmsVerifie).HasDefaultValue(false);

            // 1. Table de liaison M:N "favoriser" (Utilisateur <-> Annonce)
            entity.HasMany(a => a.UtilisateursFavoris)
                .WithMany(u => u.AnnoncesFavorites)
                .UsingEntity<Dictionary<string, object>>(
                    "favoriser",
                    j => j.HasOne<Utilisateur>().WithMany().HasForeignKey("idutilisateur").HasConstraintName("fk_favorise_favoriser_utilisateur"),
                    j => j.HasOne<Annonce>().WithMany().HasForeignKey("idannonce").HasConstraintName("fk_favorise_favoriser_annonce"),
                    j => { j.HasKey("idutilisateur", "idannonce").HasName("pk_favoriser"); }
                );
        });

        // --- Configuration Incident ---
        modelBuilder.Entity<Incident>(entity =>
        {
            entity.HasKey(e => e.IncidentId).HasName("pk_incident");
            entity.Property(e => e.Etape).HasDefaultValue(1);
            entity.Property(e => e.EstClasse).HasDefaultValue(false);
            entity.Property(e => e.EstRembourse).HasDefaultValue(false);
            entity.Property(e => e.EstRemisAuContentieux).HasDefaultValue(false);
        });

        // --- Configuration Professionnel & Particulier (Héritage / 1:1) ---
        modelBuilder.Entity<Professionnel>(entity =>
        {
            entity.HasIndex(e => e.NumSiret).IsUnique();
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}