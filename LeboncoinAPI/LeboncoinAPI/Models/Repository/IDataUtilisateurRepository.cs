using System.Collections.Generic;
using System.Threading.Tasks;

namespace LeboncoinAPI.Models.Repository;

public interface IDataUtilisateurRepository<TEntity>
{
    Task<IEnumerable<TEntity>> GetAllAsync();
    Task<TEntity?> GetByIdAsync(int id);
    Task<TEntity?> GetByEmailAsync(string email);
    Task AddAsync(TEntity entity);
    Task UpdateAsync(TEntity entityToUpdate, TEntity entity);
    Task DeleteAsync(TEntity entity);
}