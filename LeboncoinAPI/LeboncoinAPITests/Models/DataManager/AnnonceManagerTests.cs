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
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        using var context = new LeboncoinDBContext(options);
        var villeAnnecy = new Ville { Nomville = "Annecy", Codepostal = "74000" };
        var adresse = new Adresse { Nomrue = "Rue de la Paix", IdvilleNavigation = villeAnnecy };

        var annonceCorrecte = new Annonce
        {
            Idannonce = 1,
            Titreannonce = "Appartement Annecy",
            Descriptionannonce = "Superbe vue sur le lac",
            Prixnuitee = 100,
            IdadresseNavigation = adresse
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
        };

        context.Annonces.AddRange(annonceCorrecte, annonceAutreVille);
        await context.SaveChangesAsync();

        var manager = new AnnonceManager(context);
        var results = await manager.GetByLocalisationAsync("Annecy", null, null);
        Assert.AreEqual(1, results.Count());
        Assert.AreEqual("Appartement Annecy", results.First().Titreannonce);
    }

    [TestMethod]
    public async Task AddFavoriteAsync_AddsLinkInDatabase()
    {
        // 1. Setup avec exclusion des warnings de transaction (si nécessaire ici aussi)
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .ConfigureWarnings(x => x.Ignore(InMemoryEventId.TransactionIgnoredWarning))
            .Options;

        using var context = new LeboncoinDBContext(options);
        var manager = new AnnonceManager(context);

        // 2. Création d'un utilisateur avec les champs OBLIGATOIRES
        var user = new Utilisateur
        {
            Idutilisateur = 1,
            Pseudonyme = "TestUser",
            Email = "test@test.com",
            Password = "hashedpassword", // Était manquant
            Telephoneutilisateur = "0601020304", // Était manquant
            Solde = 0
        };

        // 3. Création d'une annonce avec les champs OBLIGATOIRES
        var annonce = new Annonce
        {
            Idannonce = 10,
            Titreannonce = "Appartement test",
            Descriptionannonce = "Description obligatoire pour que EF accepte l'insert", // Souvent requis
            Prixnuitee = 50,
            Idadresse = 1 // Assure-toi que cette FK ne cause pas d'erreur, sinon crée une Adresse
        };

        context.Utilisateurs.Add(user);
        context.Annonces.Add(annonce);
        await context.SaveChangesAsync();

        // 4. Act
        await manager.AddFavoriteAsync(user.Idutilisateur, annonce.Idannonce);

        // 5. Assert
        // On recharge l'utilisateur pour vérifier que l'annonce est dans sa collection Idannonces (favoris)
        var updatedUser = await context.Utilisateurs
            .Include(u => u.Idannonces)
            .FirstOrDefaultAsync(u => u.Idutilisateur == user.Idutilisateur);

        Assert.IsNotNull(updatedUser);
        Assert.IsTrue(updatedUser.Idannonces.Any(a => a.Idannonce == annonce.Idannonce));
    }
}