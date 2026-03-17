using System.ComponentModel.DataAnnotations;

namespace LeboncoinAPI.Models.DTOs
{



    public class ParticulierDTO
    {
        [Required]
        public int Idutilisateur { get; set; }

        [Required]
        [StringLength(50)]
        public string Nomutilisateur { get; set; } = null!;

        [Required]
        [StringLength(50)]
        public string Prenomutilisateur { get; set; } = null!;

        [Required]
        public string Civilite { get; set; } = null!;

        [Required]
        public DateTime DateNaissance { get; set; }
    }
}
