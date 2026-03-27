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
}
