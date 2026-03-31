using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using LeboncoinAPI.Controllers;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using LeboncoinAPI.Models.DTOs;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
namespace LeboncoinAPI.Tests
{
    [TestClass]
    public class AnnoncesControllerTests
    {
        private AnnoncesController controller;
        private LeboncoinDBContext context;
        private Mock<IAnnonceRepository> mockRepo;
        private Mock<IConfiguration> mockConfig;

        [TestInitialize]
        public void TestSetup()
        {
            var builder = new DbContextOptionsBuilder<LeboncoinDBContext>()
                          .UseInMemoryDatabase(databaseName: "LeboncoinTestDB");
            context = new LeboncoinDBContext(builder.Options);
            mockRepo = new Mock<IAnnonceRepository>();
            mockConfig = new Mock<IConfiguration>();
            mockConfig.Setup(c => c["CloudinarySettings:CloudName"]).Returns("test");
            mockConfig.Setup(c => c["CloudinarySettings:ApiKey"]).Returns("test");
            mockConfig.Setup(c => c["CloudinarySettings:ApiSecret"]).Returns("test");

            controller = new AnnoncesController(mockRepo.Object, context, mockConfig.Object);
        }

        [TestMethod]
        public void GetAnnonceById_ExistingId_ReturnsOkResult_AvecMoq()
        {
            // Arrange
            var fakeAnnonce = new Annonce
            {
                Idannonce = 1,
                Titreannonce = "Bel appartement",
                Photos = new List<Photo>(),
                Reservations = new List<Reservation>(),
                Idcommodites = new List<Commodite>()
            };
            // Act
            mockRepo.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(fakeAnnonce);
            var actionResult = controller.GetAnnonce(1).Result;
            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(OkObjectResult));
            var okResult = actionResult as OkObjectResult;
            Assert.IsNotNull(okResult.Value);
        }

