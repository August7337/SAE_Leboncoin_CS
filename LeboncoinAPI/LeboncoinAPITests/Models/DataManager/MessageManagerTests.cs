using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

[TestClass]
public class MessageManagerTests
{
    private LeboncoinDBContext _context;
    private MessageManager _manager;

    [TestInitialize]
    public void Setup()
    {
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
        {

        }.UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString()).ConfigureWarnings(x => x.Ignore(InMemoryEventId.TransactionIgnoredWarning)).Options;
        _context = new LeboncoinDBContext(options);
        _manager = new MessageManager(_context);
    }

    [TestMethod]
    public async Task GetConversationsByUserIdAsync_ReturnsOnlyLatestMessagePerContact()
    {
        // Arrange
        var dateNow = new Date { Date1 = DateOnly.FromDateTime(DateTime.UtcNow) };
        var user1 = new Utilisateur { Idutilisateur = 1, Pseudonyme = "U1", Email = "u1@test.com", Password = "p", Telephoneutilisateur = "01" };
        var user2 = new Utilisateur { Idutilisateur = 2, Pseudonyme = "U2", Email = "u2@test.com", Password = "p", Telephoneutilisateur = "01" };
        _context.Dates.Add(dateNow);
        _context.Utilisateurs.AddRange(user1, user2);
        _context.Messages.AddRange(new List<Message> {
            new Message { Idmessage = 1, Idutilisateurexpediteur = 1, Idutilisateurreceveur = 2, Contenumessage = "Hello", IddateNavigation = dateNow, IdutilisateurexpediteurNavigation = user1, IdutilisateurreceveurNavigation = user2 },
            new Message { Idmessage = 2, Idutilisateurexpediteur = 2, Idutilisateurreceveur = 1, Contenumessage = "Salut !", IddateNavigation = dateNow, IdutilisateurexpediteurNavigation = user2, IdutilisateurreceveurNavigation = user1 }
        });
        await _context.SaveChangesAsync();
        // Act
        var conversations = await _manager.GetConversationsByUserIdAsync(1);
        // Assert
        Assert.AreEqual(1, conversations.Count()); 
        Assert.AreEqual("Salut !", conversations.First().Contenumessage); 
    }
}