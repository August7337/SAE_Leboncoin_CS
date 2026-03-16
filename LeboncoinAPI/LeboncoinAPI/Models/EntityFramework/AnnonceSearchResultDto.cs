namespace LeboncoinAPI.Models.EntityFramework;

public class AnnonceSearchResultDto
{
    public int Idannonce { get; set; }
    public string Titreannonce { get; set; } = null!;
    public string? TypeHebergement { get; set; }
    public string? Adresse { get; set; }
    public string? Nomville { get; set; }
    public string? Codepostal { get; set; }
    public DateOnly? DateDepot { get; set; }
    public decimal Prixnuitee { get; set; }
    public string? Lienphoto { get; set; }
}
