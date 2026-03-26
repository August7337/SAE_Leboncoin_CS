using LeboncoinAPI.Models.EntityFramework;

namespace LeboncoinAPI.Models.Repository;

public interface IIncidentRepository
{
    Task<IEnumerable<Incident>> GetAllAsync();
    Task<Incident?> GetByIdAsync(int id);
    Task<IEnumerable<Incident>> GetByUtilisateurAsync(int idUtilisateur);
    Task<IEnumerable<Incident>> GetByProprietaireAsync(int idProprietaire);
    Task<IEnumerable<Incident>> GetByReservationAsync(int idReservation);
    Task AddAsync(Incident incident);
    Task UpdateAsync(Incident incident);
}
