using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.DTOs.LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class UtilisateursController : ControllerBase
{
    private readonly IDataUtilisateurRepository<Utilisateur> _dataRepository;
    private readonly Cloudinary _cloudinary;

    public UtilisateursController(IDataUtilisateurRepository<Utilisateur> dataRepository, IConfiguration config)
    {
        _dataRepository = dataRepository;

        var acc = new Account(
            config["CloudinarySettings:CloudName"],
            config["CloudinarySettings:ApiKey"],
            config["CloudinarySettings:ApiSecret"]
        );
        _cloudinary = new Cloudinary(acc);
    }

    [HttpPost("{id}/upload-pfp")]
    public async Task<IActionResult> UploadPfp(int id, IFormFile file)
    {
        // 1. Check if file was actually sent
        if (file == null || file.Length == 0) return BadRequest("No file uploaded.");

        // 2. Find the user
        var user = await _dataRepository.GetByIdAsync(id);
        if (user == null) return NotFound($"User with ID {id} not found.");

        using var stream = file.OpenReadStream();

        var uploadParams = new ImageUploadParams()
        {
            File = new FileDescription(file.FileName, stream),
            Folder = "user_profiles",
            PublicId = $"user_{id}",
            Overwrite = true,
            Transformation = new Transformation()
                .Width(200).Height(200).Crop("thumb").Gravity("face").Radius("max").FetchFormat("png")
        };

        var uploadResult = await _cloudinary.UploadAsync(uploadParams);

        if (uploadResult.Error != null) return BadRequest(uploadResult.Error.Message);

        // 3. Update user (now safe because we checked for null above)
        user.ProfilePhotoPath = uploadResult.SecureUrl.ToString();
        await _dataRepository.UpdateAsync(user, user);

        return Ok(new { newUrl = user.ProfilePhotoPath });
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

    // GET: api/Utilisateurs/{id}/public
    [HttpGet("{id:int}/public")]
    public async Task<ActionResult> GetPublicProfile(int id)
    {
        var user = await _dataRepository.GetPublicProfileAsync(id);
        if (user == null) return NotFound("Utilisateur introuvable.");

        return Ok(new
        {
            user.Pseudonyme,
            user.ProfilePhotoPath,
            DateInscription = user.IddateNavigation?.Date1,
            NombreAnnonces = user.Annonces.Count,
            user.IdentityVerified,
            user.PhoneVerified,
            NoteMoyenne = user.Avis.Any() ? (decimal?)user.Avis.Average(a => a.Nombreetoiles) : null,
            NombreAvis = user.Avis.Count
        });
    }

    // GET: api/Utilisateurs/email/{email}
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
    [HttpPut("{id:int}")]
    public async Task<IActionResult> PutUtilisateur(int id, [FromBody] UtilisateurUpdateDTO dto)
    {
        if (id != dto.Idutilisateur)
            return BadRequest("ID mismatch");

      
        var existingUser = await _dataRepository.GetByIdAsync(id);

        if (existingUser == null) return NotFound();

        await ((UtilisateurManager)_dataRepository).UpdateProfileAsync(existingUser, dto);

        return NoContent();
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
        
        var user = await ((UtilisateurManager)_dataRepository).GetByEmailAsync(loginRequest.Email);

        if (user == null) return NotFound("Utilisateur non trouvé.");

        if (!BCrypt.Net.BCrypt.Verify(loginRequest.Password, user.Password))
            return BadRequest("Mot de passe incorrect.");

       
        string userType = user.Professionnel != null ? "professionnel" : "particulier";

     
        return Ok(new
        {
            idutilisateur = user.Idutilisateur,
            pseudonyme = user.Pseudonyme,
            email = user.Email,
            telephone = user.Telephoneutilisateur,
            typeUtilisateur = userType,
            profilePhotoPath = user.ProfilePhotoPath,
           
            civilite = user.Particulier?.Civilite,
            nomutilisateur = user.Particulier?.Nomutilisateur,
            prenomutilisateur = user.Particulier?.Prenomutilisateur,

           
            nomEntreprise = user.Professionnel?.Nomsociete,
            siret = user.Professionnel?.Numsiret,
            secteuractivite = user.Professionnel?.Secteuractivite
        });
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