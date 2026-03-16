using LeboncoinAPI.Models.EntityFramework;

namespace LeboncoinAPI.Models.Repository;

public interface IAnnonceRepository : IDataRepository<Annonce>
{
    Task<IEnumerable<AnnonceSearchResultDto>> GetByLocalisationAsync(string query);
}
