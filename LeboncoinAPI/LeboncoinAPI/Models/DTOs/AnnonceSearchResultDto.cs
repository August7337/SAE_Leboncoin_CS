using LeboncoinAPI.Models.EntityFramework;

namespace LeboncoinAPI.Models.DTOs;

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
    public int? Capacite { get; set; }
    public int? Nombreetoilesleboncoin { get; set; }
    public bool Estverifie { get; set; }
    public ICollection<Photo>? Photos { get; set; }
    public object? Reservations { get; set; }
}
