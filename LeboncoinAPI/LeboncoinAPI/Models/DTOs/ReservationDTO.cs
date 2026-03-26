using System;
using System.Collections.Generic;

namespace LeboncoinAPI.Models.DTOs
{
    public class ReservationCreateDto
    {
        public int? Idreservation { get; set; }
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

    public class ReservationReadDto
    {
        public int Idreservation { get; set; }
        public int Idannonce { get; set; }
        public int Iddatedebutreservation { get; set; }
        public int Iddatefinreservation { get; set; }
        public int Idutilisateur { get; set; }
        public string Nomclient { get; set; }
        public string Prenomclient { get; set; }
        public string Telephoneclient { get; set; }
        public AnnonceReadDto IdannonceNavigation { get; set; }
        public DateReadDto IddatedebutreservationNavigation { get; set; }
        public DateReadDto IddatefinreservationNavigation { get; set; }
        public List<InclureReadDto> Inclures { get; set; }
        public List<TransactionReadDto> Transactions { get; set; }
    }

    public class TransactionReadDto
    {
        public decimal Montanttransaction { get; set; }
    }

    public class AnnonceReadDto
    {
        public int Idannonce { get; set; }
        public string Titreannonce { get; set; }
        public decimal Prixnuitee { get; set; }
        public int Idutilisateur { get; set; }
        public List<PhotoReadDto> Photos { get; set; }
        public AdresseReadDto IdadresseNavigation { get; set; }
    }

    public class PhotoReadDto
    {
        public string Lienphoto { get; set; }
    }

    public class AdresseReadDto
    {
        public VilleReadDto IdvilleNavigation { get; set; }
    }

    public class VilleReadDto
    {
        public string Nomville { get; set; }
    }

    public class DateReadDto
    {
        public DateOnly? Date1 { get; set; }
    }

    public class InclureReadDto
    {
        public int Idtypevoyageur { get; set; }
        public int Nombrevoyageur { get; set; }
        public TypeVoyageurReadDto IdtypevoyageurNavigation { get; set; }
    }

    public class TypeVoyageurReadDto
    {
        public string Nomtypevoyageur { get; set; }
    }
}