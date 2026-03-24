using System.Text.Json.Serialization;

namespace LeboncoinAPI.Models.DTOs
{
    public class AnnonceDTO
    {
        public string Titreannonce { get; set; }
        public string Descriptionannonce { get; set; }
        public decimal Prixnuitee { get; set; }
        public int Nbchambres { get; set; }
        public int Nombrebebesmax { get; set; }
        public int Nombrepersonnesmax { get; set; } 
        public bool Possibiliteanimaux { get; set; }
        public bool Possibilitefumeur { get; set; }
        public int Idheurearrivee { get; set; }
        public int Idheuredepart { get; set; }

        public int Idtypehebergement { get; set; }

        [JsonPropertyName("minimumnuitee")]
        public int Minimumnuitee { get; set; }
        public decimal Acomptefixe { get; set; }
        public int Acomptepourcentage { get; set; }

        [JsonPropertyName("rue")]
        public string Rue { get; set; }
        public string Ville { get; set; }
        public string CodePostal { get; set; }

        public int Idutilisateur { get; set; }
        public List<string> Liensphoto { get; set; }
    }
}