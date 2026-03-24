using LeboncoinAPI.Models.EntityFramework;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace LeboncoinAPI.Models.Repository;

public interface IReservationRepository : IDataRepository<Reservation>
{
    Task<IEnumerable<Reservation>> GetByUserIdAsync(int userId);
}
