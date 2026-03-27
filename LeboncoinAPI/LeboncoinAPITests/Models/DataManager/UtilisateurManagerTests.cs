using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

[TestClass]
public class UtilisateurManagerTests
{
    private LeboncoinDBContext _context;
    private UtilisateurManager _manager;

    [TestInitialize]
    public void Setup()
    {
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .ConfigureWarnings(x => x.Ignore(InMemoryEventId.TransactionIgnoredWarning))
    .Options;
        _context = new LeboncoinDBContext(options);
        _manager = new UtilisateurManager(_context);

        // On ajoute un rôle "Client" en base car le manager le cherche
        _context.Roles.Add(new Role { Idrole = 1, Nomrole = "Client" });
        _context.SaveChanges();
    }

    [TestMethod]
    public async Task RegisterFullParticulierAsync_SavesCorrectHierarchy()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            // Crucial pour ne pas planter sur la transaction BeginTransactionAsync
            .ConfigureWarnings(x => x.Ignore(InMemoryEventId.TransactionIgnoredWarning))
            .Options;

        using var context = new LeboncoinDBContext(options);

        // On doit ajouter le rôle "Client" car le manager le cherche à la fin (AppRoles.Client)
        context.Roles.Add(new Role { Nomrole = "Client" });
        await context.SaveChangesAsync();

        var manager = new UtilisateurManager(context);

        var dto = new RegisterParticulierDTO
        {
            Email = "test@exemple.com",
            Password = "Password123!",
            Pseudonyme = "LeTesteur",
            Nomutilisateur = "Doe",
            Prenomutilisateur = "John",
            Civilite = "M.",
            Telephoneutilisateur = "0601020304", // ÉTAIT PROBABLEMENT MANQUANT OU NULL
            Rue = "10 Rue de la Paix",
            CodePostal = "75000",
            Ville = "Paris",
            DateNaissance = new DateTime(1990, 05, 20)
        };

        // Act
        var result = await manager.RegisterFullParticulierAsync(dto);

        // Assert
        Assert.IsTrue(result);
        var savedUser = await context.Utilisateurs
            .Include(u => u.Particulier)
            .Include(u => u.IdadresseNavigation)
                .ThenInclude(a => a.IdvilleNavigation)
            .FirstOrDefaultAsync(u => u.Email == dto.Email);

        Assert.IsNotNull(savedUser);
        Assert.AreEqual("0601020304", savedUser.Telephoneutilisateur);
        Assert.IsNotNull(savedUser.Particulier);
    }
}