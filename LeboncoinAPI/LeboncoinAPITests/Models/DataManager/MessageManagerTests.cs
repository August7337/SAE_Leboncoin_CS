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
        // Arrange: Utilisateur 1 parle avec Utilisateur 2 (2 messages)
        _context.Messages.AddRange(new List<Message> {
            new Message { Idmessage = 1, Idutilisateurexpediteur = 1, Idutilisateurreceveur = 2, Contenumessage = "Hello" },
            new Message { Idmessage = 2, Idutilisateurexpediteur = 2, Idutilisateurreceveur = 1, Contenumessage = "Salut !" }
        });
        await _context.SaveChangesAsync();

        // Act
        var conversations = await _manager.GetConversationsByUserIdAsync(1);

        // Assert
        Assert.AreEqual(1, conversations.Count()); // Une seule conversation avec l'utilisateur 2
        Assert.AreEqual("Salut !", conversations.First().Contenumessage); // Le dernier message
    }
}