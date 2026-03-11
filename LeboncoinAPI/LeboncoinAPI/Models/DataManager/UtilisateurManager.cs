using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Formats.Asn1;
using System.Threading.Tasks;

namespace LeboncoinAPI.Models.DataManager;

public class UtilisateurManager : IDataUtilisateurRepository<Utilisateur>
{
    private readonly LeboncoinDBContext _dbContext;

    public UtilisateurManager(LeboncoinDBContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<IEnumerable<Utilisateur>> GetAllAsync()
    {
        // On retourne la liste de tous les utilisateurs
        return await _dbContext.Utilisateurs.ToListAsync();
    }

    public async Task<Utilisateur?> GetByIdAsync(int id)
    {
        // FindAsync est optimisé pour la recherche par clé primaire
        return await _dbContext.Utilisateurs.FindAsync(id);
    }

    public async Task AddAsync(Utilisateur entity)
    {
        await _dbContext.Utilisateurs.AddAsync(entity);
        await _dbContext.SaveChangesAsync();
    }

    public async Task UpdateAsync(Utilisateur entityToUpdate, Utilisateur entity)
    {
        // Copie automatique des nouvelles valeurs (entity) vers l'entité trackée (entityToUpdate)
        _dbContext.Entry(entityToUpdate).CurrentValues.SetValues(entity);
        await _dbContext.SaveChangesAsync();
    }

    public async Task DeleteAsync(Utilisateur entity)
    {
        _dbContext.Utilisateurs.Remove(entity);
        await _dbContext.SaveChangesAsync();
    }

    public async Task<Utilisateur?> GetByEmailAsync(string email)
    {
        return await _dbContext.Utilisateurs.FirstOrDefaultAsync(u=> u.Email.ToLower() == email.ToLower());
    }
}