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

    public async Task<IEnumerable<AnnonceSearchResultDto>> GetByLocalisationAsync(
        string query,
        decimal? minPrice = null,
        decimal? maxPrice = null,
        int? nbChambres = null,
        List<int>? typeHebergementIds = null,
        DateTime? dateArrivee = null,
        DateTime? dateDepart = null)
    {
        var q = query?.Trim() ?? string.Empty;

        var queryable = _dbContext.Annonces
            .Include(a => a.IdadresseNavigation)
                .ThenInclude(adr => adr.IdvilleNavigation)
                    .ThenInclude(v => v.IddepartementNavigation)
            .Include(a => a.IdtypehebergementNavigation)
            .Include(a => a.IddateNavigation)
            .AsQueryable();

        // Filtrage par localisation
        if (!string.IsNullOrEmpty(q))
        {
            queryable = queryable.Where(a =>
                (a.IdadresseNavigation.IdvilleNavigation.Nomville != null &&
                 a.IdadresseNavigation.IdvilleNavigation.Nomville.ToLower().Contains(q.ToLower())) ||
                (a.IdadresseNavigation.IdvilleNavigation.Codepostal != null &&
                 a.IdadresseNavigation.IdvilleNavigation.Codepostal.ToLower().Contains(q.ToLower())) ||
                (a.IdadresseNavigation.IdvilleNavigation.IddepartementNavigation.Nomdepartement != null &&
                 a.IdadresseNavigation.IdvilleNavigation.IddepartementNavigation.Nomdepartement.ToLower().Contains(q.ToLower())) ||
                (a.IdadresseNavigation.IdvilleNavigation.IddepartementNavigation.Numerodepartement != null &&
                 a.IdadresseNavigation.IdvilleNavigation.IddepartementNavigation.Numerodepartement.ToLower().Contains(q.ToLower()))
            );
        }

        // Filtre Prix
        if (minPrice.HasValue)
        {
            queryable = queryable.Where(a => a.Prixnuitee >= minPrice.Value);
        }
        if (maxPrice.HasValue)
        {
            queryable = queryable.Where(a => a.Prixnuitee <= maxPrice.Value);
        }

        // Filtre Chambres
        if (nbChambres.HasValue && nbChambres.Value > 0)
        {
            if (nbChambres.Value >= 6)
                queryable = queryable.Where(a => a.Nbchambres >= 6);
            else
                queryable = queryable.Where(a => a.Nbchambres == nbChambres.Value);
        }

        // Filtre Type d'hébergement
        if (typeHebergementIds != null && typeHebergementIds.Any())
        {
            queryable = queryable.Where(a => typeHebergementIds.Contains(a.Idtypehebergement));
        }

        // Filtrage par dates (basique : exclure les annonces ayant une réservation qui chevauche)
        if (dateArrivee.HasValue && dateDepart.HasValue)
        {
            var start = DateOnly.FromDateTime(dateArrivee.Value);
            var end = DateOnly.FromDateTime(dateDepart.Value);

            queryable = queryable.Where(a => !_dbContext.Reservations.Any(r =>
                r.Idannonce == a.Idannonce &&
                r.IddatedebutreservationNavigation.Date1.HasValue &&
                r.IddatefinreservationNavigation.Date1.HasValue &&
                ((start >= r.IddatedebutreservationNavigation.Date1.Value && start < r.IddatefinreservationNavigation.Date1.Value) ||
                 (end > r.IddatedebutreservationNavigation.Date1.Value && end <= r.IddatefinreservationNavigation.Date1.Value) ||
                 (start <= r.IddatedebutreservationNavigation.Date1.Value && end >= r.IddatefinreservationNavigation.Date1.Value))
            ));
        }

        var annonces = await queryable.ToListAsync();

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