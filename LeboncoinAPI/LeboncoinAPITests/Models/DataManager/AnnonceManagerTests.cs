using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

[TestClass]
public class AnnonceManagerTests
{
    private LeboncoinDBContext _context;
    private AnnonceManager _manager;

    [TestInitialize]
    public void Setup()
    {
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .ConfigureWarnings(x => x.Ignore(InMemoryEventId.TransactionIgnoredWarning))
            .Options;
        _context = new LeboncoinDBContext(options);
        _manager = new AnnonceManager(_context);
    }

    [TestMethod]
    public async Task GetByLocalisationAsync_FilterByCity_ReturnsCorrectAnnonces()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        using var context = new LeboncoinDBContext(options);
        var villeAnnecy = new Ville { Nomville = "Annecy", Codepostal = "74000" };
        var adresse = new Adresse { Nomrue = "Rue de la Paix", IdvilleNavigation = villeAnnecy };
        // required related data for Annonce entity
        var dateNow = new Date { Date1 = DateOnly.FromDateTime(DateTime.Now) };
        var type = new Typehebergement { Nomtypehebergement = "Appartement" };
        var heure = new Heure { Heure1 = TimeOnly.MaxValue };
        var owner = new Utilisateur { Pseudonyme = "Owner", Email = "owner@test.com", Password = "p", Telephoneutilisateur = "0101010101", Solde = 0 };

        var annonceCorrecte = new Annonce
        {
            Idannonce = 1,
            Titreannonce = "Appartement Annecy",
            Descriptionannonce = "Superbe vue sur le lac",
            Prixnuitee = 100,
            IdadresseNavigation = adresse,
            IddateNavigation = dateNow,
            IdtypehebergementNavigation = type,
            IdheurearriveeNavigation = heure,
            IdheuredepartNavigation = heure,
            IdutilisateurNavigation = owner
        };
        var annonceAutreVille = new Annonce
        {
            Idannonce = 2,
            Titreannonce = "Studio Lyon",
            Descriptionannonce = "Proche métro",
            Prixnuitee = 80,
            IdadresseNavigation = new Adresse
            {
                Nomrue = "Rue de la République",
                IdvilleNavigation = new Ville { Nomville = "Lyon", Codepostal = "69000" }
            }
            ,
            IddateNavigation = dateNow,
            IdtypehebergementNavigation = type,
            IdheurearriveeNavigation = heure,
            IdheuredepartNavigation = heure,
            IdutilisateurNavigation = owner
        };

        context.Dates.Add(dateNow);
        context.Typehebergements.Add(type);
        context.Heures.Add(heure);
        context.Utilisateurs.Add(owner);
        context.Annonces.AddRange(annonceCorrecte, annonceAutreVille);
        await context.SaveChangesAsync();

        var manager = new AnnonceManager(context);
        // Act
        var results = await manager.GetByLocalisationAsync("Annecy", null, null);
        // Assert
        Assert.AreEqual(1, results.Count());
        Assert.AreEqual("Appartement Annecy", results.First().Titreannonce);
    }

    [TestMethod]
    public async Task AddFavoriteAsync_AddsLinkInDatabase()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .ConfigureWarnings(x => x.Ignore(InMemoryEventId.TransactionIgnoredWarning))
            .Options;

        using var context = new LeboncoinDBContext(options);
        var manager = new AnnonceManager(context);
        var user = new Utilisateur
        {
            Idutilisateur = 1,
            Pseudonyme = "TestUser",
            Email = "test@test.com",
            Password = "hashedpassword", 
            Telephoneutilisateur = "0601020304", 
            Solde = 0
        };
        var annonce = new Annonce
        {
            Idannonce = 10,
            Titreannonce = "Appartement test",
            Descriptionannonce = "Description obligatoire pour que EF accepte l'insert", 
            Prixnuitee = 50,
            Idadresse = 1 
        };

        context.Utilisateurs.Add(user);
        context.Annonces.Add(annonce);
        await context.SaveChangesAsync();
        // Act
        await manager.AddFavoriteAsync(user.Idutilisateur, annonce.Idannonce);
        var updatedUser = await context.Utilisateurs
            .Include(u => u.Idannonces)
            .FirstOrDefaultAsync(u => u.Idutilisateur == user.Idutilisateur);

        // Assert
        Assert.IsNotNull(updatedUser);
        Assert.IsTrue(updatedUser.Idannonces.Any(a => a.Idannonce == annonce.Idannonce));
    }
}