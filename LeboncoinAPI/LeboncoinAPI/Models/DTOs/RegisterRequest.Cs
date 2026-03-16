
    

namespace LeboncoinAPI.Models.DTOs
{
    public class RegisterRequest
    {
        public string Pseudonyme { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Telephoneutilisateur { get; set; } = null!;
        public string Password { get; set; } = null!;
        public string Rue { get; set; } = null!;
        public string Ville { get; set; } = null!;
        public string CodePostal { get; set; } = null!;
    }
}

