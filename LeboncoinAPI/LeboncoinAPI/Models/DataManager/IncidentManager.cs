using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.DataManager;

public class IncidentManager : IIncidentRepository
{
    private readonly LeboncoinDBContext _dbContext;

    public IncidentManager(LeboncoinDBContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<IEnumerable<Incident>> GetAllAsync()
    {
        return await BaseQuery()
            .OrderByDescending(i => i.Idincident)
            .ToListAsync();
    }

    public async Task<Incident?> GetByIdAsync(int id)
    {
        return await BaseQuery()
            .FirstOrDefaultAsync(i => i.Idincident == id);
    }

    public async Task<IEnumerable<Incident>> GetByUtilisateurAsync(int idUtilisateur)
    {
        return await BaseQuery()
            .Where(i => i.Idutilisateur == idUtilisateur)
            .OrderByDescending(i => i.Idincident)
            .ToListAsync();
    }

    public async Task<IEnumerable<Incident>> GetByProprietaireAsync(int idProprietaire)
    {
        return await BaseQuery()
            .Where(i => i.IdreservationNavigation.IdannonceNavigation.Idutilisateur == idProprietaire)
            .OrderByDescending(i => i.Idincident)
            .ToListAsync();
    }

    public async Task<IEnumerable<Incident>> GetByReservationAsync(int idReservation)
    {
        return await BaseQuery()
            .Where(i => i.Idreservation == idReservation)
            .OrderByDescending(i => i.Idincident)
            .ToListAsync();
    }

    public async Task AddAsync(Incident incident)
    {
        _dbContext.Incidents.Add(incident);
        await _dbContext.SaveChangesAsync();
    }

    public async Task UpdateAsync(Incident incident)
    {
        _dbContext.Incidents.Update(incident);
        await _dbContext.SaveChangesAsync();
    }

    private IQueryable<Incident> BaseQuery()
    {
        return _dbContext.Incidents
            .Include(i => i.StatutIncidentNavigation)
            .Include(i => i.IddateNavigation)
            .Include(i => i.IdreservationNavigation)
                .ThenInclude(r => r.IdannonceNavigation)
            .Include(i => i.IdutilisateurNavigation)
            .Include(i => i.Photos)
            .Include(i => i.Idcompensations);
    }
}
