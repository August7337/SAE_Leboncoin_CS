using System;
using System.Collections.Generic;

namespace LeboncoinAPI.Models.DTOs
{
    public class ReservationCreateDto
    {
        public int Idannonce { get; set; }
        public int Idutilisateur { get; set; }
        public DateTime DateDebut { get; set; }
        public DateTime DateFin { get; set; }
        public string Nomclient { get; set; }
        public string Prenomclient { get; set; }
        public string Telephoneclient { get; set; }
        public List<InclureCreateDto> Inclures { get; set; } = new List<InclureCreateDto>();
    }

    public class InclureCreateDto
    {
        public int Idtypevoyageur { get; set; }
        public int Nombrevoyageur { get; set; }
    }
}