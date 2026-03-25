using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

public partial class LeboncoinDBContext : DbContext
{
    public LeboncoinDBContext()
    {
    }

    public LeboncoinDBContext(DbContextOptions<LeboncoinDBContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Adresse> Adresses { get; set; }

    public virtual DbSet<Annonce> Annonces { get; set; }

    public virtual DbSet<Avi> Avis { get; set; }

    public virtual DbSet<Categorie> Categories { get; set; }

    public virtual DbSet<Commodite> Commodites { get; set; }

    public virtual DbSet<Compensation> Compensations { get; set; }

    public virtual DbSet<Date> Dates { get; set; }

    public virtual DbSet<DemandeSuppressionCompte> DemandesSuppressionCompte { get; set; }

    public virtual DbSet<Departement> Departements { get; set; }

    public virtual DbSet<Heure> Heures { get; set; }

    public virtual DbSet<Incident> Incidents { get; set; }

    public virtual DbSet<Inclure> Inclures { get; set; }

    public virtual DbSet<Message> Messages { get; set; }

    public virtual DbSet<Particulier> Particuliers { get; set; }

    public virtual DbSet<Permission> Permissions { get; set; }

    public virtual DbSet<Photo> Photos { get; set; }

    public virtual DbSet<Professionnel> Professionnels { get; set; }

    public virtual DbSet<Recherche> Recherches { get; set; }

    public virtual DbSet<Region> Regions { get; set; }

    public virtual DbSet<Relier> Reliers { get; set; }

    public virtual DbSet<Reservation> Reservations { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Transaction> Transactions { get; set; }

    public virtual DbSet<Typehebergement> Typehebergements { get; set; }

    public virtual DbSet<Typevoyageur> Typevoyageurs { get; set; }

    public virtual DbSet<Utilisateur> Utilisateurs { get; set; }

    public virtual DbSet<Ville> Villes { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Adresse>(entity =>
        {
            entity.HasKey(e => e.Idadresse).HasName("pk_adresse");

            entity.HasOne(d => d.IdvilleNavigation).WithMany(p => p.Adresses)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_adresse_posseder_ville");
        });

        modelBuilder.Entity<Annonce>(entity =>
        {
            entity.HasKey(e => e.Idannonce).HasName("pk_annonce");

            entity.Property(e => e.Estverifie).HasDefaultValue(false);
            entity.Property(e => e.Smsverifie).HasDefaultValue(false);

            entity.HasOne(d => d.IdadresseNavigation).WithMany(p => p.Annonces)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_annonce_se_trouve_adresse");

            entity.HasOne(d => d.IddateNavigation).WithMany(p => p.Annonces)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_annonce_publier_date");

            entity.HasOne(d => d.IdheurearriveeNavigation).WithMany(p => p.AnnonceIdheurearriveeNavigations)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_annonce_arriver_heure");

            entity.HasOne(d => d.IdheuredepartNavigation).WithMany(p => p.AnnonceIdheuredepartNavigations)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_annonce_partir_heure");

            entity.HasOne(d => d.IdtypehebergementNavigation).WithMany(p => p.Annonces)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_annonce_qualifier_typehebe");

            entity.HasOne(d => d.IdutilisateurNavigation).WithMany(p => p.Annonces)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_annonce_diffuser_utilisateur");

            entity.HasMany(d => d.IdannonceAs).WithMany(p => p.IdannonceBs)
                .UsingEntity<Dictionary<string, object>>(
                    "Ressembler",
                    r => r.HasOne<Annonce>().WithMany()
                        .HasForeignKey("IdannonceA")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_ressembler_idannonce_a"),
                    l => l.HasOne<Annonce>().WithMany()
                        .HasForeignKey("IdannonceB")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_ressembler_idannonce_b"),
                    j =>
                    {
                        j.HasKey("IdannonceA", "IdannonceB").HasName("pk_ressembler");
                        j.ToTable("ressembler");
                        j.HasIndex(new[] { "IdannonceB" }, "idx_ressembler_idannonce_b");
                        j.IndexerProperty<int>("IdannonceA").HasColumnName("IdannonceA");
                        j.IndexerProperty<int>("IdannonceB").HasColumnName("IdannonceB");
                    });

            entity.HasMany(d => d.IdannonceBs).WithMany(p => p.IdannonceAs)
                .UsingEntity<Dictionary<string, object>>(
                    "Ressembler",
                    r => r.HasOne<Annonce>().WithMany()
                        .HasForeignKey("IdannonceB")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_ressembler_idannonce_b"),
                    l => l.HasOne<Annonce>().WithMany()
                        .HasForeignKey("IdannonceA")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_ressembler_idannonce_a"),
                    j =>
                    {
                        j.HasKey("IdannonceA", "IdannonceB").HasName("pk_ressembler");
                        j.ToTable("ressembler");
                        j.HasIndex(new[] { "IdannonceB" }, "idx_ressembler_idannonce_b");
                        j.IndexerProperty<int>("IdannonceA").HasColumnName("idannonce_a");
                        j.IndexerProperty<int>("IdannonceB").HasColumnName("idannonce_b");
                    });
        });

        modelBuilder.Entity<Avi>(entity =>
        {
            entity.HasKey(e => e.Idavis).HasName("pk_avis");

            entity.HasOne(d => d.IdannonceNavigation).WithMany(p => p.Avis)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_avis_noter_annonce");

            entity.HasOne(d => d.IddateNavigation).WithMany(p => p.Avis)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_avis_deposer_date");

            entity.HasOne(d => d.IdutilisateurNavigation).WithMany(p => p.Avis)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_avis_commenter_utilisateur");
        });

        modelBuilder.Entity<Categorie>(entity =>
        {
            entity.HasKey(e => e.Idcategorie).HasName("pk_categorie");
        });

        modelBuilder.Entity<Commodite>(entity =>
        {
            entity.HasKey(e => e.Idcommodite).HasName("pk_commodite");

            entity.HasOne(d => d.IdcategorieNavigation).WithMany(p => p.Commodites)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_commodit_apparteni_categori");

            entity.HasMany(d => d.Idannonces).WithMany(p => p.Idcommodites)
                .UsingEntity<Dictionary<string, object>>(
                    "AnnonceCommodite",
                    r => r.HasOne<Annonce>().WithMany()
                        .HasForeignKey("Idannonce")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_proposer_proposer2_annonce"),
                    l => l.HasOne<Commodite>().WithMany()
                        .HasForeignKey("Idcommodite")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_proposer_proposer_commodit"),
                    j =>
                    {
                        j.HasKey("Idcommodite", "Idannonce").HasName("pk_proposer");
                        j.ToTable("AnnonceCommodite");
                        j.HasIndex(new[] { "Idannonce" }, "idx_proposer_idannonce");
                        j.HasIndex(new[] { "Idcommodite" }, "idx_proposer_idcommodite");
                        j.IndexerProperty<int>("Idcommodite").HasColumnName("Idcommodite");
                        j.IndexerProperty<int>("Idannonce").HasColumnName("Idannonce");
                    });
        });

        modelBuilder.Entity<Compensation>(entity =>
        {
            entity.HasKey(e => e.Idcompensation).HasName("pk_compensation");
        });

        modelBuilder.Entity<Date>(entity =>
        {
            entity.HasKey(e => e.Iddate).HasName("pk_date");
        });

        modelBuilder.Entity<Departement>(entity =>
        {
            entity.HasKey(e => e.Iddepartement).HasName("pk_departement");

            entity.HasOne(d => d.IdregionNavigation).WithMany(p => p.Departements)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_departem_localiser_region");
        });

        modelBuilder.Entity<Heure>(entity =>
        {
            entity.HasKey(e => e.Idheure).HasName("pk_heure");
        });

        modelBuilder.Entity<Incident>(entity =>
        {
            entity.HasKey(e => e.Idincident).HasName("pk_incident");

            entity.Property(e => e.Estclasse).HasDefaultValue(false);
            entity.Property(e => e.Estrembourse).HasDefaultValue(false);
            entity.Property(e => e.Estremisaucontentieux).HasDefaultValue(false);
            entity.Property(e => e.Etape).HasDefaultValue(1);

            entity.HasOne(d => d.IddateNavigation).WithMany(p => p.Incidents)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_incident_associati_date");

            entity.HasOne(d => d.IdreservationNavigation).WithMany(p => p.Incidents)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_incident_associati_reservat");

            entity.HasOne(d => d.IdutilisateurNavigation).WithMany(p => p.Incidents)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_incident_associati_utilisat");

            entity.HasMany(d => d.Idcompensations).WithMany(p => p.Idincidents)
                .UsingEntity<Dictionary<string, object>>(
                    "Demander",
                    r => r.HasOne<Compensation>().WithMany()
                        .HasForeignKey("Idcompensation")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_demander_compensation"),
                    l => l.HasOne<Incident>().WithMany()
                        .HasForeignKey("Idincident")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_demander_incident"),
                    j =>
                    {
                        j.HasKey("Idincident", "Idcompensation").HasName("pk_demander");
                        j.ToTable("demander");
                        j.HasIndex(new[] { "Idcompensation" }, "idx_demander_idcompensation");
                        j.IndexerProperty<int>("Idincident").HasColumnName("idincident");
                        j.IndexerProperty<int>("Idcompensation").HasColumnName("idcompensation");
                    });
        });

        modelBuilder.Entity<Inclure>(entity =>
        {
            entity.HasKey(e => new { e.Idreservation, e.Idtypevoyageur }).HasName("pk_inclure");

            entity.Property(e => e.Nombrevoyageur).HasDefaultValue(0);

            entity.HasOne(d => d.IdreservationNavigation).WithMany(p => p.Inclures)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_inclure_inclure_reservat");

            entity.HasOne(d => d.IdtypevoyageurNavigation).WithMany(p => p.Inclures)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_inclure_inclure2_typevoya");
        });

        modelBuilder.Entity<Message>(entity =>
        {
            entity.HasKey(e => e.Idmessage).HasName("pk_message");

            entity.HasOne(d => d.IddateNavigation).WithMany(p => p.Messages)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_message_associati_date");

            entity.HasOne(d => d.IdutilisateurexpediteurNavigation).WithMany(p => p.MessageIdutilisateurexpediteurNavigations)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_message_expedier_utilisat");

            entity.HasOne(d => d.IdutilisateurreceveurNavigation).WithMany(p => p.MessageIdutilisateurreceveurNavigations)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_message_recevoir_utilisat");
        });

        modelBuilder.Entity<Particulier>(entity =>
        {
            entity.HasKey(e => e.Idutilisateur).HasName("pk_particulier");

            entity.Property(e => e.Idutilisateur).ValueGeneratedNever();

            entity.HasOne(d => d.IddateNavigation).WithMany(p => p.Particuliers)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_particulier_naitre_date");

            entity.HasOne(d => d.IdutilisateurNavigation).WithOne(p => p.Particulier)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_particulier_heritage__utilisateur");
        });

        modelBuilder.Entity<Permission>(entity =>
        {
            entity.HasKey(e => e.Idpermission).HasName("pk_permission");
        });

        modelBuilder.Entity<Photo>(entity =>
        {
            entity.HasKey(e => e.Idphoto).HasName("pk_photo");

            entity.HasOne(d => d.IdannonceNavigation).WithMany(p => p.Photos)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_photo_comporter_annonce");

            entity.HasOne(d => d.IdincidentNavigation).WithMany(p => p.Photos)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_photo_prouver_incident");
        });

        modelBuilder.Entity<Professionnel>(entity =>
        {
            entity.HasKey(e => e.Idutilisateur).HasName("pk_professionnel");

            entity.Property(e => e.Idutilisateur).ValueGeneratedNever();

            entity.HasOne(d => d.IdutilisateurNavigation).WithOne(p => p.Professionnel)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_professionnel_heritage__utilisateur");
        });

        modelBuilder.Entity<Recherche>(entity =>
        {
            entity.HasKey(e => e.Idrecherche).HasName("pk_recherche");

            entity.Property(e => e.Paiementenligne).HasDefaultValue(false);

            entity.HasOne(d => d.IddatedebutrechercheNavigation).WithMany(p => p.RechercheIddatedebutrechercheNavigations)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_recherch_commencer_date");

            entity.HasOne(d => d.IddatefinrechercheNavigation).WithMany(p => p.RechercheIddatefinrechercheNavigations)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_recherch_terminer_date");

            entity.HasOne(d => d.IddepartementNavigation).WithMany(p => p.Recherches)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_recherch_connecter_departem");

            entity.HasOne(d => d.IdregionNavigation).WithMany(p => p.Recherches)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_recherch_lier_region");

            entity.HasOne(d => d.IdutilisateurNavigation).WithMany(p => p.Recherches)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_recherch_associati_utilisat");

            entity.HasOne(d => d.IdvilleNavigation).WithMany(p => p.Recherches)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_recherch_associer_ville");

            entity.HasMany(d => d.Idcommodites).WithMany(p => p.Idrecherches)
                .UsingEntity<Dictionary<string, object>>(
                    "Filtrer",
                    r => r.HasOne<Commodite>().WithMany()
                        .HasForeignKey("Idcommodite")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_filtrer_filtrer2_commodit"),
                    l => l.HasOne<Recherche>().WithMany()
                        .HasForeignKey("Idrecherche")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_filtrer_filtrer_recherch"),
                    j =>
                    {
                        j.HasKey("Idrecherche", "Idcommodite").HasName("pk_filtrer");
                        j.ToTable("filtrer");
                        j.HasIndex(new[] { "Idcommodite" }, "idx_filtrer_idcommodite");
                        j.IndexerProperty<int>("Idrecherche").HasColumnName("idrecherche");
                        j.IndexerProperty<int>("Idcommodite").HasColumnName("idcommodite");
                    });
        });

        modelBuilder.Entity<Region>(entity =>
        {
            entity.HasKey(e => e.Idregion).HasName("pk_region");
        });

        modelBuilder.Entity<Relier>(entity =>
        {
            entity.HasKey(e => new { e.Idannonce, e.Iddate }).HasName("pk_relier");

            entity.Property(e => e.Estdisponible).HasDefaultValue(false);

            entity.HasOne(d => d.IdannonceNavigation).WithMany(p => p.Reliers)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_relier_relier_annonce");

            entity.HasOne(d => d.IddateNavigation).WithMany(p => p.Reliers)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_relier_relier2_date");
        });

        modelBuilder.Entity<Reservation>(entity =>
        {
            entity.HasKey(e => e.Idreservation).HasName("pk_reservation");

            entity.Property(e => e.Telephoneclient).IsFixedLength();

            entity.HasOne(d => d.IdannonceNavigation).WithMany(p => p.Reservations)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_reservat_concerner_annonce");

            entity.HasOne(d => d.IddatedebutreservationNavigation).WithMany(p => p.ReservationIddatedebutreservationNavigations)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_reservat_debuter_date");

            entity.HasOne(d => d.IddatefinreservationNavigation).WithMany(p => p.ReservationIddatefinreservationNavigations)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_reservat_finir_date");

            entity.HasOne(d => d.IdutilisateurNavigation).WithMany(p => p.Reservations)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_reservation_reserver_utilisateur");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.Idrole).HasName("pk_role");

            entity.HasMany(d => d.Idpermissions).WithMany(p => p.Idroles)
                .UsingEntity<Dictionary<string, object>>(
                    "Permettre",
                    r => r.HasOne<Permission>().WithMany()
                        .HasForeignKey("Idpermission")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_permettre_permission"),
                    l => l.HasOne<Role>().WithMany()
                        .HasForeignKey("Idrole")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_permettre_role"),
                    j =>
                    {
                        j.HasKey("Idrole", "Idpermission").HasName("pk_permettre");
                        j.ToTable("permettre");
                        j.IndexerProperty<int>("Idrole").HasColumnName("idrole");
                        j.IndexerProperty<int>("Idpermission").HasColumnName("idpermission");
                    });
        });

        modelBuilder.Entity<Transaction>(entity =>
        {
            entity.HasKey(e => e.Idtransaction).HasName("pk_transaction");

            entity.HasOne(d => d.IdutilisateurNavigation).WithMany(p => p.Transactions)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_transact_faire_utilisat");

            entity.HasOne(d => d.IddateNavigation).WithMany(p => p.Transactions)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_transact_effectuer_date");

            entity.HasOne(d => d.IdreservationNavigation).WithMany(p => p.Transactions)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_transact_regler_reservat");
        });

        modelBuilder.Entity<Typehebergement>(entity =>
        {
            entity.HasKey(e => e.Idtypehebergement).HasName("pk_typehebergement");

            entity.HasOne(d => d.IdcategorieNavigation).WithMany(p => p.Typehebergements)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_typehebe_classer_categori");

            entity.HasMany(d => d.Idrecherches).WithMany(p => p.Idtypehebergements)
                .UsingEntity<Dictionary<string, object>>(
                    "Cibler",
                    r => r.HasOne<Recherche>().WithMany()
                        .HasForeignKey("Idrecherche")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_cibler_cibler2_recherch"),
                    l => l.HasOne<Typehebergement>().WithMany()
                        .HasForeignKey("Idtypehebergement")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_cibler_cibler_typehebe"),
                    j =>
                    {
                        j.HasKey("Idtypehebergement", "Idrecherche").HasName("pk_cibler");
                        j.ToTable("cibler");
                        j.HasIndex(new[] { "Idrecherche" }, "idx_cibler_idrecherche");
                        j.IndexerProperty<int>("Idtypehebergement").HasColumnName("idtypehebergement");
                        j.IndexerProperty<int>("Idrecherche").HasColumnName("idrecherche");
                    });
        });

        modelBuilder.Entity<Typevoyageur>(entity =>
        {
            entity.HasKey(e => e.Idtypevoyageur).HasName("pk_typevoyageur");
        });

        modelBuilder.Entity<Utilisateur>(entity =>
        {
            entity.HasKey(e => e.Idutilisateur).HasName("pk_utilisateur");

            entity.Property(e => e.IdentityVerified).HasDefaultValue(false);
            entity.Property(e => e.PhoneVerified).HasDefaultValue(false);
            entity.Property(e => e.Telephoneutilisateur).IsFixedLength();

            entity.HasOne(d => d.IdadresseNavigation).WithMany(p => p.Utilisateurs)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_utilisat_resider_adresse");

            entity.HasOne(d => d.IddateNavigation).WithMany(p => p.Utilisateurs)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_utilisat_creer_date");

            entity.HasMany(d => d.Idannonces).WithMany(p => p.Idutilisateurs)
                .UsingEntity<Dictionary<string, object>>(
                    "Favoriser",
                    r => r.HasOne<Annonce>().WithMany()
                        .HasForeignKey("Idannonce")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_favorise_favoriser_annonce"),
                    l => l.HasOne<Utilisateur>().WithMany()
                        .HasForeignKey("Idutilisateur")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_favorise_favoriser_utilisateur"),
                    j =>
                    {
                        j.HasKey("Idutilisateur", "Idannonce").HasName("pk_favoriser");
                        j.ToTable("favoriser");
                        j.HasIndex(new[] { "Idannonce" }, "idx_favoriser_idannonce");
                        j.IndexerProperty<int>("Idutilisateur").HasColumnName("idutilisateur");
                        j.IndexerProperty<int>("Idannonce").HasColumnName("idannonce");
                    });

            entity.HasMany(d => d.Idroles).WithMany(p => p.Idutilisateurs)
                .UsingEntity<Dictionary<string, object>>(
                    "Attribuer",
                    r => r.HasOne<Role>().WithMany()
                        .HasForeignKey("Idrole")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_attribuer_role"),
                    l => l.HasOne<Utilisateur>().WithMany()
                        .HasForeignKey("Idutilisateur")
                        .OnDelete(DeleteBehavior.Restrict)
                        .HasConstraintName("fk_attribuer_utilisateur"),
                    j =>
                    {
                        j.HasKey("Idutilisateur", "Idrole").HasName("pk_attribuer");
                        j.ToTable("attribuer");
                        j.IndexerProperty<int>("Idutilisateur").HasColumnName("idutilisateur");
                        j.IndexerProperty<int>("Idrole").HasColumnName("idrole");
                    });
        });

        modelBuilder.Entity<Ville>(entity =>
        {
            entity.HasKey(e => e.Idville).HasName("pk_ville");

            entity.Property(e => e.Codepostal).IsFixedLength();

            entity.HasOne(d => d.IddepartementNavigation).WithMany(p => p.Villes)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_ville_situer_departem");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
