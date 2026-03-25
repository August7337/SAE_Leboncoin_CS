using System;
using System.Collections.Generic;

namespace LeboncoinAPI.Models.DTOs
{
    public class GdprExportDTO
    {
        public UtilisateurGdprDTO Profil { get; set; }
        public List<dynamic> AnnoncesPubliees { get; set; }
        public List<dynamic> Favoris { get; set; }
        public List<dynamic> RecherchesSauvegardees { get; set; }
        public List<dynamic> ReservationsEffectuees { get; set; }
        public List<dynamic> Transactions { get; set; }
        public List<dynamic> AvisPublies { get; set; }
        public List<dynamic> IncidentsSignales { get; set; }
        public List<dynamic> MessagesEnvoyes { get; set; }
        public List<dynamic> MessagesRecus { get; set; }
    }

    public class UtilisateurGdprDTO
    {
        public int Id { get; set; }
        public string Pseudonyme { get; set; }
        public string Email { get; set; }
        public string Telephone { get; set; }
        public decimal Solde { get; set; }
        public DateTime? DateCreation { get; set; }
        public bool IsVerified { get; set; }
        public string TypeCompte { get; set; }
        public string Civilite { get; set; }
        public string Nom { get; set; }
        public string Prenom { get; set; }
        public DateOnly? DateNaissance { get; set; }
        public string NumSiret { get; set; }
        public string NomSociete { get; set; }
        public string SecteurActivite { get; set; }
        public string AdresseComplete { get; set; }
    }
}