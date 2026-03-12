using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class ReservationsController : ControllerBase
{
    private readonly IDataRepository<Reservation> _dataRepository;

    public ReservationsController(IDataRepository<Reservation> dataRepository)
    {
        _dataRepository = dataRepository;
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

        var reservationToUpdate = await _dataRepository.GetByIdAsync(id);
        if (reservationToUpdate == null) return NotFound();

        await _dataRepository.UpdateAsync(reservationToUpdate, reservation);

        return NoContent();
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