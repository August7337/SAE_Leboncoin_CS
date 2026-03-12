using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

public partial class LeboncoinDBContext : DbContext
{
    public LeboncoinDBContext() { }

    public LeboncoinDBContext(DbContextOptions<LeboncoinDBContext> options)
        : base(options) { }

    public virtual DbSet<Adresse> Adresses { get; set; }
    public virtual DbSet<Annonce> Annonces { get; set; }
    public virtual DbSet<Avi> Avis { get; set; }
    public virtual DbSet<Cartebancaire> Cartebancaires { get; set; }
    public virtual DbSet<Categorie> Categories { get; set; }
    public virtual DbSet<Commodite> Commodites { get; set; }
    public virtual DbSet<Compensation> Compensations { get; set; }
    public virtual DbSet<Date> Dates { get; set; }
    public virtual DbSet<Departement> Departements { get; set; }
    public virtual DbSet<Heure> Heures { get; set; }
    public virtual DbSet<Incident> Incidents { get; set; }
    public virtual DbSet<Inclure> Inclures { get; set; }
    public virtual DbSet<Message> Messages { get; set; }
    public virtual DbSet<Particulier> Particuliers { get; set; }
    public virtual DbSet<Permission> Permissions { get; set; }
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
        base.OnModelCreating(modelBuilder);

        // Relations many-to-many
        modelBuilder.Entity<Annonce>()
            .HasMany(a => a.Idcommodites)
            .WithMany(c => c.Idannonces);

        modelBuilder.Entity<Annonce>()
            .HasMany(a => a.Idutilisateurs)
            .WithMany(u => u.Idannonces);

        modelBuilder.Entity<Annonce>()
            .HasMany(a => a.IdannonceAs)
            .WithMany(a => a.IdannonceBs)
            .UsingEntity(j => j.ToTable("ressembler"));

        modelBuilder.Entity<Recherche>()
            .HasMany(r => r.Idcommodites)
            .WithMany(c => c.Idrecherches)
            .UsingEntity(j => j.ToTable("filtrer"));

        modelBuilder.Entity<Recherche>()
            .HasMany(r => r.Idtypehebergements)
            .WithMany(t => t.Idrecherches)
            .UsingEntity(j => j.ToTable("cibler"));

        modelBuilder.Entity<Role>()
            .HasMany(r => r.Idpermissions)
            .WithMany(p => p.Idroles)
            .UsingEntity(j => j.ToTable("permettre"));

        modelBuilder.Entity<Utilisateur>()
            .HasMany(u => u.Idroles)
            .WithMany(r => r.Idutilisateurs)
            .UsingEntity(j => j.ToTable("attribuer"));

        modelBuilder.Entity<Utilisateur>()
            .HasMany(u => u.Idannonces)
            .WithMany(a => a.Idutilisateurs);

        modelBuilder.Entity<Incident>()
            .HasMany(i => i.Idcompensations)
            .WithMany(c => c.Idincidents)
            .UsingEntity(j => j.ToTable("demander"));

        // Clés composées
        modelBuilder.Entity<Inclure>()
            .HasKey(i => new { i.Idreservation, i.Idtypevoyageur });

        modelBuilder.Entity<Relier>()
            .HasKey(r => new { r.Idannonce, r.Iddate });

