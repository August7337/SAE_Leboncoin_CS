using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.DTOs;
namespace LeboncoinAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ParticuliersController : ControllerBase
    {
        private readonly LeboncoinDBContext _context;

        public ParticuliersController(LeboncoinDBContext context)
        {
            _context = context;
        }

        // GET: api/Particuliers
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Particulier>>> GetParticuliers()
        {
            return await _context.Particuliers.ToListAsync();
        }

        // GET: api/Particuliers/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Particulier>> GetParticulier(int id)
        {
            var particulier = await _context.Particuliers.FindAsync(id);

            if (particulier == null)
            {
                return NotFound();
            }

            return particulier;
        }

        // PUT: api/Particuliers/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutParticulier(int id, Particulier particulier)
        {
            if (id != particulier.Idutilisateur)
            {
                return BadRequest();
            }

            _context.Entry(particulier).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ParticulierExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Particuliers
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<IActionResult> PostParticulier([FromBody] ParticulierDTO dto)
        {
            if (dto == null) return BadRequest();

            try
            {
                var result = await _manager.CreateParticulierAsync(dto);
                if (result) return Ok(new { message = "Profil créé" });
                return BadRequest("Échec de l'insertion.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Erreur : {ex.Message}");
            }
        }

        // DELETE: api/Particuliers/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteParticulier(int id)
        {
            var particulier = await _context.Particuliers.FindAsync(id);
            if (particulier == null)
            {
                return NotFound();
            }

            _context.Particuliers.Remove(particulier);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ParticulierExists(int id)
        {
            return _context.Particuliers.Any(e => e.Idutilisateur == id);
        }
    }
}
