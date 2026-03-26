using System;

namespace LeboncoinAPI.Models.DTOs
{
    public class AnnonceReservationDto
    {
        public int Idreservation { get; set; }
        public string Nomclient { get; set; } = null!;
        public string Prenomclient { get; set; } = null!;
        public DateOnly? DateDebut { get; set; }
        public DateOnly? DateFin { get; set; }
        public bool EstPassee => DateFin.HasValue && DateFin.Value < DateOnly.FromDateTime(DateTime.Now);
    }
}
