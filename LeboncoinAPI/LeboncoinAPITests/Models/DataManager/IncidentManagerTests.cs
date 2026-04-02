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

        var statut = new StatutIncident { Idstatutincident = 1, Libelle = "Ouvert", Code = "OUVERT" };
        context.StatutsIncident.Add(statut);

        var date = new Date { Iddate = 1, Date1 = DateOnly.FromDateTime(DateTime.UtcNow) };
        context.Dates.Add(date);

        var monUser = new Utilisateur
        {
            Idutilisateur = 42,
            Pseudonyme = "Jean",
            Email = "jean@test.com",
            Password = "hash",
            Telephoneutilisateur = "0600000000"
        };
        context.Utilisateurs.Add(monUser);

        var proprietaire = new Utilisateur
        {
            Idutilisateur = 43,
            Pseudonyme = "Proprio",
            Email = "proprio@test.com",
            Password = "hash",
            Telephoneutilisateur = "0600000001"
        };
        context.Utilisateurs.Add(proprietaire);

        var annonce = new Annonce
        {
            Idannonce = 1,
            Titreannonce = "Annonce Test",
            Prixnuitee = 50,
            Capacite = 2,
            Idutilisateur = 43,
            Descriptionannonce = "Desc"
        };
        context.Annonces.Add(annonce);

        var reservation = new Reservation
        {
            Idreservation = 1,
            Idutilisateur = 42,
            Idannonce = 1,
            Nomclient = "Client",
            Prenomclient = "Test",
            Iddatedebutreservation = 1,
            Iddatefinreservation = 1
        };
        context.Reservations.Add(reservation);

        var incident = new Incident
        {
            Idincident = 1,
            Idutilisateur = 42,
            Idreservation = 1,
            Iddate = 1,
            Idstatutincident = 1,
            Descriptionincident = "Fuite",
            Motifincident = "Plomberie"
        };
        context.Incidents.Add(incident);

        await context.SaveChangesAsync();

        var manager = new IncidentManager(context);
        // Act
        var results = await manager.GetByUtilisateurAsync(42);

        // Assert
        Assert.AreEqual(1, results.Count(), "L'incident devrait être trouvé pour l'ID 42");
    }
}