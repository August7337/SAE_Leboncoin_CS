using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class UtilisateursController : ControllerBase
{
    private readonly IDataUtilisateurRepository<Utilisateur> _dataRepository;

    // L'injection de dépendance fournit automatiquement l'instance d'UtilisateurManager
    public UtilisateursController(IDataUtilisateurRepository<Utilisateur> dataRepository)
    {
        _dataRepository = dataRepository;
    }

    // GET: api/Utilisateurs
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Utilisateur>>> GetUtilisateurs()
    {
        var utilisateurs = await _dataRepository.GetAllAsync();
        return Ok(utilisateurs);
    }

    // GET: api/Utilisateurs/5
    [HttpGet("{id}")]
    public async Task<ActionResult<Utilisateur>> GetUtilisateurById(int id)
    {
        var utilisateur = await _dataRepository.GetByIdAsync(id);

        if (utilisateur == null)
        {
            return NotFound("Utilisateur introuvable.");
        }

        return Ok(utilisateur);
    }

    // GET: api/Utilisateurs/5
    [HttpGet("email/{email}")]
    public async Task<ActionResult<Utilisateur>> GetUtilisateurByEmail(string email)
    {
        var utilisateur = await _dataRepository.GetByEmailAsync(email);

        if (utilisateur == null)
        {
            return NotFound("Utilisateur introuvable.");
        }

        return Ok(utilisateur);
    }


    // POST: api/Utilisateurs
    [HttpPost]
    public async Task<ActionResult<Utilisateur>> PostUtilisateur(Utilisateur utilisateur)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        await _dataRepository.AddAsync(utilisateur);

        // Renvoie un code 201 Created avec l'URI de la nouvelle ressource
        return CreatedAtAction(nameof(GetUtilisateurById), new { id = utilisateur.UtilisateurId }, utilisateur);
    }

    // PUT: api/Utilisateurs/5
    [HttpPut("{id}")]
    public async Task<IActionResult> PutUtilisateur(int id, Utilisateur utilisateur)
    {
        if (id != utilisateur.UtilisateurId)
        {
            return BadRequest("L'ID fourni dans l'URL ne correspond pas à l'ID de l'objet.");
        }

        var utilisateurToUpdate = await _dataRepository.GetByIdAsync(id);

        if (utilisateurToUpdate == null)
        {
            return NotFound("Utilisateur à mettre à jour introuvable.");
        }

        await _dataRepository.UpdateAsync(utilisateurToUpdate, utilisateur);

        return NoContent(); // 204 No Content est la réponse standard pour un PUT réussi
    }

    // DELETE: api/Utilisateurs/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteUtilisateur(int id)
    {
        var utilisateur = await _dataRepository.GetByIdAsync(id);

        if (utilisateur == null)
        {
            return NotFound("Utilisateur à supprimer introuvable.");
        }

        await _dataRepository.DeleteAsync(utilisateur);

        return NoContent();
    }
}