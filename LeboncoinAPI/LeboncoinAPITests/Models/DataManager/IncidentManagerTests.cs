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
        var user1 = new Utilisateur { Idutilisateur = 1, Pseudonyme = "U1" };
        var user2 = new Utilisateur { Idutilisateur = 2, Pseudonyme = "U2" };

        _context.Incidents.AddRange(new List<Incident> {
            new Incident { Idincident = 1, Idutilisateur = 1, Descriptionincident = "Fuite" },
            new Incident { Idincident = 2, Idutilisateur = 2, Descriptionincident = "Bruit" }
        });
        await _context.SaveChangesAsync();

        // Act
        var results = await _manager.GetByUtilisateurAsync(1);

        // Assert
        Assert.AreEqual(1, results.Count());
        Assert.AreEqual("Fuite", results.First().Descriptionincident);
    }
}