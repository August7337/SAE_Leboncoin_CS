namespace LeboncoinAPI.Models.DTOs
{
    namespace LeboncoinAPI.Models.DTOs
    {
        public class RegisterProfessionnelDTO
        {
         
            public string Pseudonyme { get; set; } = null!;
            public string Email { get; set; } = null!;
            public string Password { get; set; } = null!;
            public string Telephoneutilisateur { get; set; } = null!;
            public string Rue { get; set; } = null!;
            public string Ville { get; set; } = null!;
            public string CodePostal { get; set; } = null!;

          
            public decimal Numsiret { get; set; }
            public string Nomsociete { get; set; } = null!;
            public string Secteuractivite { get; set; } = null!;
        }
    }
}
