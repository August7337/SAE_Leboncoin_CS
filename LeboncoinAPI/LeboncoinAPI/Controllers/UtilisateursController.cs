using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.DTOs.LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using LeboncoinAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class UtilisateursController : ControllerBase
{
    private readonly IDataUtilisateurRepository<Utilisateur> _dataRepository;
    private readonly LeboncoinDBContext _context;
    private readonly IEmailService _emailService;
    private readonly Cloudinary _cloudinary;

    public UtilisateursController(
        IDataUtilisateurRepository<Utilisateur> dataRepository,
        LeboncoinDBContext context,           
        IEmailService emailService,           
        IConfiguration config)
    {
        _dataRepository = dataRepository;
        _context = context;             
        _emailService = emailService;  

        var acc = new Account(
            config["CloudinarySettings:CloudName"],
            config["CloudinarySettings:ApiKey"],
            config["CloudinarySettings:ApiSecret"]
        );
        _cloudinary = new Cloudinary(acc);
    }

    [HttpPost("forgot-password")]
    [AllowAnonymous]
    public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequest request)
    {
        var user = await _context.Utilisateurs.FirstOrDefaultAsync(u => u.Email == request.Email);

        if (user == null)
            return Ok(new { message = "Si cet e-mail est associé à un compte, un lien de réinitialisation a été envoyé." });

        user.ResetPasswordToken = Guid.NewGuid().ToString();
        user.ResetPasswordExpiry = DateTime.UtcNow.AddHours(2);

        await _context.SaveChangesAsync();

        var resetLink = $"http://localhost:5173/reset-password?token={user.ResetPasswordToken}";

        var htmlBody = $@"
            <div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #eee;'>
                <h2 style='color: #ff6e14;'>Mot de passe oublié ?</h2>
                <p>Bonjour {user.Pseudonyme},</p>
                <p>Cliquez sur le bouton ci-dessous pour choisir un nouveau mot de passe :</p>
                <a href='{resetLink}' style='display:inline-block; background:#ff6e14; color:white; padding:10px 20px; text-decoration:none; border-radius:5px;'>Réinitialiser mon mot de passe</a>
                <p>Ce lien expirera dans 2 heures.</p>
                <p>Si vous n'êtes pas à l'origine de cette demande, ignorez ce message.</p>
            </div>";

        await _emailService.SendEmailAsync(user.Email, "Réinitialisation de votre mot de passe", htmlBody);

        return Ok(new { message = "E-mail de récupération envoyé." });
    }

    [HttpPost("reset-password")]
    [AllowAnonymous]
    public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequest request)
    {
        var user = await _context.Utilisateurs.FirstOrDefaultAsync(u =>
            u.ResetPasswordToken == request.Token &&
            u.ResetPasswordExpiry > DateTime.UtcNow);

        if (user == null)
            return BadRequest(new { message = "Le lien est invalide ou a expiré." });

        user.Password = BCrypt.Net.BCrypt.HashPassword(request.NewPassword);
        user.ResetPasswordToken = null;
        user.ResetPasswordExpiry = null;

        await _context.SaveChangesAsync();

        return Ok(new { message = "Votre mot de passe a été modifié avec succès." });
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

    // GET: api/Utilisateurs/{id}/auth-profile
    [HttpGet("{id:int}/auth-profile")]
    [Authorize]
    public async Task<IActionResult> GetAuthProfile(int id)
    {
        var currentUserId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (currentUserId == null || currentUserId != id.ToString())
            return Forbid();

        var user = await ((UtilisateurManager)_dataRepository).GetByEmailAsync(
            User.FindFirst(ClaimTypes.Email)!.Value);

        if (user == null) return NotFound("Utilisateur introuvable.");

        return Ok(new
        {
            roles = GetRoleNames(user),
            permissions = GetPermissionNames(user)
        });
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest loginRequest)
    {
        var user = await ((UtilisateurManager)_dataRepository).GetByEmailAsync(loginRequest.Email);

        if (user == null) return NotFound("Utilisateur non trouvé.");

        if (!BCrypt.Net.BCrypt.Verify(loginRequest.Password, user.Password))
            return BadRequest("Mot de passe incorrect.");

        string userType = user.Professionnel != null ? "professionnel" : "particulier";

        var jwtToken = GenerateJwtToken(user);

        return Ok(new
        {
            token = jwtToken,
            user = new
            {
                idutilisateur = user.Idutilisateur,
                pseudonyme = user.Pseudonyme,
                email = user.Email,
                telephone = user.Telephoneutilisateur,
                typeUtilisateur = userType,
                profilePhotoPath = user.ProfilePhotoPath,
                solde = user.Solde,

                civilite = user.Particulier?.Civilite,
                nomutilisateur = user.Particulier?.Nomutilisateur,
                prenomutilisateur = user.Particulier?.Prenomutilisateur,

                nomEntreprise = user.Professionnel?.Nomsociete,
                siret = user.Professionnel?.Numsiret,
                secteuractivite = user.Professionnel?.Secteuractivite,
                roles = GetRoleNames(user),
                permissions = GetPermissionNames(user)
            }
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

            
                var token = GenerateJwtToken(user);

                return Ok(new
                {
                    message = "Inscription réussie !",
                    Token = token,
                    user = new
                    {
                        idutilisateur = user.Idutilisateur,
                        pseudonyme = user.Pseudonyme,
                        email = user.Email,
                        telephone = user.Telephoneutilisateur,
                        solde = user.Solde,
                        typeUtilisateur = "particulier" 
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
            var token = GenerateJwtToken(user);

            return Ok(new
            {
                message = "Success",
                Token = token,
                user = new
                {
                    idutilisateur = user.Idutilisateur,
                    pseudonyme = user.Pseudonyme,
                    email = user.Email,
                    telephone = user.Telephoneutilisateur,
                    typeUtilisateur = "professionnel"
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

    [HttpGet("{id}/export-rgpd")]
    [Authorize]
    public async Task<IActionResult> ExportGdprData(int id)
    {
        var currentUserId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value);
        if (currentUserId != id) return Forbid();

        var hasGdprPermission = User.Claims.Any(claim =>
            claim.Type == AuthorizationClaimTypes.Permission
            && string.Equals(claim.Value, AppPermissions.AppViewGdprData, StringComparison.OrdinalIgnoreCase));

        if (!hasGdprPermission) return Forbid();


        try
        {
            var exportData = await ((UtilisateurManager)_dataRepository).GetGdprDataAsync(id);

            if (exportData == null) return NotFound("Utilisateur introuvable.");

            return Ok(exportData);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Erreur lors de l'export des données : {ex.Message}");
        }
    }

    [HttpPost("{id}/demande-suppression")]
    [Authorize]
    public async Task<IActionResult> DemanderSuppression(int id)
    {
        var claimId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(claimId) || int.Parse(claimId) != id)
        {
            return Forbid("Vous n'êtes pas autorisé à demander la suppression d'un autre compte.");
        }

        try
        {
            var success = await _dataRepository.CreerDemandeSuppressionAsync(id);

            if (!success)
            {
                return BadRequest(new { message = "Une demande de suppression est déjà en cours de traitement pour ce compte." });
            }

            return Ok(new { message = "Votre demande de suppression a bien été prise en compte. Notre Délégué à la Protection des Données (DPO) reviendra vers vous sous 30 jours." });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Erreur lors de la création de la demande : {ex.Message}");
        }
    }

    // DEV ONLY — génère un token JWT pour n'importe quel utilisateur sans mot de passe (Development uniquement)
    [HttpPost("dev/impersonate/{id:int}")]
    public async Task<IActionResult> DevImpersonate(int id, [FromServices] IWebHostEnvironment env)
    {
        if (!env.IsDevelopment())
            return NotFound();

        var basicUser = await _dataRepository.GetByIdAsync(id);
        if (basicUser == null) return NotFound("Utilisateur introuvable.");

        var user = await ((UtilisateurManager)_dataRepository).GetByEmailAsync(basicUser.Email);
        if (user == null) return NotFound("Utilisateur introuvable.");

        string userType = user.Professionnel != null ? "professionnel" : "particulier";
        var jwtToken = GenerateJwtToken(user);

        return Ok(new
        {
            token = jwtToken,
            user = new
            {
                idutilisateur = user.Idutilisateur,
                pseudonyme = user.Pseudonyme,
                email = user.Email,
                telephone = user.Telephoneutilisateur,
                typeUtilisateur = userType,
                profilePhotoPath = user.ProfilePhotoPath,
                solde = user.Solde,
                civilite = user.Particulier?.Civilite,
                nomutilisateur = user.Particulier?.Nomutilisateur,
                prenomutilisateur = user.Particulier?.Prenomutilisateur,
                nomEntreprise = user.Professionnel?.Nomsociete,
                siret = user.Professionnel?.Numsiret,
                secteuractivite = user.Professionnel?.Secteuractivite,
                roles = GetRoleNames(user),
                permissions = GetPermissionNames(user)
            }
        });
    }

    private string GenerateJwtToken(Utilisateur user)
    {
        var jwtSettings = HttpContext.RequestServices.GetService<IConfiguration>()!.GetSection("JwtSettings");
        var secretKey = jwtSettings["SecretKey"];
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey!));

        var claims = new List<Claim>
    {
        new Claim(ClaimTypes.NameIdentifier, user.Idutilisateur.ToString()),
        new Claim(ClaimTypes.Email, user.Email),
        new Claim(ClaimTypes.Name, user.Pseudonyme)
    };

        foreach (var role in GetRoleNames(user))
        {
            claims.Add(new Claim(ClaimTypes.Role, role));
        }

        foreach (var permission in GetPermissionNames(user))
        {
            claims.Add(new Claim(AuthorizationClaimTypes.Permission, permission));
        }

        var token = new JwtSecurityToken(
            issuer: jwtSettings["Issuer"],
            audience: jwtSettings["Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddDays(7),
            signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256)
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    private static IReadOnlyCollection<string> GetRoleNames(Utilisateur user)
    {
        return user.Idroles
            .Where(role => !string.IsNullOrWhiteSpace(role.Nomrole))
            .Select(role => role.Nomrole!)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    private static IReadOnlyCollection<string> GetPermissionNames(Utilisateur user)
    {
        return user.Idroles
            .SelectMany(role => role.Idpermissions)
            .Where(permission => !string.IsNullOrWhiteSpace(permission.Nompermission))
            .Select(permission => permission.Nompermission!)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }


    public class LoginRequest
    {
        public string Email { get; set; }
        public string Password { get; set; }
    }

}