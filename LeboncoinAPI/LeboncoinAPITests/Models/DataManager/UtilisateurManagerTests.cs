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
        var dto = new RegisterParticulierDTO
        {
            Email = "new@user.com",
            Password = "Password123!",
            Pseudonyme = "Newbie",
            Nomutilisateur = "Doe",
            Prenomutilisateur = "John",
            CodePostal = "74000",
            Ville = "Annecy",
            Rue = "10 Rue Royale",
            DateNaissance = new DateTime(1990, 01, 01)
        };

        // Act
        var result = await _manager.RegisterFullParticulierAsync(dto);

        // Assert
        Assert.IsTrue(result);
        var user = await _context.Utilisateurs
            .Include(u => u.IdadresseNavigation)
                .ThenInclude(a => a.IdvilleNavigation)
                    .ThenInclude(v => v.IddepartementNavigation)
            .Include(u => u.Particulier)
            .FirstOrDefaultAsync(u => u.Email == "new@user.com");

        Assert.IsNotNull(user);
        Assert.IsNotNull(user.Particulier);
        Assert.AreEqual("Haute-Savoie", user.IdadresseNavigation.IdvilleNavigation.IddepartementNavigation.Nomdepartement); // Vérifie le dictionnaire GeoData
        Assert.IsTrue(BCrypt.Net.BCrypt.Verify("Password123!", user.Password)); // Vérifie le hashage
    }
}