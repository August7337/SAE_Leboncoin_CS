using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LeboncoinAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MessagesController : ControllerBase
    {
        private readonly IMessageRepository _messageRepository;
        private readonly IDataUtilisateurRepository<Utilisateur> _userRepository;

        public MessagesController(IMessageRepository messageRepository, IDataUtilisateurRepository<Utilisateur> userRepository)
        {
            _messageRepository = messageRepository;
            _userRepository = userRepository;
        }

        [HttpGet("conversations/{userId}")]
        public async Task<ActionResult<IEnumerable<object>>> GetConversations(int userId)
        {
            var conversations = await _messageRepository.GetConversationsByUserIdAsync(userId);
            
            var result = conversations.Select(c => 
            {
                var interlocuteurId = c.Idutilisateurexpediteur == userId ? c.Idutilisateurreceveur : c.Idutilisateurexpediteur;
                var interlocuteurNom = c.Idutilisateurexpediteur == userId 
                    ? c.IdutilisateurreceveurNavigation?.Pseudonyme 
                    : c.IdutilisateurexpediteurNavigation?.Pseudonyme;

                return new
                {
                    InterlocuteurId = interlocuteurId,
                    InterlocuteurNom = interlocuteurNom ?? "Inconnu",
                    DateDernierMessage = c.IddateNavigation?.Date1?.ToString("dd/MM/yyyy") ?? "",
                    DernierMessage = c.Contenumessage,
                    NonLu = false
                };
            });

            return Ok(result);
        }

        [HttpGet("chat/{userId}/{interlocuteurId}")]
        public async Task<ActionResult<object>> GetChat(int userId, int interlocuteurId)
        {
            var chatMessages = await _messageRepository.GetChatAsync(userId, interlocuteurId);

            var messages = chatMessages.Select(m => new
            {
                Id = m.Idmessage,
                ExpediteurId = m.Idutilisateurexpediteur,
                Contenu = m.Contenumessage,
                DateEnvoi = m.IddateNavigation?.Date1?.ToString("dd/MM/yyyy") ?? ""
            }).ToList();

            var interlocutor = await _userRepository.GetByIdAsync(interlocuteurId);
            string pseudonyme = interlocutor?.Pseudonyme ?? "Inconnu";

            var result = new
            {
                Messages = messages,
                Interlocuteur = new { Pseudonyme = pseudonyme }
            };

            return Ok(result);
        }

        public class PostMessageDto
        {
            public int ExpediteurId { get; set; }
            public int DestinataireId { get; set; }
            public string Contenu { get; set; }
        }

        [HttpPost]
        public async Task<ActionResult> PostMessage([FromBody] PostMessageDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Contenu))
                return BadRequest("Le contenu ne peut pas être vide.");

            var message = new Message
            {
                Idutilisateurexpediteur = dto.ExpediteurId,
                Idutilisateurreceveur = dto.DestinataireId,
                Contenumessage = dto.Contenu
            };

            await _messageRepository.AddMessageAsync(message);
            return Ok();
        }
    }
}
