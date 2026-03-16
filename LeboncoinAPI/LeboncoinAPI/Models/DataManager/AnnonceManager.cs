using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.DataManager;

public class AnnonceManager : IAnnonceRepository
{
    private readonly LeboncoinDBContext _dbContext;

    public AnnonceManager(LeboncoinDBContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<IEnumerable<Annonce>> GetAllAsync()
    {
        return await _dbContext.Annonces.ToListAsync();
    }

    public async Task<Annonce?> GetByIdAsync(int id)
    {
        return await _dbContext.Annonces
            .FirstOrDefaultAsync(a => a.Idannonce == id);
    }

    public async Task<IEnumerable<AnnonceSearchResultDto>> GetByLocalisationAsync(string query)
    {
        var q = query?.Trim() ?? string.Empty;

        var annonces = await _dbContext.Annonces
            .Include(a => a.IdadresseNavigation)
                .ThenInclude(adr => adr.IdvilleNavigation)
                    .ThenInclude(v => v.IddepartementNavigation)
            .Include(a => a.IdtypehebergementNavigation)
            .Include(a => a.IddateNavigation)
            .Where(a =>
                string.IsNullOrEmpty(q) ||
                (a.IdadresseNavigation.IdvilleNavigation.Nomville != null &&
                 a.IdadresseNavigation.IdvilleNavigation.Nomville.ToLower().Contains(q.ToLower())) ||
                (a.IdadresseNavigation.IdvilleNavigation.Codepostal != null &&
                 a.IdadresseNavigation.IdvilleNavigation.Codepostal.ToLower().Contains(q.ToLower())) ||
                (a.IdadresseNavigation.IdvilleNavigation.IddepartementNavigation.Nomdepartement != null &&
                 a.IdadresseNavigation.IdvilleNavigation.IddepartementNavigation.Nomdepartement.ToLower().Contains(q.ToLower())) ||
                (a.IdadresseNavigation.IdvilleNavigation.IddepartementNavigation.Numerodepartement != null &&
                 a.IdadresseNavigation.IdvilleNavigation.IddepartementNavigation.Numerodepartement.ToLower().Contains(q.ToLower()))
            )
            .ToListAsync();

        return annonces.Select(a => new AnnonceSearchResultDto
        {
            Idannonce = a.Idannonce,
            Titreannonce = a.Titreannonce,
            TypeHebergement = a.IdtypehebergementNavigation?.Nomtypehebergement,
            Adresse = FormatAdresse(a.IdadresseNavigation),
            Nomville = a.IdadresseNavigation?.IdvilleNavigation?.Nomville,
            Codepostal = a.IdadresseNavigation?.IdvilleNavigation?.Codepostal,
            DateDepot = a.IddateNavigation?.Date1,
            Prixnuitee = a.Prixnuitee,
            Lienphoto = a.Lienphoto,
        });
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

    private static string? FormatAdresse(Adresse? adresse)
    {
        if (adresse == null) return null;

        var parts = new List<string>();
        if (adresse.Numerorue.HasValue) parts.Add(adresse.Numerorue.Value.ToString());
        if (!string.IsNullOrWhiteSpace(adresse.Nomrue)) parts.Add(adresse.Nomrue);

        return parts.Count > 0 ? string.Join(" ", parts) : null;
    }
}