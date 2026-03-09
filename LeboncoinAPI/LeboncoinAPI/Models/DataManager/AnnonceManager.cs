using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace LeboncoinAPI.Models.DataManager;

public class AnnonceManager : IDataRepository<Annonce>
{
    private readonly LeboncoinDBContext _dbContext;

    public AnnonceManager(LeboncoinDBContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<IEnumerable<Annonce>> GetAllAsync()
    {
        // Utilisation de .Include() si tu souhaites charger directement les données liées 
        // comme l'auteur ou l'adresse, utile pour éviter le N+1 query problem.
        return await _dbContext.Annonces
            .Include(a => a.UtilisateurAuteur)
            .Include(a => a.AdresseAnnonce)
            .ToListAsync();
    }

    public async Task<Annonce?> GetByIdAsync(int id)
    {
        // Pour GetById avec Include, on utilise FirstOrDefaultAsync plutôt que FindAsync
        return await _dbContext.Annonces
            .Include(a => a.UtilisateurAuteur)
            .Include(a => a.AdresseAnnonce)
            .FirstOrDefaultAsync(a => a.AnnonceId == id);
    }

    public async Task AddAsync(Annonce entity)
    {
        await _dbContext.Annonces.AddAsync(entity);
        await _dbContext.SaveChangesAsync();
    }

    public async Task UpdateAsync(Annonce entityToUpdate, Annonce entity)
    {
        _dbContext.Entry(entityToUpdate).CurrentValues.SetValues(entity);
        await _dbContext.SaveChangesAsync();
    }

    public async Task DeleteAsync(Annonce entity)
    {
        _dbContext.Annonces.Remove(entity);
        await _dbContext.SaveChangesAsync();
    }
}