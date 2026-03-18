using LeboncoinAPI.Models.EntityFramework;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LeboncoinAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProfessionnelsController : ControllerBase
    {
        private readonly LeboncoinDBContext _context;

        public ProfessionnelsController(LeboncoinDBContext context)
        {
            _context = context;
        }

        // GET: api/Professionnels
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Professionnel>>> GetProfessionnels()
        {
            return await _context.Professionnels.ToListAsync();
        }

        // GET: api/Professionnels/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Professionnel>> GetProfessionnel(int id)
        {
            var professionnel = await _context.Professionnels.FindAsync(id);

            if (professionnel == null)
            {
                return NotFound();
            }

            return professionnel;
        }

        // PUT: api/Professionnels/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProfessionnel(int id, Professionnel professionnel)
        {
            if (id != professionnel.Idutilisateur)
            {
                return BadRequest();
            }

            _context.Entry(professionnel).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProfessionnelExists(id))
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

        // POST: api/Professionnels
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Professionnel>> PostProfessionnel(Professionnel professionnel)
        {
            _context.Professionnels.Add(professionnel);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                // Check if it's a unique constraint violation (Postgres code 23505)
                if (ex.InnerException is PostgresException pgEx && pgEx.SqlState == "23505")
                {
                    if (pgEx.ConstraintName == "professionnel_numsiret_key")
                    {
                        return Conflict(new
                        {
                            target = "numsiret",
                            message = "Ce numéro SIRET est déjà utilisé par un autre compte."
                        });
                    }
                    // Add other checks here (e.g., email_key) if needed
                }
                return BadRequest("Une erreur est survenue lors de l'enregistrement.");
            }

            return CreatedAtAction("GetProfessionnel", new { id = professionnel.Idutilisateur }, professionnel);
        }

        // DELETE: api/Professionnels/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProfessionnel(int id)
        {
            var professionnel = await _context.Professionnels.FindAsync(id);
            if (professionnel == null)
            {
                return NotFound();
            }

            _context.Professionnels.Remove(professionnel);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ProfessionnelExists(int id)
        {
            return _context.Professionnels.Any(e => e.Idutilisateur == id);
        }
    }
}
