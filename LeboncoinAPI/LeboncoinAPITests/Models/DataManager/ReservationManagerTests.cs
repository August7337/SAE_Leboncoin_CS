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
        // Arrange
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: "ResaTest").ConfigureWarnings(x => x.Ignore(InMemoryEventId.TransactionIgnoredWarning)).Options;
        using var context = new LeboncoinDBContext(options);

        var ville = new Ville { Nomville = "Paris", Codepostal = "75000" };
        var adr = new Adresse { Numerorue = 1, Nomrue = "Champs-Élysées", IdvilleNavigation = ville };

        var annonce = new Annonce
        {
            Titreannonce = "Appart Luxe",
            Descriptionannonce = "Une superbe description obligatoire",
            IdadresseNavigation = adr,
            IddateNavigation = new Date { Date1 = DateOnly.FromDateTime(DateTime.Now) },
            IdtypehebergementNavigation = new Typehebergement { Nomtypehebergement = "Appartement" },
            IdheurearriveeNavigation = new Heure { Heure1 = TimeOnly.Parse("14:00") },
            IdheuredepartNavigation = new Heure { Heure1 = TimeOnly.Parse("10:00") },
            IdutilisateurNavigation = new Utilisateur { Pseudonyme = "Owner", Email = "o@o.com", Password = "p", Telephoneutilisateur = "01", Solde = 0 }
        };

        var resa = new Reservation
        {
            Idreservation = 1,
            Nomclient = "Doe",     
            Prenomclient = "John", 
            IdannonceNavigation = annonce,
            IddatedebutreservationNavigation = new Date { Date1 = DateOnly.FromDateTime(DateTime.Now) },
            IddatefinreservationNavigation = new Date { Date1 = DateOnly.FromDateTime(DateTime.Now.AddDays(1)) }
        };

        context.Reservations.Add(resa);
        await context.SaveChangesAsync();

        var manager = new ReservationManager(context);
        // Act
        var result = await manager.GetByIdAsync(1);

        // Assert
        Assert.IsNotNull(result);
        Assert.AreEqual("Paris", result.IdannonceNavigation.IdadresseNavigation.IdvilleNavigation.Nomville);
    }
}