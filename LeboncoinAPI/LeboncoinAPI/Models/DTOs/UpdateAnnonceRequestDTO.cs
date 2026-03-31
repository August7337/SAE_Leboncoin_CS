using System.ComponentModel.DataAnnotations;

namespace LeboncoinAPI.Models.DTOs
{
    public class UpdateAnnonceRequestDTO
    {
        [Required]
        [MinLength(10)]
        public string Titreannonce { get; set; } = string.Empty;

        [Required]
        public string Descriptionannonce { get; set; } = string.Empty;

        [Required]
        [Range(1, double.MaxValue)]
        public decimal Prixnuitee { get; set; }

        public int Nbchambres { get; set; }
        public int Nombrebebesmax { get; set; }
        
        [Range(1, int.MaxValue)]
        public int Capacite { get; set; } 
        
        public bool Possibiliteanimaux { get; set; }
        public bool Possibilitefumeur { get; set; }
        public int Idheurearrivee { get; set; }
        public int Idheuredepart { get; set; }

        [Required]
        public int Idtypehebergement { get; set; }

        public int Minimumnuitee { get; set; }

        public List<int> Idcommodites { get; set; } = new List<int>();
    }
}
