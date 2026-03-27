using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

[TestClass]
public class IncidentManagerTests
{
    private LeboncoinDBContext _context;
    private IncidentManager _manager;

    [TestInitialize]
    public void Setup()
    {
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .ConfigureWarnings(x => x.Ignore(InMemoryEventId.TransactionIgnoredWarning))
            .Options;
        _context = new LeboncoinDBContext(options);
        _manager = new IncidentManager(_context);
    }

    [TestMethod]
    public async Task GetByUtilisateurAsync_ReturnsOnlyUserIncidents()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        using var context = new LeboncoinDBContext(options);

        // 1. On crée d'abord l'utilisateur pour qu'il existe en base
        var monUser = new Utilisateur
        {
            Idutilisateur = 42,
            Pseudonyme = "Jean",
            Email = "jean@test.com",
            Password = "hash",
            Telephoneutilisateur = "0600000000"
        };
        context.Utilisateurs.Add(monUser);

        // 2. On crée l'incident en utilisant l'OBJET utilisateur (pas juste l'ID)
        var incident = new Incident
        {
            Idincident = 1,
            Idutilisateur = 42,
            Descriptionincident = "Fuite",
            Motifincident = "Plomberie",
            IdutilisateurNavigation = monUser // On force la liaison
        };
        context.Incidents.Add(incident);

        await context.SaveChangesAsync();

        // 3. Act
        var manager = new IncidentManager(context);
        var results = await manager.GetByUtilisateurAsync(42);

        // 4. Assert
        Assert.AreEqual(1, results.Count(), "L'incident devrait être trouvé pour l'ID 42");
    }
}