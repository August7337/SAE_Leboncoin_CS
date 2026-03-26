namespace LeboncoinAPI.Models.DTOs;

public class ReservationResponseDto
{
    public int Idreservation { get; set; }
    public int Idannonce { get; set; }
    public int Iddatedebutreservation { get; set; }
    public int Iddatefinreservation { get; set; }
    public int Idutilisateur { get; set; }
    public string Nomclient { get; set; } = string.Empty;
    public string Prenomclient { get; set; } = string.Empty;
    public string? Telephoneclient { get; set; }
    public ReservationAnnonceDto? IdannonceNavigation { get; set; }
    public ReservationDateDto? IddatedebutreservationNavigation { get; set; }
    public ReservationDateDto? IddatefinreservationNavigation { get; set; }
    public List<ReservationInclureDto> Inclures { get; set; } = new();
}

public class ReservationAnnonceDto
{
    public int Idannonce { get; set; }
    public int Idutilisateur { get; set; }
    public string Titreannonce { get; set; } = string.Empty;
    public decimal Prixnuitee { get; set; }
    public int? Capacite { get; set; }
    public ReservationAdresseDto? IdadresseNavigation { get; set; }
    public List<ReservationPhotoDto> Photos { get; set; } = new();
}

public class ReservationAdresseDto
{
    public int Idadresse { get; set; }
    public ReservationVilleDto? IdvilleNavigation { get; set; }
}

public class ReservationVilleDto
{
    public int Idville { get; set; }
    public string Nomville { get; set; } = string.Empty;
}

public class ReservationPhotoDto
{
    public int Idphoto { get; set; }
    public string? Lienphoto { get; set; }
}

public class ReservationDateDto
{
    public int Iddate { get; set; }
    public DateOnly? Date1 { get; set; }
}

public class ReservationInclureDto
{
    public int Idreservation { get; set; }
    public int Idtypevoyageur { get; set; }
    public int Nombrevoyageur { get; set; }
    public ReservationTypeVoyageurDto? IdtypevoyageurNavigation { get; set; }
}

public class ReservationTypeVoyageurDto
{
    public int Idtypevoyageur { get; set; }
    public string Nomtypevoyageur { get; set; } = string.Empty;
}