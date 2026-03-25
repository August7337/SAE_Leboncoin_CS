using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LeboncoinAPI.Models.DataManager
{
    public class MessageManager : IMessageRepository
    {
        private readonly LeboncoinDBContext _dbContext;

        public MessageManager(LeboncoinDBContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<IEnumerable<Message>> GetConversationsByUserIdAsync(int userId)
        {
            var messages = await _dbContext.Messages
                .Include(m => m.IdutilisateurexpediteurNavigation)
                .Include(m => m.IdutilisateurreceveurNavigation)
                .Include(m => m.IddateNavigation)
                .Where(m => m.Idutilisateurexpediteur == userId || m.Idutilisateurreceveur == userId)
                .ToListAsync();

            var latestMessages = messages
                .GroupBy(m => m.Idutilisateurexpediteur == userId ? m.Idutilisateurreceveur : m.Idutilisateurexpediteur)
                .Select(g => g.OrderByDescending(m => m.Idmessage).First())
                .OrderByDescending(m => m.Idmessage)
                .ToList();

            return latestMessages;
        }

        public async Task<IEnumerable<Message>> GetChatAsync(int userId, int interlocuteurId)
        {
            return await _dbContext.Messages
                .Include(m => m.IdutilisateurexpediteurNavigation)
                .Include(m => m.IdutilisateurreceveurNavigation)
                .Include(m => m.IddateNavigation)
                .Where(m => 
                    (m.Idutilisateurexpediteur == userId && m.Idutilisateurreceveur == interlocuteurId) ||
                    (m.Idutilisateurexpediteur == interlocuteurId && m.Idutilisateurreceveur == userId))
                .OrderBy(m => m.Idmessage)
                .ToListAsync();
        }

        public async Task AddMessageAsync(Message message)
        {
            DateOnly today = DateOnly.FromDateTime(DateTime.UtcNow);
            var dateRecord = await _dbContext.Dates.FirstOrDefaultAsync(d => d.Date1 == today);
            if (dateRecord == null)
            {
                dateRecord = new Date { Date1 = today };
                _dbContext.Dates.Add(dateRecord);
                await _dbContext.SaveChangesAsync();
            }

            message.Iddate = dateRecord.Iddate;
            
            await _dbContext.Messages.AddAsync(message);
            await _dbContext.SaveChangesAsync();
        }
    }
}
