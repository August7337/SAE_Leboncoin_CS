using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Formats.Asn1;
using System.Threading.Tasks;
using BCrypt.Net;
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
      
        return await _dbContext.Utilisateurs.ToListAsync();
    }

    public async Task<Utilisateur?> GetByIdAsync(int id)
    {
        
        return await _dbContext.Utilisateurs.FindAsync(id);
    }

    public async Task AddAsync(Utilisateur entity)
    {
      
        if (entity.IddateNavigation != null)
        {
       
            var today = DateOnly.FromDateTime(DateTime.Now);

            var existingDate = await _dbContext.Dates
                .FirstOrDefaultAsync(d => d.Date1 == today);

            if (existingDate != null)
            {
                entity.IddateNavigation = existingDate;
            }
            else
            {
                entity.IddateNavigation.Date1 = today;
            }
        }

   
        if (entity.IdadresseNavigation?.IdvilleNavigation?.IddepartementNavigation?.IdregionNavigation != null)
        {
            var addr = entity.IdadresseNavigation;
            var ville = addr.IdvilleNavigation;
            var dep = ville.IddepartementNavigation;
            var reg = dep.IdregionNavigation;

          
            var existingReg = await _dbContext.Regions
                .FirstOrDefaultAsync(r => r.Nomregion == reg.Nomregion);
            if (existingReg != null) dep.IdregionNavigation = existingReg;

        
            var existingDep = await _dbContext.Departements
                .FirstOrDefaultAsync(d => d.Numerodepartement == dep.Numerodepartement);
            if (existingDep != null) ville.IddepartementNavigation = existingDep;

            var existingVille = await _dbContext.Villes
                .FirstOrDefaultAsync(v => v.Nomville == ville.Nomville && v.Codepostal == ville.Codepostal);
            if (existingVille != null) addr.IdvilleNavigation = existingVille;
        }
        entity.Password = BCrypt.Net.BCrypt.HashPassword(entity.Password);
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
        return await _dbContext.Utilisateurs.FirstOrDefaultAsync(u => u.Email.ToLower() == email.ToLower());
    }
}