namespace LeboncoinAPI.Models.DTOs
{
    public class AnnonceDTO
    {
        public string Titreannonce { get; set; } = null!;
        public string Descriptionannonce { get; set; } = null!;
        public decimal Prixnuitee { get; set; }
        public int Nombrepersonnesmax { get; set; }
        public int Idadresse { get; set; }
        public int Idutilisateur { get; set; }
        public List<string> Liensphoto { get; set; } = new();
        public int Nbchambres { get; set; }
        public int Nombrebebesmax { get; set; }

        public int Idtypehebergement { get; set; }
        public bool Possibiliteanimaux { get; set; }
        public bool Possibilitefumeur { get; set; }
    }
}
