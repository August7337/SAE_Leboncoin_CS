using System.ComponentModel.DataAnnotations;

namespace LeboncoinAPI.Models.DTOs
{

    public class AdresseDto
    {
        public string Rue { get; set; }
        public string Ville { get; set; }
        public string CodePostal { get; set; }
    }

    public class RegisterDto
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public AdresseDto Adresse { get; set; } 
    }
}
