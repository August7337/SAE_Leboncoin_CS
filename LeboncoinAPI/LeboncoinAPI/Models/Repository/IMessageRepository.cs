using LeboncoinAPI.Models.EntityFramework;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace LeboncoinAPI.Models.Repository
{
    public interface IMessageRepository
    {
        Task<IEnumerable<Message>> GetConversationsByUserIdAsync(int userId);
        Task<IEnumerable<Message>> GetChatAsync(int userId, int interlocuteurId);
        Task AddMessageAsync(Message message);
    }
}
