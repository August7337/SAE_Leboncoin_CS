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
        return await _dbContext.Annonces
            .Include(a => a.Photos)
            .Include(a => a.IdadresseNavigation)
                .ThenInclude(adr => adr.IdvilleNavigation)
            .Include(a => a.IdtypehebergementNavigation)
            .ToListAsync();
    }

    public async Task<Annonce?> GetByIdAsync(int id)
    {
        return await _dbContext.Annonces
            .Include(a => a.Photos)
            .Include(a => a.IdadresseNavigation)
                .ThenInclude(adr => adr.IdvilleNavigation)
            .Include(a => a.IdtypehebergementNavigation)
            .Include(a => a.Idcommodites)
                .ThenInclude(c => c.IdcategorieNavigation)
            .Include(a => a.IdutilisateurNavigation)
                .ThenInclude(u => u.IddateNavigation)
            .Include(a => a.IdutilisateurNavigation)
                .ThenInclude(u => u.Annonces)
            .Include(a => a.IdutilisateurNavigation)
                .ThenInclude(u => u.Avis)
            .Include(a => a.IdheurearriveeNavigation)
            .Include(a => a.IdheuredepartNavigation)
            .Include(a => a.Reservations)
                .ThenInclude(r => r.IddatedebutreservationNavigation)
            .Include(a => a.Reservations)
                .ThenInclude(r => r.IddatefinreservationNavigation)
            .FirstOrDefaultAsync(a => a.Idannonce == id);
    }

    public async Task<IEnumerable<AnnonceSearchResultDto>> GetSimilairesAsync(int id)
    {
        var similaires = await _dbContext.Annonces
            .Where(a => a.IdannonceAs.Any(r => r.Idannonce == id)
                     || a.IdannonceBs.Any(r => r.Idannonce == id))
            .Include(a => a.Photos)
            .Include(a => a.IdadresseNavigation)
                .ThenInclude(adr => adr.IdvilleNavigation)
            .Include(a => a.IdtypehebergementNavigation)
            .Take(6)
            .ToListAsync();

        return similaires.Select(a => new AnnonceSearchResultDto
        {
            Idannonce = a.Idannonce,
            Titreannonce = a.Titreannonce,
            TypeHebergement = a.IdtypehebergementNavigation?.Nomtypehebergement,
            Nomville = a.IdadresseNavigation?.IdvilleNavigation?.Nomville,
            Codepostal = a.IdadresseNavigation?.IdvilleNavigation?.Codepostal,
            Prixnuitee = a.Prixnuitee,
            Photos = a.Photos.Select(p => new Photo
            {
                Idphoto = p.Idphoto,
                Idannonce = p.Idannonce,
                Lienphoto = p.Lienphoto
            }).ToList(),
        });
    }

    public async Task<IEnumerable<AnnonceSearchResultDto>> GetByLocalisationAsync(
        string query,
        decimal? minPrice = null,
        decimal? maxPrice = null,
        int? nbChambres = null,
        List<int>? typeHebergementIds = null,
        DateTime? dateArrivee = null,
        DateTime? dateDepart = null,
        List<int>? commoditeIds = null)
    {
        var q = query?.Trim() ?? string.Empty;

        var queryable = _dbContext.Annonces
            .Include(a => a.IdadresseNavigation)
                .ThenInclude(adr => adr.IdvilleNavigation)
                    .ThenInclude(v => v.IddepartementNavigation)
            .Include(a => a.IdtypehebergementNavigation)
            .Include(a => a.IddateNavigation)
            .Include(a => a.Idcommodites)
            .Include(a => a.Photos)
            .AsQueryable();

        // Filtrage par localisation
        if (!string.IsNullOrEmpty(q))
        {
            queryable = queryable.Where(a =>
                (a.IdadresseNavigation.IdvilleNavigation.Nomville != null &&
                 a.IdadresseNavigation.IdvilleNavigation.Nomville.ToLower().StartsWith(q.ToLower())) ||
                (a.IdadresseNavigation.IdvilleNavigation.Codepostal != null &&
                 a.IdadresseNavigation.IdvilleNavigation.Codepostal.ToLower().StartsWith(q.ToLower()))
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

        // Filtre Commodités (Doit avoir TOUTES les commodités sélectionnées)
        if (commoditeIds != null && commoditeIds.Any())
        {
            foreach (var commoditeId in commoditeIds)
            {
                queryable = queryable.Where(a => a.Idcommodites.Any(c => c.Idcommodite == commoditeId));
            }
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
            Capacite = a.Capacite,
            Nombreetoilesleboncoin = a.Nombreetoilesleboncoin,
            Photos = a.Photos.Select(p => new Photo
            {
                Idphoto = p.Idphoto,
                Idannonce = p.Idannonce,
                Lienphoto = p.Lienphoto
            }).ToList(),
        });
    }

    public async Task<IEnumerable<AnnonceSearchResultDto>> GetByUserIdAsync(int userId)
    {
        var annonces = await _dbContext.Annonces
            .Where(a => a.Idutilisateur == userId)
            .Include(a => a.Photos)
            .Include(a => a.IdadresseNavigation)
                .ThenInclude(adr => adr.IdvilleNavigation)
            .Include(a => a.IdtypehebergementNavigation)
            .ToListAsync();

        return annonces.Select(a => new AnnonceSearchResultDto
        {
            Idannonce = a.Idannonce,
            Titreannonce = a.Titreannonce,
            TypeHebergement = a.IdtypehebergementNavigation?.Nomtypehebergement,
            Nomville = a.IdadresseNavigation?.IdvilleNavigation?.Nomville,
            Codepostal = a.IdadresseNavigation?.IdvilleNavigation?.Codepostal,
            Prixnuitee = a.Prixnuitee,
            Capacite = a.Capacite,
            Nombreetoilesleboncoin = a.Nombreetoilesleboncoin,
            Photos = a.Photos.Select(p => new Photo
            {
                Idphoto = p.Idphoto,
                Idannonce = p.Idannonce,
                Lienphoto = p.Lienphoto
            }).ToList(),
        });
    }

    public async Task AddAsync(Annonce entity)
    {
        await _dbContext.Annonces.AddAsync(entity);
        await _dbContext.SaveChangesAsync();
    }

    public async Task UpdateAsync(Annonce entityToUpdate, Annonce entity)
    {
        entityToUpdate.Titreannonce = entity.Titreannonce;
        entityToUpdate.Descriptionannonce = entity.Descriptionannonce;
        entityToUpdate.Prixnuitee = entity.Prixnuitee;
        entityToUpdate.Capacite = entity.Capacite;
        entityToUpdate.Nbchambres = entity.Nbchambres;
        entityToUpdate.Minimumnuitee = entity.Minimumnuitee;
        entityToUpdate.Nombrebebesmax = entity.Nombrebebesmax;
        entityToUpdate.Possibiliteanimaux = entity.Possibiliteanimaux;
        entityToUpdate.Possibilitefumeur = entity.Possibilitefumeur;

        await _dbContext.SaveChangesAsync();
    }

    public async Task DeleteAsync(Annonce entity)
    {
        _dbContext.Annonces.Remove(entity);
        await _dbContext.SaveChangesAsync();
    }

    public async Task<IEnumerable<AnnonceSearchResultDto>> GetFavoritesByUserIdAsync(int userId)
    {
        var annonces = await _dbContext.Annonces
            .Include(a => a.IdadresseNavigation)
                .ThenInclude(adr => adr.IdvilleNavigation)
            .Include(a => a.IdtypehebergementNavigation)
            .Include(a => a.IddateNavigation)
            .Include(a => a.Photos)
            .Where(a => a.Idutilisateurs.Any(u => u.Idutilisateur == userId))
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
            Capacite = a.Capacite,
            Nombreetoilesleboncoin = a.Nombreetoilesleboncoin,
            Photos = a.Photos.Select(p => new Photo
            {
                Idphoto = p.Idphoto,
                Idannonce = p.Idannonce,
                Lienphoto = p.Lienphoto
            }).ToList(),
        });
    }

    public async Task<IEnumerable<int>> GetFavoriteIdsByUserIdAsync(int userId)
    {
        return await _dbContext.Annonces
            .Where(a => a.Idutilisateurs.Any(u => u.Idutilisateur == userId))
            .Select(a => a.Idannonce)
            .ToListAsync();
    }

    public async Task AddFavoriteAsync(int userId, int annonceId)
    {
        var utilisateur = await _dbContext.Utilisateurs.Include(u => u.Idannonces).FirstOrDefaultAsync(u => u.Idutilisateur == userId);
        var annonce = await _dbContext.Annonces.FindAsync(annonceId);

        if (utilisateur != null && annonce != null)
        {
            if (!utilisateur.Idannonces.Any(a => a.Idannonce == annonceId))
            {
                utilisateur.Idannonces.Add(annonce);
                await _dbContext.SaveChangesAsync();
            }
        }
    }

    public async Task RemoveFavoriteAsync(int userId, int annonceId)
    {
        var utilisateur = await _dbContext.Utilisateurs.Include(u => u.Idannonces).FirstOrDefaultAsync(u => u.Idutilisateur == userId);
        var annonce = await _dbContext.Annonces.FindAsync(annonceId);

        if (utilisateur != null && annonce != null)
        {
            var exists = utilisateur.Idannonces.FirstOrDefault(a => a.Idannonce == annonceId);
            if (exists != null)
            {
                utilisateur.Idannonces.Remove(exists);
                await _dbContext.SaveChangesAsync();
            }
        }
    }

    private static string? FormatAdresse(Adresse? adresse)
    {
        if (adresse == null) return null;

        var parts = new List<string>();
        if (adresse.Numerorue.HasValue) parts.Add(adresse.Numerorue.Value.ToString());
        if (!string.IsNullOrWhiteSpace(adresse.Nomrue)) parts.Add(adresse.Nomrue);

        return parts.Count > 0 ? string.Join(" ", parts) : null;
    }

    public async Task<Photo> AddPhotoAsync(int annonceId, string url)
    {
        var photo = new Photo { Idannonce = annonceId, Lienphoto = url };
        await _dbContext.Photos.AddAsync(photo);
        await _dbContext.SaveChangesAsync();
        return photo;
    }

    public async Task RemovePhotoAsync(int photoId)
    {
        var photo = await _dbContext.Photos.FindAsync(photoId);
        if (photo != null)
        {
            _dbContext.Photos.Remove(photo);
            await _dbContext.SaveChangesAsync();
        }
    }

    public async Task SetIndisponibleAsync(int annonceId, DateOnly startDate, DateOnly endDate)
    {
        if (startDate > endDate) return;

        var datesToProcess = new List<DateOnly>();
        for (var date = startDate; date <= endDate; date = date.AddDays(1))
        {
            datesToProcess.Add(date);
        }

        foreach (var currentDate in datesToProcess)
        {
            var dateRecord = await _dbContext.Dates.FirstOrDefaultAsync(d => d.Date1 == currentDate);
            if (dateRecord == null)
            {
                dateRecord = new Date { Date1 = currentDate };
                _dbContext.Dates.Add(dateRecord);
                await _dbContext.SaveChangesAsync();
            }

            var relier = await _dbContext.Reliers.FirstOrDefaultAsync(r => r.Idannonce == annonceId && r.Iddate == dateRecord.Iddate);
            if (relier == null)
            {
                relier = new Relier { Idannonce = annonceId, Iddate = dateRecord.Iddate, Estdisponible = false };
                _dbContext.Reliers.Add(relier);
            }
            else
            {
                relier.Estdisponible = false;
            }
        }
        await _dbContext.SaveChangesAsync();
    }

    public async Task<IEnumerable<DateOnly>> GetIndisponibilitesAsync(int annonceId)
    {
        return await _dbContext.Reliers
            .Include(r => r.IddateNavigation)
            .Where(r => r.Idannonce == annonceId && r.Estdisponible == false && r.IddateNavigation.Date1 != null)
            .Select(r => r.IddateNavigation.Date1.Value)
            .ToListAsync();
    }

    public async Task RemoveIndisponibiliteAsync(int annonceId, DateOnly date)
    {
        var dateRecord = await _dbContext.Dates.FirstOrDefaultAsync(d => d.Date1 == date);
        if (dateRecord != null)
        {
            var relier = await _dbContext.Reliers.FirstOrDefaultAsync(r => r.Idannonce == annonceId && r.Iddate == dateRecord.Iddate);
            if (relier != null)
            {
                _dbContext.Reliers.Remove(relier);
                await _dbContext.SaveChangesAsync();
            }
        }
    }
}