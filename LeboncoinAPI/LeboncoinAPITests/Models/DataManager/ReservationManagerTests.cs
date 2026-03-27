using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

[TestClass]
public class ReservationManagerTests
{
    [TestMethod]
    public async Task GetByIdAsync_ReturnsFullObjectGraph()
    {
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: "ResaTest").ConfigureWarnings(x => x.Ignore(InMemoryEventId.TransactionIgnoredWarning)).Options;
        using var context = new LeboncoinDBContext(options);

        var ville = new Ville { Nomville = "Paris", Codepostal = "75000" };
        var adr = new Adresse { Numerorue = 1, Nomrue = "Champs-Élysées", IdvilleNavigation = ville };

        var annonce = new Annonce
        {
            Titreannonce = "Appart Luxe",
            Descriptionannonce = "Une superbe description obligatoire", // REQUIS
            IdadresseNavigation = adr
        };

        var resa = new Reservation
        {
            Idreservation = 1,
            Nomclient = "Doe",     // REQUIS
            Prenomclient = "John", // REQUIS
            IdannonceNavigation = annonce
        };

        context.Reservations.Add(resa);
        await context.SaveChangesAsync();

        var manager = new ReservationManager(context);
        var result = await manager.GetByIdAsync(1);

        Assert.IsNotNull(result);
        Assert.AreEqual("Paris", result.IdannonceNavigation.IdadresseNavigation.IdvilleNavigation.Nomville);
    }
}