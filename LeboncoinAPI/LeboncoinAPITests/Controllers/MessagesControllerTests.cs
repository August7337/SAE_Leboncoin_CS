using LeboncoinAPI.Controllers;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LeboncoinAPI.Tests
{
    [TestClass]
    public class MessagesControllerTests
    {
        private MessagesController _controller;
        private Mock<IMessageRepository> _mockMessageRepo;
        private Mock<IDataUtilisateurRepository<Utilisateur>> _mockUserRepo;

        [TestInitialize]
        public void TestSetup()
        {
            _mockMessageRepo = new Mock<IMessageRepository>();
            _mockUserRepo = new Mock<IDataUtilisateurRepository<Utilisateur>>();
            _controller = new MessagesController(_mockMessageRepo.Object, _mockUserRepo.Object);
        }

        // --- TESTS POUR GetConversations ---

        [TestMethod]
        public void GetConversations_ValidUserId_ReturnsOkWithData_AvecMoq()
        {
            // Arrange
            int userId = 1;
            var fakeConversations = new List<Message>
            {
                new Message
                {
                    Idutilisateurexpediteur = 1,
                    Idutilisateurreceveur = 2,
                    Contenumessage = "Salut !",
                    IdutilisateurreceveurNavigation = new Utilisateur { Pseudonyme = "Jean" }
                }
            };
            _mockMessageRepo.Setup(r => r.GetConversationsByUserIdAsync(userId).Result).Returns(fakeConversations);

            // Act
            var actionResult = _controller.GetConversations(userId).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult.Result, typeof(OkObjectResult));
            var okResult = actionResult.Result as OkObjectResult;
            var list = okResult.Value as IEnumerable<object>;
            Assert.AreEqual(1, list.Count());
        }

        [TestMethod]
        public void GetConversations_NoConversations_ReturnsEmptyList_AvecMoq()
        {
            // Arrange
            int userId = 99;
            _mockMessageRepo.Setup(r => r.GetConversationsByUserIdAsync(userId).Result).Returns(new List<Message>());

            // Act
            var actionResult = _controller.GetConversations(userId).Result;

            // Assert
            var okResult = actionResult.Result as OkObjectResult;
            var list = okResult.Value as IEnumerable<object>;
            Assert.AreEqual(0, list.Count());
        }

        // --- TESTS POUR GetChat ---

        [TestMethod]
        public void GetChat_ValidIds_ReturnsChatHistory_AvecMoq()
        {
            // Arrange
            int userId = 1;
            int interId = 2;
            var fakeMessages = new List<Message> { new Message { Idmessage = 1, Contenumessage = "Hello" } };
            var fakeInterlocuteur = new Utilisateur { Idutilisateur = 2, Pseudonyme = "Alice" };

            _mockMessageRepo.Setup(r => r.GetChatAsync(userId, interId).Result).Returns(fakeMessages);
            _mockUserRepo.Setup(r => r.GetByIdAsync(interId).Result).Returns(fakeInterlocuteur);

            // Act
            var actionResult = _controller.GetChat(userId, interId).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult.Result, typeof(OkObjectResult));
            var okResult = actionResult.Result as OkObjectResult;
            Assert.IsNotNull(okResult);

            // Utilisation de la réflexion pour lire la propriété Interlocuteur de l'objet anonyme
            var resultValue = okResult.Value;
            var interlocuteurProp = resultValue.GetType().GetProperty("Interlocuteur").GetValue(resultValue, null);
            var pseudonyme = interlocuteurProp.GetType().GetProperty("Pseudonyme").GetValue(interlocuteurProp, null);
            Assert.AreEqual("Alice", pseudonyme);
        }

        [TestMethod]
        public async Task GetChat_UnknownInterlocuteur_ReturnsInconnu_AvecMoq()
        {
            // Arrange
            _mockMessageRepo.Setup(r => r.GetChatAsync(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(new List<Message>());
            _mockUserRepo.Setup(r => r.GetByIdAsync(It.IsAny<int>())).ReturnsAsync((Utilisateur)null);

            // Act
            var actionResult = await _controller.GetChat(1, 999);

            // Assert
            var okResult = actionResult.Result as OkObjectResult;
            var data = okResult.Value;

            var interlocuteurProp = data.GetType().GetProperty("Interlocuteur").GetValue(data, null);
            var pseudonyme = interlocuteurProp.GetType().GetProperty("Pseudonyme").GetValue(interlocuteurProp, null);

            Assert.AreEqual("Inconnu", pseudonyme);
        }

        // --- TESTS POUR PostMessage ---

        [TestMethod]
        public void PostMessage_ValidContent_ReturnsOk_AvecMoq()
        {
            // Arrange
            var dto = new MessagesController.PostMessageDto { ExpediteurId = 1, DestinataireId = 2, Contenu = "Texte valide" };
            _mockMessageRepo.Setup(r => r.AddMessageAsync(It.IsAny<Message>())).Returns(Task.CompletedTask);

            // Act
            var actionResult = _controller.PostMessage(dto).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(OkResult));
            _mockMessageRepo.Verify(r => r.AddMessageAsync(It.IsAny<Message>()), Times.Once);
        }

        [TestMethod]
        public void PostMessage_EmptyContent_ReturnsBadRequest_AvecMoq()
        {
            // Arrange
            var dto = new MessagesController.PostMessageDto { Contenu = "" }; // Vide

            // Act
            var actionResult = _controller.PostMessage(dto).Result;

            // Assert
            Assert.IsInstanceOfType(actionResult, typeof(BadRequestObjectResult));
            var badRequest = actionResult as BadRequestObjectResult;
            Assert.AreEqual("Le contenu ne peut pas être vide.", badRequest.Value);
        }
    }
}