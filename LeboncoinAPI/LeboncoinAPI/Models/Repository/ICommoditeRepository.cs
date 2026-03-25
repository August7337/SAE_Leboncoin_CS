using LeboncoinAPI.Models.EntityFramework;

public interface ICommoditeRepository
{
    Task<IEnumerable<Commodite>> GetAllAsync();
    Task<Commodite?> GetByIdAsync(int id);
}