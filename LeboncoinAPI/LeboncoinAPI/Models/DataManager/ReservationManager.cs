using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace LeboncoinAPI.Models.DataManager;

public class ReservationManager : IDataRepository<Reservation>
{
    private readonly LeboncoinDBContext _dbContext;

    public ReservationManager(LeboncoinDBContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<IEnumerable<Reservation>> GetAllAsync()
    {
        return await _dbContext.Reservations
            .Include(r => r.Client)
            .Include(r => r.AnnonceConcernee)
            .ToListAsync();
    }

    public async Task<Reservation?> GetByIdAsync(int id)
    {
        return await _dbContext.Reservations
            .Include(r => r.Client)
            .Include(r => r.AnnonceConcernee)
            .FirstOrDefaultAsync(r => r.ReservationId == id);
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