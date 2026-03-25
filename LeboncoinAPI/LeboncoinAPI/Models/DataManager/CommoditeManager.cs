using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
public class CommoditeManager : ICommoditeRepository
{
    private readonly LeboncoinDBContext _dbContext;

    public CommoditeManager(LeboncoinDBContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<IEnumerable<Commodite>> GetAllAsync()
    {
        return await _dbContext.Commodites
            .Include(c => c.IdcategorieNavigation)
            .ToListAsync();
    }

    public async Task<Commodite?> GetByIdAsync(int id)
    {
        return await _dbContext.Commodites.FindAsync(id);
    }
}