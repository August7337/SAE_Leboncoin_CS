using LeboncoinAPI.Controllers;
using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using Microsoft.Extensions.Configuration; 
[TestClass]
public class ReservationsControllerTests
{
    private ReservationsController _controller;
    private LeboncoinDBContext _context;
    private Mock<IReservationRepository> _mockRepo;
    private Mock<IConfiguration> _mockConfig;

    [TestInitialize]
    public void TestSetup()
    {
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        _context = new LeboncoinDBContext(options);

        _mockRepo = new Mock<IReservationRepository>();
        _mockConfig = new Mock<IConfiguration>();
        _mockConfig.Setup(c => c["Stripe:SecretKey"]).Returns("sk_test_mock");

        _controller = new ReservationsController(_mockRepo.Object, _context, _mockConfig.Object);
    }
    [TestMethod]
    public async Task GetReservation_ExistingId_ReturnsOk_AvecMoq()
    {
        // Arrange
        var res = new Reservation { Idreservation = 1, Nomclient = "Test" };
        _mockRepo.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(res);
        // Act
        var result = await _controller.GetReservation(1);
        // Assert
        Assert.IsInstanceOfType(result.Result, typeof(OkObjectResult));
    }

    [TestMethod]
    public async Task GetReservation_UnknownId_ReturnsNotFound_AvecMoq()
    {
        // Arrange
        _mockRepo.Setup(r => r.GetByIdAsync(99)).ReturnsAsync((Reservation)null);
        // Act
        var result = await _controller.GetReservation(99);
        // Assert
        Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
    }
    [TestMethod]
    public async Task CreateUpdateCheckoutSession_RefundCase_UpdatesSolde()
    {
        // Arrange
        var userId = 1;
        var user = new Utilisateur
        {
            Idutilisateur = userId,
            Solde = 10.00m,
            Email = "a@a.com",
            Password = "P",
            Pseudonyme = "U",
            Telephoneutilisateur = "01"
        };

        var annonce = new Annonce
        {
            Idannonce = 1,
            Prixnuitee = 50.00m,
            Titreannonce = "T",
            Descriptionannonce = "D"
        };

        var reservation = new Reservation
        {
            Idreservation = 1,
            Idutilisateur = userId,
            Idannonce = 1,
            Nomclient = "N",
            Prenomclient = "P"
        };
        var transaction = new Transaction
        {
            Idreservation = 1,
            Idutilisateur = userId,
            Montanttransaction = 1000.00m
        };

        _context.Utilisateurs.Add(user);
        _context.Annonces.Add(annonce);
        _context.Reservations.Add(reservation);
        _context.Transactions.Add(transaction); 
        await _context.SaveChangesAsync();
        _context.Entry(user).State = EntityState.Detached;
        _context.Entry(reservation).State = EntityState.Detached;

        var dto = new ReservationCreateDto
        {
            Idreservation = 1,
            Idannonce = 1,
            DateDebut = DateTime.Now.AddDays(10),
            DateFin = DateTime.Now.AddDays(11),
            Idutilisateur = userId,
            Inclures = new List<InclureCreateDto> {
            new InclureCreateDto { Idtypevoyageur = 1, Nombrevoyageur = 1 }
        }
        };
        // Act
        var result = await _controller.CreateUpdateCheckoutSession(dto);
        var updatedUser = await _context.Utilisateurs.AsNoTracking().FirstAsync(u => u.Idutilisateur == userId);
        // Assert
        Assert.IsInstanceOfType(result, typeof(OkObjectResult), "Le contrôleur aurait dû retourner Ok");
        Assert.IsTrue(updatedUser.Solde > 10.00m, $"Le solde ({updatedUser.Solde}) n'a pas bougé. Somme des transactions en DB : {await _context.Transactions.Where(t => t.Idreservation == 1).SumAsync(t => t.Montanttransaction)}");
    }

    [TestMethod]
    public async Task CreateUpdateCheckoutSession_MissingId_ReturnsBadRequest()
    {
        // Arrange
        var dto = new ReservationCreateDto { Idreservation = null };
        // Act
        var result = await _controller.CreateUpdateCheckoutSession(dto);
        // Assert
        Assert.IsInstanceOfType(result, typeof(BadRequestObjectResult));
    }
    [TestMethod]
    public async Task DeleteReservation_Success_ReturnsNoContent()
    {
        // Arrange
        var res = new Reservation { Idreservation = 1 };
        _mockRepo.Setup(r => r.GetByIdAsync(1)).ReturnsAsync(res);
        _mockRepo.Setup(r => r.DeleteAsync(res)).Returns(Task.CompletedTask);
        // Act
        var result = await _controller.DeleteReservation(1);
        // Assert
        Assert.IsInstanceOfType(result, typeof(NoContentResult));
        _mockRepo.Verify(r => r.DeleteAsync(res), Times.Once);
    }

    [TestMethod]
    public async Task DeleteReservation_NotFound_ReturnsNotFound()
    {
        // Arrange
        _mockRepo.Setup(r => r.GetByIdAsync(1)).ReturnsAsync((Reservation)null);
        // Act
        var result = await _controller.DeleteReservation(1);
        // Assert
        Assert.IsInstanceOfType(result, typeof(NotFoundResult));
    }
}