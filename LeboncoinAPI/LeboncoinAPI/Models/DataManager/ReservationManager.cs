using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace LeboncoinAPI.Models.DataManager;

public class ReservationManager : IReservationRepository
{
    private readonly LeboncoinDBContext _dbContext;

    public ReservationManager(LeboncoinDBContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<IEnumerable<Reservation>> GetAllAsync()
    {
        return await _dbContext.Reservations
            .ToListAsync();
    }

    public async Task<Reservation?> GetByIdAsync(int id)
    {
        return await _dbContext.Reservations
            .Include(r => r.IdannonceNavigation)
                .ThenInclude(a => a.Photos)
            .Include(r => r.IdannonceNavigation)
                .ThenInclude(a => a.IdadresseNavigation)
                    .ThenInclude(adr => adr.IdvilleNavigation)
            .Include(r => r.IddatedebutreservationNavigation)
            .Include(r => r.IddatefinreservationNavigation)
            .Include(r => r.Inclures)
                .ThenInclude(i => i.IdtypevoyageurNavigation)
            .Include(r => r.Transactions)
            .FirstOrDefaultAsync(r => r.Idreservation == id);
    }

    public async Task<IEnumerable<Reservation>> GetByUserIdAsync(int userId)
    {
        return await _dbContext.Reservations
            .Where(r => r.Idutilisateur == userId)
            .Include(r => r.IdannonceNavigation)
                .ThenInclude(a => a.Photos)
            .Include(r => r.IdannonceNavigation)
                .ThenInclude(a => a.IdadresseNavigation)
                    .ThenInclude(adr => adr.IdvilleNavigation)
            .Include(r => r.IddatedebutreservationNavigation)
            .Include(r => r.IddatefinreservationNavigation)
            .Include(r => r.Inclures)
                .ThenInclude(i => i.IdtypevoyageurNavigation)
            .Include(r => r.Transactions)
            .ToListAsync();
    }

    public async Task AddAsync(Reservation entity)
    {
        await _dbContext.Reservations.AddAsync(entity);
        await _dbContext.SaveChangesAsync();
    }

    public async Task UpdateAsync(Reservation entityToUpdate, Reservation entity)
    {
        _dbContext.Entry(entityToUpdate).CurrentValues.SetValues(entity);
        await _dbContext.SaveChangesAsync();
    }

    public async Task DeleteAsync(Reservation entity)
    {
        _dbContext.Reservations.Remove(entity);
        await _dbContext.SaveChangesAsync();
    }
}