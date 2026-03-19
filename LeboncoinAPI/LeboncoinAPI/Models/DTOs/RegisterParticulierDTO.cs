using LeboncoinAPI.Models.EntityFramework;
using System.ComponentModel.DataAnnotations;

namespace LeboncoinAPI.Models.DTOs
{
    public class RegisterParticulierDTO
    {
        // Données Utilisateur (Etape 1)
        public string Pseudonyme { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Password { get; set; } = null!;
        public string Telephoneutilisateur { get; set; } = null!;
        public string Rue { get; set; } = null!;
        public string Ville { get; set; } = null!;
        public string CodePostal { get; set; } = null!;

        // Données Particulier (Etape 2)
        public string Nomutilisateur { get; set; } = null!;
        public string Prenomutilisateur { get; set; } = null!;
        public string Civilite { get; set; } = null!;
        public DateTime DateNaissance { get; set; }
    }
}  

