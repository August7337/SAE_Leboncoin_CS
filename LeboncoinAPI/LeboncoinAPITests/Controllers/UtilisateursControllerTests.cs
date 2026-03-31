using LeboncoinAPI.Controllers;
using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace LeboncoinAPI.Tests;


[TestClass]
public class UtilisateursControllerTests
{
    private LeboncoinDBContext _context;
    private UtilisateurManager _userManager;
    private Mock<IConfiguration> _mockConfig;
    private UtilisateursController _controller;

    [TestInitialize]
    public void Setup()
    {
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        _context = new LeboncoinDBContext(options);
        _userManager = new UtilisateurManager(_context);

        _mockConfig = new Mock<IConfiguration>();
        _mockConfig.Setup(c => c["CloudinarySettings:CloudName"]).Returns("test");
        _mockConfig.Setup(c => c["CloudinarySettings:ApiKey"]).Returns("test");
        _mockConfig.Setup(c => c["CloudinarySettings:ApiSecret"]).Returns("test");

        _controller = new UtilisateursController(_userManager, _mockConfig.Object);
    }

    [TestMethod]
    public async Task Login_InvalidPassword_ReturnsBadRequest()
    {
        // Arrange
        var passwordClaire = "password123";
        var user = new Utilisateur
        {
            Idutilisateur = 1,
            Email = "test@test.com",
            Password = BCrypt.Net.BCrypt.HashPassword(passwordClaire),
            Pseudonyme = "Testeur",
            Solde = 0,
            Telephoneutilisateur = "0606060606"
        };

        _context.Utilisateurs.Add(user);
        await _context.SaveChangesAsync();

        var loginRequest = new UtilisateursController.LoginRequest
        {
            Email = "test@test.com",
            Password = "mauvais_password"
        };
        // Act
        var result = await _controller.Login(loginRequest);
        // Assert
        Assert.IsInstanceOfType(result, typeof(BadRequestObjectResult));
        var badRequest = result as BadRequestObjectResult;
        Assert.AreEqual("Mot de passe incorrect.", badRequest.Value);
    }

    [TestMethod]
    public async Task GetUtilisateurs_ReturnsList()
    {
        // Arrange
        _context.Utilisateurs.Add(new Utilisateur { Idutilisateur = 1, Email = "a@a.com", Pseudonyme = "A", Password = "p", Telephoneutilisateur = "01" });
        await _context.SaveChangesAsync();

        // Act
        var result = await _controller.GetUtilisateurs();

        // Assert
        if (result.Value != null)
        {
            Assert.AreEqual(1, result.Value.Count());
        }
        else
        {
            var ok = result.Result as OkObjectResult;
            Assert.IsNotNull(ok);
            var list = ok.Value as IEnumerable<Utilisateur>;
            Assert.IsNotNull(list);
            Assert.AreEqual(1, list.Count());
        }
    }

    [TestMethod]
    public async Task Register_WhenEmailExists_ReturnsConflict()
    {
        // Arrange
        _context.Utilisateurs.Add(new Utilisateur { Idutilisateur = 1, Email = "existing@ex.com", Pseudonyme = "X", Password = "p", Telephoneutilisateur = "01" });
        await _context.SaveChangesAsync();

        var dto = new RegisterParticulierDTO { Email = "existing@ex.com", Password = "P@ss1", Pseudonyme = "X" };

        // Act
        var result = await _controller.Register(dto);

        // Assert
        Assert.IsInstanceOfType(result, typeof(ConflictObjectResult));
    }
}
