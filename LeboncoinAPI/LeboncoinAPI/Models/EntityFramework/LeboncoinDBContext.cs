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

    // --- Déclaration de tous les DbSets (Représentation des tables) ---
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
    public virtual DbSet<Region> Regions { get; set; } = null!;
    public virtual DbSet<Departement> Departements { get; set; } = null!;
    public virtual DbSet<Categorie> Categories { get; set; } = null!;
    public virtual DbSet<TypeHebergement> TypesHebergements { get; set; } = null!;
    public virtual DbSet<Commodite> Commodites { get; set; } = null!;
    public virtual DbSet<DateReference> DatesReferences { get; set; } = null!;
    public virtual DbSet<Heure> Heures { get; set; } = null!;
    public virtual DbSet<TypeVoyageur> TypesVoyageurs { get; set; } = null!;
    public virtual DbSet<Compensation> Compensations { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("public");

        // --- Configuration Utilisateur ---
        modelBuilder.Entity<Utilisateur>(entity =>
        {
            entity.HasKey(e => e.UtilisateurId).HasName("pk_utilisateur");

            // Contraintes d'unicité
            entity.HasIndex(e => e.Email).IsUnique().HasDatabaseName("uq_utilisateur_email");
            entity.HasIndex(e => e.TelephoneUtilisateur).IsUnique().HasDatabaseName("uq_utilisateur_telephone");

            // Valeurs par défaut du SQL
            entity.Property(e => e.Solde).HasDefaultValue(0m);
            entity.Property(e => e.PhoneVerified).HasDefaultValue(false);
            entity.Property(e => e.IdentityVerified).HasDefaultValue(false);
        });

        // --- Configuration Annonce ---
        modelBuilder.Entity<Annonce>(entity =>
        {
            entity.HasKey(e => e.AnnonceId).HasName("pk_annonce");

            // Valeurs par défaut
            entity.Property(e => e.EstVerifie).HasDefaultValue(false);
            entity.Property(e => e.SmsVerifie).HasDefaultValue(false);

            // Relation Many-to-Many 1 : "favoriser" (Utilisateur <-> Annonce)
            entity.HasMany(a => a.UtilisateursFavoris)
                .WithMany(u => u.AnnoncesFavorites)
                .UsingEntity<Dictionary<string, object>>(
                    "favoriser",
                    j => j.HasOne<Utilisateur>().WithMany().HasForeignKey("idutilisateur").HasConstraintName("fk_favorise_favoriser_utilisateur"),
                    j => j.HasOne<Annonce>().WithMany().HasForeignKey("idannonce").HasConstraintName("fk_favorise_favoriser_annonce"),
                    j => { j.HasKey("idutilisateur", "idannonce").HasName("pk_favoriser"); }
                );

            // Relation Many-to-Many 2 : "proposer" (Commodite <-> Annonce)
            entity.HasMany(a => a.CommoditesProposees)
                .WithMany(c => c.AnnoncesQuiProposent)
                .UsingEntity<Dictionary<string, object>>(
                    "proposer",
                    j => j.HasOne<Commodite>().WithMany().HasForeignKey("idcommodite").HasConstraintName("fk_proposer_proposer_commodit"),
                    j => j.HasOne<Annonce>().WithMany().HasForeignKey("idannonce").HasConstraintName("fk_proposer_proposer2_annonce"),
                    j => { j.HasKey("idcommodite", "idannonce").HasName("pk_proposer"); }
                );
        });

        // --- Configuration Incident ---
        modelBuilder.Entity<Incident>(entity =>
        {
            entity.HasKey(e => e.IncidentId).HasName("pk_incident");

            // Valeurs par défaut
            entity.Property(e => e.Etape).HasDefaultValue(1);
            entity.Property(e => e.EstClasse).HasDefaultValue(false);
            entity.Property(e => e.EstRembourse).HasDefaultValue(false);
            entity.Property(e => e.EstRemisAuContentieux).HasDefaultValue(false);

            // Relation Many-to-Many 3 : "demander" (Incident <-> Compensation)
            entity.HasMany(i => i.CompensationsDemandees)
                .WithMany(c => c.IncidentsLies)
                .UsingEntity<Dictionary<string, object>>(
                    "demander",
                    j => j.HasOne<Compensation>().WithMany().HasForeignKey("idcompensation").HasConstraintName("fk_demander_compensation"),
                    j => j.HasOne<Incident>().WithMany().HasForeignKey("idincident").HasConstraintName("fk_demander_incident"),
                    j => { j.HasKey("idincident", "idcompensation").HasName("pk_demander"); }
                );
        });

        // --- Configuration Héritage (Particulier / Professionnel) ---
        // Le script SQL original traite cela avec des tables séparées ayant la même clé primaire que Utilisateur
        modelBuilder.Entity<Professionnel>(entity =>
        {
            // Contrainte d'unicité sur le SIRET
            entity.HasIndex(e => e.NumSiret).IsUnique();
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}