        // Contraintes de suppression en cascade
        modelBuilder.Entity<Annonce>()
            .HasOne(a => a.IdadresseNavigation)
            .WithMany(ad => ad.Annonces)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Annonce>()
            .HasOne(a => a.IddateNavigation)
            .WithMany(d => d.Annonces)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Annonce>()
            .HasOne(a => a.IdheurearriveeNavigation)
            .WithMany(h => h.AnnonceIdheurearriveeNavigations)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Annonce>()
            .HasOne(a => a.IdheuredepartNavigation)
            .WithMany(h => h.AnnonceIdheuredepartNavigations)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Annonce>()
            .HasOne(a => a.IdtypehebergementNavigation)
            .WithMany(t => t.Annonces)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Annonce>()
            .HasOne(a => a.IdutilisateurNavigation)
            .WithMany(u => u.Annonces)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Utilisateur>()
            .HasOne(u => u.IdadresseNavigation)
            .WithMany(ad => ad.Utilisateurs)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Utilisateur>()
            .HasOne(u => u.IddateNavigation)
            .WithMany(d => d.Utilisateurs)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Utilisateur>()
            .HasOne(u => u.IdcartebancaireNavigation)
            .WithMany(c => c.Utilisateurs)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Reservation>()
            .HasOne(r => r.IdannonceNavigation)
            .WithMany(a => a.Reservations)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Reservation>()
            .HasOne(r => r.IdutilisateurNavigation)
            .WithMany(u => u.Reservations)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Reservation>()
            .HasOne(r => r.IddatedebutreservationNavigation)
            .WithMany(d => d.ReservationIddatedebutreservationNavigations)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Reservation>()
            .HasOne(r => r.IddatefinreservationNavigation)
            .WithMany(d => d.ReservationIddatefinreservationNavigations)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Avi>()
            .HasOne(av => av.IdannonceNavigation)
            .WithMany(a => a.Avis)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Avi>()
            .HasOne(av => av.IddateNavigation)
            .WithMany(d => d.Avis)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Avi>()
            .HasOne(av => av.IdutilisateurNavigation)
            .WithMany(u => u.Avis)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Cartebancaire>()
            .HasOne(c => c.IdutilisateurNavigation)
            .WithMany(u => u.Cartebancaires)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Incident>()
            .HasOne(i => i.IdutilisateurNavigation)
            .WithMany(u => u.Incidents)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Incident>()
            .HasOne(i => i.IdreservationNavigation)
            .WithMany(r => r.Incidents)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Incident>()
            .HasOne(i => i.IddateNavigation)
            .WithMany(d => d.Incidents)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Message>()
            .HasOne(m => m.IdutilisateurexpediteurNavigation)
            .WithMany(u => u.MessageIdutilisateurexpediteurNavigations)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Message>()
            .HasOne(m => m.IdutilisateurreceveurNavigation)
            .WithMany(u => u.MessageIdutilisateurreceveurNavigations)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Message>()
            .HasOne(m => m.IddateNavigation)
            .WithMany(d => d.Messages)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Particulier>()
            .HasOne(par => par.IdutilisateurNavigation)
            .WithOne(u => u.Particulier)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Particulier>()
            .HasOne(par => par.IddateNavigation)
            .WithMany(d => d.Particuliers)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Professionnel>()
            .HasOne(pro => pro.IdutilisateurNavigation)
            .WithOne(u => u.Professionnel)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Relier>()
            .HasOne(rel => rel.IdannonceNavigation)
            .WithMany(a => a.Reliers)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Relier>()
            .HasOne(rel => rel.IddateNavigation)
            .WithMany(d => d.Reliers)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Transaction>()
            .HasOne(t => t.IdcartebancaireNavigation)
            .WithMany(c => c.Transactions)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Transaction>()
            .HasOne(t => t.IdreservationNavigation)
            .WithMany(r => r.Transactions)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Transaction>()
            .HasOne(t => t.IddateNavigation)
            .WithMany(d => d.Transactions)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Inclure>()
            .HasOne(inc => inc.IdreservationNavigation)
            .WithMany(r => r.Inclures)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Inclure>()
            .HasOne(inc => inc.IdtypevoyageurNavigation)
            .WithMany(t => t.Inclures)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Commodite>()
            .HasOne(com => com.IdcategorieNavigation)
            .WithMany(cat => cat.Commodites)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Typehebergement>()
            .HasOne(th => th.IdcategorieNavigation)
            .WithMany(cat => cat.Typehebergements)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Departement>()
            .HasOne(dep => dep.IdregionNavigation)
            .WithMany(reg => reg.Departements)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Ville>()
            .HasOne(v => v.IddepartementNavigation)
            .WithMany(dep => dep.Villes)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Recherche>()
            .HasOne(rech => rech.IdutilisateurNavigation)
            .WithMany(u => u.Recherches)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Recherche>()
            .HasOne(rech => rech.IddatedebutrechercheNavigation)
            .WithMany(d => d.RechercheIddatedebutrechercheNavigations)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Recherche>()
            .HasOne(rech => rech.IddatefinrechercheNavigation)
            .WithMany(d => d.RechercheIddatefinrechercheNavigations)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Recherche>()
            .HasOne(rech => rech.IddepartementNavigation)
            .WithMany(dep => dep.Recherches)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Recherche>()
            .HasOne(rech => rech.IdregionNavigation)
            .WithMany(reg => reg.Recherches)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<Recherche>()
            .HasOne(rech => rech.IdvilleNavigation)
            .WithMany(v => v.Recherches)
            .OnDelete(DeleteBehavior.Restrict);

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}