using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AnnoncesController : ControllerBase
{
    private readonly IDataRepository<Annonce> _dataRepository;

    public AnnoncesController(IDataRepository<Annonce> dataRepository)
    {
        _dataRepository = dataRepository;
    }

    // GET: api/Annonces
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Annonce>>> GetAnnonces()
    {
        var annonces = await _dataRepository.GetAllAsync();
        return Ok(annonces);
    }

    // GET: api/Annonces/5
    [HttpGet("{id}")]
    public async Task<ActionResult<Annonce>> GetAnnonce(int id)
    {
        var annonce = await _dataRepository.GetByIdAsync(id);

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

        await _dataRepository.AddAsync(annonce);

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

        var annonceToUpdate = await _dataRepository.GetByIdAsync(id);

        if (annonceToUpdate == null)
        {
            return NotFound();
        }

        await _dataRepository.UpdateAsync(annonceToUpdate, annonce);

        return NoContent();
    }

    // DELETE: api/Annonces/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteAnnonce(int id)
    {
        var annonce = await _dataRepository.GetByIdAsync(id);

        if (annonce == null)
        {
            return NotFound();
        }

        await _dataRepository.DeleteAsync(annonce);

        return NoContent();
    }
}