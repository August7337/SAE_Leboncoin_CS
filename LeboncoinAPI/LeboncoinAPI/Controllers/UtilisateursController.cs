using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.DTOs.LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class UtilisateursController : ControllerBase
{
    private readonly IDataUtilisateurRepository<Utilisateur> _dataRepository;

    
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
    [HttpGet("{id:int}")]
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
    public async Task<IActionResult> GetUtilisateurByEmail(string email)
    {
        var decodedEmail = System.Net.WebUtility.UrlDecode(email);
        var utilisateur = await _dataRepository.GetByEmailAsync(decodedEmail);

        if (utilisateur == null)
            return NotFound();

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

     
        var existingEmail = await _dataRepository.GetByEmailAsync(utilisateur.Email);
        if (existingEmail != null)
        {
            return BadRequest("Cet email est déjà utilisé.");
        }

       
        var allUsers = await _dataRepository.GetAllAsync();
        if (allUsers.Any(u => u.Telephoneutilisateur == utilisateur.Telephoneutilisateur))
        {
            return BadRequest("Ce numéro de téléphone est déjà utilisé.");
        }

        try
        {
            await _dataRepository.AddAsync(utilisateur);
            return CreatedAtAction(nameof(GetUtilisateurById), new { id = utilisateur.Idutilisateur }, utilisateur);
        }
        catch (Exception ex)
        {
            return StatusCode(500, "Une erreur serveur est survenue.");
        }
    }

    // PUT: api/Utilisateurs/5
    [HttpPut("{id:int" +
        "}")]
    public async Task<IActionResult> PutUtilisateur(int id, Utilisateur utilisateur)
    {
        if (id != utilisateur.Idutilisateur)
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
    [HttpDelete("{id:int}")]
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
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest loginRequest)
    {
        var user = await _dataRepository.GetByEmailAsync(loginRequest.Email);
        if (user == null) return NotFound("Utilisateur non trouvé.");

        try
        {
            bool isValid = BCrypt.Net.BCrypt.Verify(loginRequest.Password, user.Password);
            if (!isValid) return BadRequest("Mot de passe incorrect.");


            return Ok(new
            {
                idutilisateur = user.Idutilisateur,
                pseudonyme = user.Pseudonyme,
                email = user.Email,
                telephone = user.Telephoneutilisateur,
                solde = user.Solde,
                phoneVerified = user.PhoneVerified,
                identityVerified = user.IdentityVerified,
                profilePhoto = user.ProfilePhotoPath

            });
        }
        catch (BCrypt.Net.SaltParseException)
        {
            return BadRequest("Format de sécurité obsolète.");
        }
        catch (Exception)
        {
            return StatusCode(500, "Une erreur interne est survenue.");
        }
    }
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterParticulierDTO dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var existing = await _dataRepository.GetByEmailAsync(dto.Email);
        if (existing != null) return Conflict("Cet email est déjà utilisé.");

        var result = await _dataRepository.RegisterFullParticulierAsync(dto);
        if (result) return Ok(new { message = "Inscription réussie" });
        return StatusCode(500, "Erreur lors de l'inscription.");
    }
    [HttpPost("register-particulier")]
    public async Task<IActionResult> RegisterParticulier([FromBody] RegisterParticulierDTO dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        try
        {
            var existingEmail = await _dataRepository.GetByEmailAsync(dto.Email);
            if (existingEmail != null)
                return Conflict(new { target = "email", message = "Cet email est déjà utilisé." });
            var success = await _dataRepository.RegisterFullParticulierAsync(dto);

            if (success)
            {
                var user = await _dataRepository.GetByEmailAsync(dto.Email);

                return Ok(new
                {
                    message = "Inscription réussie !",
                    user = new
                    {
                        idutilisateur = user.Idutilisateur,
                        pseudonyme = user.Pseudonyme,
                        email = user.Email,
                        telephone = user.Telephoneutilisateur,
                        solde = user.Solde
                    }
                });
            }
            return StatusCode(500, "Erreur lors de l'inscription.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Erreur : {ex.Message}");
        }
    }
    [HttpPost("register-professionnel")]
    public async Task<IActionResult> RegisterProfessionnel([FromBody] RegisterProfessionnelDTO dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);

        try
        {
            await ((UtilisateurManager)_dataRepository).RegisterFullProfessionnelAsync(dto);
            var user = await _dataRepository.GetByEmailAsync(dto.Email);
            return Ok(new
            {
                message = "Success",
                user = new
                {
                    idutilisateur = user.Idutilisateur,
                    pseudonyme = user.Pseudonyme,
                    email = user.Email,
                    telephone = user.Telephoneutilisateur
                }
            });
        }
        catch (UtilisateurManager.RegistrationConflictException ex)
        {
            return Conflict(new { target = ex.TargetField, message = ex.Message });
        }
        catch (Exception)
        {
            return StatusCode(500, "Erreur interne lors de la création du compte.");
        }
    }


    public class LoginRequest
    {
        public string Email { get; set; }
        public string Password { get; set; }
    }

}