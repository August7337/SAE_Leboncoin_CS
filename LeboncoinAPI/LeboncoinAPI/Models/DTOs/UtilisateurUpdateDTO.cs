namespace LeboncoinAPI.Models.DTOs
{
    public class UtilisateurUpdateDTO
    {
        public int Idutilisateur { get; set; }
        public string Pseudonyme { get; set; }
        public string Email { get; set; }
        public string Telephoneutilisateur { get; set; }

        public string? Civilite { get; set; }
        public string? Nomutilisateur { get; set; }
        public string? Prenomutilisateur { get; set; }

       
        public string? NomEntreprise { get; set; }
        public decimal Siret { get; set; }
        public string? Secteuractivite { get; set; }
    }
}