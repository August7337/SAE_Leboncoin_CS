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
}