        [TestMethod]
        public void GetAnnonceById_UnknownId_ReturnsNotFound_AvecMoq()
        {
            // Arrange
            mockRepo.Setup(repo => repo.GetByIdAsync(999)).ReturnsAsync((Annonce)null);
            // Act
            var actionResult = controller.GetAnnonce(999).Result;
            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(NotFoundObjectResult));
        }

        [TestMethod]
        public void DeleteAnnonce_ExistingId_ReturnsNoContent_AvecMoq()
        {
            // Arrange
            var fakeAnnonce = new Annonce { Idannonce = 5 };
            mockRepo.Setup(repo => repo.GetByIdAsync(5)).ReturnsAsync(fakeAnnonce);
            mockRepo.Setup(repo => repo.DeleteAsync(fakeAnnonce)).Returns(Task.CompletedTask);
            // Act
            var actionResult = controller.DeleteAnnonce(5).Result;
            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(NoContentResult));
            mockRepo.Verify(r => r.DeleteAsync(It.IsAny<Annonce>()), Times.Once);
        }

        [TestMethod]
        public void GetIndisponibilites_ReturnsList_AvecMoq()
        {
            // Arrange
            var dates = new List<DateOnly> { new DateOnly(2024, 12, 25) };
            mockRepo.Setup(repo => repo.GetIndisponibilitesAsync(1)).ReturnsAsync(dates);
            // Act
            var actionResult = controller.GetIndisponibilites(1).Result;
            var okResult = actionResult.Result as OkObjectResult;
            var resultList = okResult.Value as IEnumerable<string>;
            // Assert
            Assert.AreEqual("2024-12-25", resultList.First());
        }

        [TestMethod]
        public void AddFavorite_ReturnsOk_AvecMoq()
        {
            // Arrange
            int userId = 1;
            int annonceId = 10;
            mockRepo.Setup(r => r.AddFavoriteAsync(userId, annonceId)).Returns(Task.CompletedTask);
            // Act
            var actionResult = controller.AddFavorite(annonceId, userId).Result;
            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(OkResult));
        }
        [TestMethod]
        public void GetAnnoncesByUser_ExistingUser_ReturnsOkAvecListe()
        {
            // Arrange
            int userId = 1;
            var resultatsFake = new List<AnnonceSearchResultDto> { new AnnonceSearchResultDto { Idannonce = 10, Titreannonce = "Logement A" } };
            mockRepo.Setup(r => r.GetByUserIdAsync(userId)).ReturnsAsync(resultatsFake);
            // Act
            var actionResult = controller.GetAnnoncesByUser(userId).Result;
            // Assert
            Assert.IsInstanceOfType(actionResult.Result, typeof(OkObjectResult));
            var okResult = actionResult.Result as OkObjectResult;
            var model = okResult.Value as IEnumerable<AnnonceSearchResultDto>;
            Assert.AreEqual(1, model.Count());
        }

        [TestMethod]
        public void GetAnnoncesByUser_UnknownUser_ReturnsOkAvecListeVide()
        {
            // Arrange
            int userId = 999;
            mockRepo.Setup(r => r.GetByUserIdAsync(userId)).ReturnsAsync(new List<AnnonceSearchResultDto>());
            // Act
            var actionResult = controller.GetAnnoncesByUser(userId).Result;

            var okResult = actionResult.Result as OkObjectResult;
            var model = okResult.Value as IEnumerable<AnnonceSearchResultDto>;
            // Assert
            Assert.AreEqual(0, model.Count()); 
        }
        [TestMethod]
        public void SearchAnnonces_WithCriteria_ReturnsFilteredResults()
        {
            // Arrange
            string query = "Annecy";
            var fakeResults = new List<AnnonceSearchResultDto> { new AnnonceSearchResultDto { Nomville = "Annecy" } };
            mockRepo.Setup(r => r.GetByLocalisationAsync(query, null, null, null, null, null, null, null)).ReturnsAsync(fakeResults);
            // Act
            var actionResult = controller.SearchAnnonces(q: query).Result;
            var okResult = actionResult.Result as OkObjectResult;
            var model = okResult.Value as IEnumerable<AnnonceSearchResultDto>;
            // Assert
            Assert.AreEqual("Annecy", model.First().Nomville);
        }

        [TestMethod]
        public void SearchAnnonces_NoResultsFound_ReturnsEmptyList()
        {
            // Arrange
            string query = "VilleInexistante";
            mockRepo.Setup(r => r.GetByLocalisationAsync(query, null, null, null, null, null, null, null)).ReturnsAsync(new List<AnnonceSearchResultDto>());


            // Act
            var actionResult = controller.SearchAnnonces(q: query).Result;


            var okResult = actionResult.Result as OkObjectResult;
            var model = okResult.Value as IEnumerable<AnnonceSearchResultDto>;
            // Assert
            Assert.IsNotNull(model);
            Assert.AreEqual(0, model.Count());
        }
        [TestMethod]
        public void AddFavorite_ValidIds_ReturnsOk()
        {
            // Arrange
            mockRepo.Setup(r => r.AddFavoriteAsync(1, 10)).Returns(Task.CompletedTask);

            // Act
            var actionResult = controller.AddFavorite(10, 1).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(OkResult));
        }

        [TestMethod]
        public void RemoveFavorite_ExistingFavorite_ReturnsNoContent()
        {
            // Arrange
            mockRepo.Setup(r => r.RemoveFavoriteAsync(1, 10)).Returns(Task.CompletedTask);

            // Act
            var actionResult = controller.RemoveFavorite(10, 1).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(NoContentResult));
        }
        [TestMethod]
        public void AddIndisponibilite_ValidDates_ReturnsOk()
        {
            // Arrange
            var request = new UnavailabilityRequest { StartDate = "2026-05-01", EndDate = "2026-05-05" };
            mockRepo.Setup(r => r.SetIndisponibleAsync(It.IsAny<int>(), It.IsAny<DateOnly>(), It.IsAny<DateOnly>())).Returns(Task.CompletedTask);

            // Act
            var actionResult = controller.AddIndisponibilite(1, request).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(OkResult));
        }

        [TestMethod]
        public void AddIndisponibilite_InvalidDateFormat_ReturnsBadRequest()
        {
            // Arrange
            var request = new UnavailabilityRequest { StartDate = "date-invalide", EndDate = "2026-05-05" };

            // Act
            var actionResult = controller.AddIndisponibilite(1, request).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(BadRequestObjectResult));
            var badRequest = actionResult as BadRequestObjectResult;
            Assert.AreEqual("Invalid date format. Use YYYY-MM-DD.", badRequest.Value);
        }
        [TestMethod]
        public void PutAnnonce_MatchingIds_ReturnsNoContent()
        {
            // Arrange
            int id = 1;
            var annonce = new Annonce { Idannonce = id };
            mockRepo.Setup(r => r.GetByIdAsync(id)).ReturnsAsync(annonce);
            mockRepo.Setup(r => r.UpdateAsync(It.IsAny<Annonce>(), It.IsAny<Annonce>())).Returns(Task.CompletedTask);

            // Act
            var actionResult = controller.PutAnnonce(id, annonce).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(NoContentResult));
        }

        [TestMethod]
        public void PutAnnonce_MismatchedIds_ReturnsBadRequest()
        {
            // Arrange
            int idUrl = 1;
            var annonceBody = new Annonce { Idannonce = 2 }; 

            // Act
            var actionResult = controller.PutAnnonce(idUrl, annonceBody).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(BadRequestResult));
        }

        [TestMethod]
        public void GetSimilaires_ReturnsOk_AvecMoq()
        {
            // Arrange
            var fakeList = new List<AnnonceSearchResultDto> { new AnnonceSearchResultDto { Idannonce = 2, Titreannonce = "Similaire" } };
            mockRepo.Setup(r => r.GetSimilairesAsync(1)).ReturnsAsync(fakeList);

            // Act
            var actionResult = controller.GetSimilaires(1).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult.Result, typeof(OkObjectResult));
            var ok = actionResult.Result as OkObjectResult;
            var model = ok.Value as IEnumerable<AnnonceSearchResultDto>;
            Assert.AreEqual(1, model.Count());
        }

        [TestMethod]
        public void GetFavorites_ReturnsOk_AvecMoq()
        {
            // Arrange
            var fakeFavs = new List<AnnonceSearchResultDto> { new AnnonceSearchResultDto { Idannonce = 3 } };
            mockRepo.Setup(r => r.GetFavoritesByUserIdAsync(1)).ReturnsAsync(fakeFavs);

            // Act
            var actionResult = controller.GetFavorites(1).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult.Result, typeof(OkObjectResult));
        }

        [TestMethod]
        public void GetFavoriteIds_ReturnsOk_AvecMoq()
        {
            // Arrange
            var ids = new List<int> { 3, 4 };
            mockRepo.Setup(r => r.GetFavoriteIdsByUserIdAsync(1)).ReturnsAsync(ids);

            // Act
            var actionResult = controller.GetFavoriteIds(1).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult.Result, typeof(OkObjectResult));
        }

        [TestMethod]
        public void AddPhoto_ReturnsOk_AvecMoq()
        {
            // Arrange
            var photo = new Photo { Idphoto = 1, Idannonce = 1, Lienphoto = "url" };
            mockRepo.Setup(r => r.AddPhotoAsync(1, "url")).ReturnsAsync(photo);

            // Act
            var actionResult = controller.AddPhoto(1, new AddPhotoRequest { Url = "url" }).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(OkObjectResult));
        }

        [TestMethod]
        public void RemovePhoto_ReturnsNoContent_AvecMoq()
        {
            // Arrange
            mockRepo.Setup(r => r.RemovePhotoAsync(5)).Returns(Task.CompletedTask);

            // Act
            var actionResult = controller.RemovePhoto(5).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(NoContentResult));
        }

        [TestMethod]
        public void RemoveIndisponibilite_InvalidDate_ReturnsBadRequest()
        {
            // Arrange
            var invalidDate = "bad-date";

            // Act
            var actionResult = controller.RemoveIndisponibilite(1, invalidDate).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(BadRequestObjectResult));
        }
    }
}