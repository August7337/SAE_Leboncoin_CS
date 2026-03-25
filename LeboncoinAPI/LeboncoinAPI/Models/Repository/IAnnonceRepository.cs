using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;

namespace LeboncoinAPI.Models.Repository;

public interface IAnnonceRepository : IDataRepository<Annonce>
{
    Task<IEnumerable<Annonce>> GetAllAsync();
    Task<IEnumerable<AnnonceSearchResultDto>> GetSimilairesAsync(int id);
    Task<IEnumerable<AnnonceSearchResultDto>> GetByLocalisationAsync(
        string query,
        decimal? minPrice = null,
        decimal? maxPrice = null,
        int? nbChambres = null,
        List<int>? typeHebergementIds = null,
        DateTime? dateArrivee = null,
        DateTime? dateDepart = null,
        List<int>? commoditeIds = null);

    Task<IEnumerable<AnnonceSearchResultDto>> GetFavoritesByUserIdAsync(int userId);
    Task<IEnumerable<int>> GetFavoriteIdsByUserIdAsync(int userId);
    Task AddFavoriteAsync(int userId, int annonceId);
    Task RemoveFavoriteAsync(int userId, int annonceId);
    Task<IEnumerable<AnnonceSearchResultDto>> GetByUserIdAsync(int userId);

    // Photos
    Task<Photo> AddPhotoAsync(int annonceId, string url);
    Task RemovePhotoAsync(int photoId);

    // Indisponibilités
    Task SetIndisponibleAsync(int annonceId, DateOnly startDate, DateOnly endDate);
    Task<IEnumerable<DateOnly>> GetIndisponibilitesAsync(int annonceId);
    Task RemoveIndisponibiliteAsync(int annonceId, DateOnly date);
}
