using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class ReservationsController : ControllerBase
{
    private readonly IReservationRepository _dataRepository;
    private readonly LeboncoinDBContext _dbContext;

    public ReservationsController(IReservationRepository dataRepository, LeboncoinDBContext dbContext)
    {
        _dataRepository = dataRepository;
        _dbContext = dbContext;
    }

    // GET: api/Reservations
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Reservation>>> GetReservations()
    {
        return Ok(await _dataRepository.GetAllAsync());
    }

    // GET: api/Reservations/5
    [HttpGet("{id}")]
    public async Task<ActionResult<Reservation>> GetReservation(int id)
    {
        var reservation = await _dataRepository.GetByIdAsync(id);

        if (reservation == null)
        {
            return NotFound();
        }

        return Ok(reservation);
    }

    // GET: api/Reservations/user/5
    [HttpGet("user/{userId}")]
    public async Task<ActionResult<IEnumerable<Reservation>>> GetByUserId(int userId)
    {
        return Ok(await _dataRepository.GetByUserIdAsync(userId));
    }

    // POST: api/Reservations
    [HttpPost]
    public async Task<ActionResult<Reservation>> PostReservation(Reservation reservation)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        await _dataRepository.AddAsync(reservation);

        return CreatedAtAction(nameof(GetReservation), new { id = reservation.Idreservation }, reservation);
    }

    // PUT: api/Reservations/5
    [HttpPut("{id}")]
    public async Task<IActionResult> PutReservation(int id, Reservation reservation)
    {
        if (id != reservation.Idreservation) return BadRequest();

        var reservationToUpdate = await _dbContext.Reservations
            .Include(r => r.IdannonceNavigation)
            .Include(r => r.IdutilisateurNavigation)
            .Include(r => r.IddatedebutreservationNavigation)
            .Include(r => r.IddatefinreservationNavigation)
            .Include(r => r.Inclures)
            .FirstOrDefaultAsync(r => r.Idreservation == id);

        if (reservationToUpdate == null) return NotFound();

        // 1. Calculate supplement if dates changed
        // We assume the incoming 'reservation' object has the NEW desired date values in its navigation properties or we expect the client to send updated IDs (which is hard).
        // A better way: the client sends ISO strings, but the Model expects Date objects.
        // Let's assume the client sends the reservation with updated navigation objects containing Date1.

        var oldStart = reservationToUpdate.IddatedebutreservationNavigation.Date1;
        var oldEnd = reservationToUpdate.IddatefinreservationNavigation.Date1;
        
        // Use the dates from the incoming object if provided, otherwise keep old ones
        var newStart = reservation.IddatedebutreservationNavigation?.Date1 ?? oldStart;
        var newEnd = reservation.IddatefinreservationNavigation?.Date1 ?? oldEnd;

        if (newStart.HasValue && newEnd.HasValue && oldStart.HasValue && oldEnd.HasValue)
        {
            int oldNights = (oldEnd.Value.ToDateTime(TimeOnly.MinValue) - oldStart.Value.ToDateTime(TimeOnly.MinValue)).Days;
            int newNights = (newEnd.Value.ToDateTime(TimeOnly.MinValue) - newStart.Value.ToDateTime(TimeOnly.MinValue)).Days;

            if (newNights > oldNights)
            {
                decimal pricePerNight = reservationToUpdate.IdannonceNavigation.Prixnuitee;
                decimal supplement = (newNights - oldNights) * pricePerNight;

                if (reservationToUpdate.IdutilisateurNavigation.Solde < supplement)
                {
                    return BadRequest("Solde insuffisant pour le supplément.");
                }

                reservationToUpdate.IdutilisateurNavigation.Solde -= supplement;
            }
        }

        // 2. Update dates (Find or Create Date records)
        if (newStart.HasValue && newStart != oldStart)
        {
            var dateRecord = await GetOrCreateDate(newStart.Value);
            reservationToUpdate.Iddatedebutreservation = dateRecord.Iddate;
        }
        if (newEnd.HasValue && newEnd != oldEnd)
        {
            var dateRecord = await GetOrCreateDate(newEnd.Value);
            reservationToUpdate.Iddatefinreservation = dateRecord.Iddate;
        }

        // 3. Update number of people (Inclures)
        if (reservation.Inclures != null && reservation.Inclures.Any())
        {
            foreach (var incomingInclure in reservation.Inclures)
            {
                var existingInclure = reservationToUpdate.Inclures.FirstOrDefault(i => i.Idtypevoyageur == incomingInclure.Idtypevoyageur);
                if (existingInclure != null)
                {
                    existingInclure.Nombrevoyageur = incomingInclure.Nombrevoyageur;
                }
                else
                {
                    reservationToUpdate.Inclures.Add(new Inclure 
                    { 
                        Idreservation = id, 
                        Idtypevoyageur = incomingInclure.Idtypevoyageur, 
                        Nombrevoyageur = incomingInclure.Nombrevoyageur 
                    });
                }
            }
        }

        // 4. Update basic info
        reservationToUpdate.Nomclient = reservation.Nomclient;
        reservationToUpdate.Prenomclient = reservation.Prenomclient;
        reservationToUpdate.Telephoneclient = reservation.Telephoneclient;

        await _dbContext.SaveChangesAsync();

        return NoContent();
    }

    private async Task<Date> GetOrCreateDate(DateOnly dateValue)
    {
        var dateRecord = await _dbContext.Dates.FirstOrDefaultAsync(d => d.Date1 == dateValue);
        if (dateRecord == null)
        {
            dateRecord = new Date { Date1 = dateValue };
            _dbContext.Dates.Add(dateRecord);
            await _dbContext.SaveChangesAsync();
        }
        return dateRecord;
    }

    // DELETE: api/Reservations/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteReservation(int id)
    {
        var reservation = await _dataRepository.GetByIdAsync(id);
        if (reservation == null) return NotFound();

        await _dataRepository.DeleteAsync(reservation);

        return NoContent();
    }
}