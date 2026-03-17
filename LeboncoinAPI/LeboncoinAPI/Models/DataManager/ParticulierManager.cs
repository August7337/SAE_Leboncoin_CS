using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
using LeboncoinAPI.Models.DTOs;
namespace LeboncoinAPI.Models.DataManager
{
    public class ParticulierManager
    {
        private readonly LeboncoinDBContext _context;

        public ParticulierManager(LeboncoinDBContext context)
        {
            _context = context;
        }

        public async Task<bool> CreateParticulierAsync(ParticulierDTO dto)
        {
         
            var dateEntity = await _context.Dates
                .FirstOrDefaultAsync(d => d.Date1 == DateOnly.FromDateTime(dto.DateNaissance));

           
            if (dateEntity == null)
            {
                dateEntity = new Date
                {
                    Date1 = DateOnly.FromDateTime(dto.DateNaissance)
                };
                _context.Dates.Add(dateEntity);
                await _context.SaveChangesAsync(); 
            }

         
            var nouveauParticulier = new Particulier
            {
                Idutilisateur = dto.Idutilisateur,
                Nomutilisateur = dto.Nomutilisateur,
                Prenomutilisateur = dto.Prenomutilisateur,
                Civilite = dto.Civilite,
                Iddate = dateEntity.Iddate 
            };

            _context.Particuliers.Add(nouveauParticulier);
            return await _context.SaveChangesAsync() > 0;
        }
    }
}
