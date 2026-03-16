using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AnnoncesController : ControllerBase
{
    private readonly IAnnonceRepository _annonceRepository;

    public AnnoncesController(IAnnonceRepository annonceRepository)
    {
        _annonceRepository = annonceRepository;
    }

    // GET: api/Annonces
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Annonce>>> GetAnnonces()
    {
        var annonces = await _annonceRepository.GetAllAsync();
        return Ok(annonces);
    }

    // GET: api/Annonces/search?q={query}
    [HttpGet("search")]
    public async Task<ActionResult<IEnumerable<AnnonceSearchResultDto>>> SearchAnnonces([FromQuery] string q = "")
    {
        var results = await _annonceRepository.GetByLocalisationAsync(q);
        return Ok(results);
    }

    // GET: api/Annonces/5
    [HttpGet("{id}")]
    public async Task<ActionResult<Annonce>> GetAnnonce(int id)
    {
        var annonce = await _annonceRepository.GetByIdAsync(id);

        if (annonce == null)
        {
            return NotFound("Annonce introuvable.");
        }

        return Ok(annonce);
    }

    // POST: api/Annonces
    [HttpPost]
    public async Task<ActionResult<Annonce>> PostAnnonce(Annonce annonce)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        await _annonceRepository.AddAsync(annonce);

        return CreatedAtAction(nameof(GetAnnonce), new { id = annonce.Idannonce }, annonce);
    }

    // PUT: api/Annonces/5
    [HttpPut("{id}")]
    public async Task<IActionResult> PutAnnonce(int id, Annonce annonce)
    {
        if (id != annonce.Idannonce)
        {
            return BadRequest();
        }

        var annonceToUpdate = await _annonceRepository.GetByIdAsync(id);

        if (annonceToUpdate == null)
        {
            return NotFound();
        }

        await _annonceRepository.UpdateAsync(annonceToUpdate, annonce);

        return NoContent();
    }

    // DELETE: api/Annonces/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteAnnonce(int id)
    {
        var annonce = await _annonceRepository.GetByIdAsync(id);

        if (annonce == null)
        {
            return NotFound();
        }

        await _annonceRepository.DeleteAsync(annonce);

        return NoContent();
    }
}