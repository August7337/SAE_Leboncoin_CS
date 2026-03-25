using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Stripe;
using Stripe.Checkout;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using System;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class ReservationsController : ControllerBase
{
    private readonly IReservationRepository _dataRepository;
    private readonly LeboncoinDBContext _dbContext;
    private readonly IConfiguration _configuration;

    public ReservationsController(IReservationRepository dataRepository, LeboncoinDBContext dbContext, IConfiguration configuration)
    {
        _dataRepository = dataRepository;
        _dbContext = dbContext;
        _configuration = configuration;

        StripeConfiguration.ApiKey = _configuration["Stripe:SecretKey"];
    }

    // =========================================================================
    // 1. MÉTHODES GET (Lecture des réservations)
    // =========================================================================

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Reservation>>> GetReservations()
    {
        return Ok(await _dataRepository.GetAllAsync());
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Reservation>> GetReservation(int id)
    {
        var reservation = await _dataRepository.GetByIdAsync(id);

        if (reservation == null)
        {
            return NotFound();
        }

        return Ok(reservation);
    }

    [HttpGet("user/{userId}")]
    public async Task<ActionResult<IEnumerable<Reservation>>> GetByUserId(int userId)
    {
        return Ok(await _dataRepository.GetByUserIdAsync(userId));
    }


    // =========================================================================
    // 2. MÉTHODES DE PAIEMENT ET CRÉATION (Stripe & Solde)
    // =========================================================================

    [HttpPost("create-checkout-session")]
    public async Task<IActionResult> CreateCheckoutSession([FromBody] ReservationCreateDto dto)
    {
        var annonce = await _dbContext.Annonces.FindAsync(dto.Idannonce);
        if (annonce == null) return NotFound("Annonce introuvable.");

        var utilisateur = await _dbContext.Utilisateurs.FindAsync(dto.Idutilisateur);
        if (utilisateur == null) return NotFound("Utilisateur introuvable.");

        var voyageurs = dto.Inclures ?? new List<InclureCreateDto>();
        int totalAdults = voyageurs.FirstOrDefault(i => i.Idtypevoyageur == 1)?.Nombrevoyageur ?? 1;
        int totalEnfants = voyageurs.FirstOrDefault(i => i.Idtypevoyageur == 2)?.Nombrevoyageur ?? 0;

        int nights = (dto.DateFin - dto.DateDebut).Days;
        if (nights <= 0) nights = 1;

        decimal totalRent = annonce.Prixnuitee * nights;
        decimal serviceFee = totalRent * 0.14m;
        decimal touristTax = 4.00m * nights * totalAdults;
        decimal depositAmount = serviceFee + (totalRent * 0.35m) + touristTax;

        decimal soldeDisponible = utilisateur.Solde;

        // --- CAS A : Paiement 100% par Solde ---
        if (soldeDisponible >= depositAmount && depositAmount > 0)
        {
            utilisateur.Solde -= depositAmount;
            var dDebutRecord = await GetOrCreateDate(DateOnly.FromDateTime(dto.DateDebut));
            var dFinRecord = await GetOrCreateDate(DateOnly.FromDateTime(dto.DateFin));
            var dToday = await GetOrCreateDate(DateOnly.FromDateTime(DateTime.Now));

            var reservationDirecte = new Reservation
            {
                Idannonce = dto.Idannonce,
                Idutilisateur = dto.Idutilisateur,
                Iddatedebutreservation = dDebutRecord.Iddate,
                Iddatefinreservation = dFinRecord.Iddate,
                Nomclient = dto.Nomclient ?? "Inconnu",
                Prenomclient = dto.Prenomclient ?? "Inconnu",
                Telephoneclient = dto.Telephoneclient
            };
            _dbContext.Reservations.Add(reservationDirecte);
            await _dbContext.SaveChangesAsync();

            _dbContext.Inclures.Add(new Inclure { Idreservation = reservationDirecte.Idreservation, Idtypevoyageur = 1, Nombrevoyageur = totalAdults });
            if (totalEnfants > 0) _dbContext.Inclures.Add(new Inclure { Idreservation = reservationDirecte.Idreservation, Idtypevoyageur = 2, Nombrevoyageur = totalEnfants });

            var transactionDirecte = new Transaction
            {
                Iddate = dToday.Iddate,
                Idreservation = reservationDirecte.Idreservation,
                Idutilisateur = dto.Idutilisateur,
                Montanttransaction = depositAmount
            };
            _dbContext.Transactions.Add(transactionDirecte);
            await _dbContext.SaveChangesAsync();

            return Ok(new { url = "http://localhost:5173/?payment=success" });
        }

        // --- CAS B : Paiement Stripe (mixte ou 100% carte) ---
        decimal soldeAUtiliser = 0;
        decimal montantRestantStripe = depositAmount;

        if (soldeDisponible > 0)
        {
            soldeAUtiliser = soldeDisponible;
            montantRestantStripe = depositAmount - soldeAUtiliser;
        }

        var metadata = new Dictionary<string, string>
        {
            { "idannonce", dto.Idannonce.ToString() },
            { "idutilisateur", dto.Idutilisateur.ToString() },
            { "dateDebut", dto.DateDebut.ToString("yyyy-MM-dd") },
            { "dateFin", dto.DateFin.ToString("yyyy-MM-dd") },
            { "nomclient", dto.Nomclient ?? "Inconnu" },
            { "prenomclient", dto.Prenomclient ?? "Inconnu" },
            { "telephone", dto.Telephoneclient ?? "" },
            { "adultes", totalAdults.ToString() },
            { "enfants", totalEnfants.ToString() },
            { "soldeUsed", soldeAUtiliser.ToString(CultureInfo.InvariantCulture) }
        };

        var options = new SessionCreateOptions
        {
            PaymentMethodTypes = new List<string> { "card" },
            LineItems = new List<SessionLineItemOptions>
            {
                new SessionLineItemOptions
                {
                    PriceData = new SessionLineItemPriceDataOptions
                    {
                        UnitAmount = (long)(montantRestantStripe * 100),
                        Currency = "eur",
                        ProductData = new SessionLineItemPriceDataProductDataOptions
                        {
                            Name = $"Acompte réservation - {annonce.Titreannonce}",
                            Description = soldeAUtiliser > 0 ? $"Solde déduit : {soldeAUtiliser}€" : $"Du {dto.DateDebut:dd/MM/yyyy} au {dto.DateFin:dd/MM/yyyy}"
                        },
                    },
                    Quantity = 1,
                },
            },
            Mode = "payment",
            Metadata = metadata,
            SuccessUrl = "http://localhost:5173/?session_id={CHECKOUT_SESSION_ID}",
            CancelUrl = "http://localhost:5173/reservation/cancel",
        };

        var service = new SessionService();
        Session session = await service.CreateAsync(options);
        return Ok(new { url = session.Url });
    }

    [HttpPost("confirm-payment")]
    public async Task<IActionResult> ConfirmPayment([FromBody] PaymentConfirmDto dto)
    {
        var service = new SessionService();
        Session session = await service.GetAsync(dto.SessionId);

        if (session.PaymentStatus != "paid") return BadRequest("Le paiement n'a pas abouti.");

        var meta = session.Metadata;
        int idUtilisateur = int.Parse(meta["idutilisateur"]);
        decimal soldeUsed = decimal.Parse(meta["soldeUsed"], CultureInfo.InvariantCulture);

        var utilisateur = await _dbContext.Utilisateurs.FindAsync(idUtilisateur);

        if (utilisateur != null && soldeUsed > 0)
        {
            utilisateur.Solde -= soldeUsed;
            if (utilisateur.Solde < 0) utilisateur.Solde = 0;
        }

        var dateDebut = DateOnly.Parse(meta["dateDebut"]);
        var dateFin = DateOnly.Parse(meta["dateFin"]);
        var dateDebutRecord = await GetOrCreateDate(dateDebut);
        var dateFinRecord = await GetOrCreateDate(dateFin);
        var dateAujourdhui = await GetOrCreateDate(DateOnly.FromDateTime(DateTime.Now));

        var reservation = new Reservation
        {
            Idannonce = int.Parse(meta["idannonce"]),
            Idutilisateur = idUtilisateur,
            Iddatedebutreservation = dateDebutRecord.Iddate,
            Iddatefinreservation = dateFinRecord.Iddate,
            Nomclient = meta["nomclient"],
            Prenomclient = meta["prenomclient"],
            Telephoneclient = meta["telephone"]
        };
        _dbContext.Reservations.Add(reservation);
        await _dbContext.SaveChangesAsync();

        _dbContext.Inclures.Add(new Inclure { Idreservation = reservation.Idreservation, Idtypevoyageur = 1, Nombrevoyageur = int.Parse(meta["adultes"]) });
        if (int.Parse(meta["enfants"]) > 0)
        {
            _dbContext.Inclures.Add(new Inclure { Idreservation = reservation.Idreservation, Idtypevoyageur = 2, Nombrevoyageur = int.Parse(meta["enfants"]) });
        }

        decimal montantPayeViaStripe = session.AmountTotal.HasValue ? session.AmountTotal.Value / 100m : 0m;

        var transaction = new Transaction
        {
            Iddate = dateAujourdhui.Iddate,
            Idreservation = reservation.Idreservation,
            Idutilisateur = idUtilisateur,
            Montanttransaction = montantPayeViaStripe + soldeUsed
        };
        _dbContext.Transactions.Add(transaction);

        await _dbContext.SaveChangesAsync();

        return Ok(new { message = "Réservation créée avec succès !" });
    }


    // =========================================================================
    // 3. MÉTHODES DE MODIFICATION ET SUPPRESSION
    // =========================================================================

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteReservation(int id)
    {
        var reservation = await _dataRepository.GetByIdAsync(id);
        if (reservation == null) return NotFound();

        await _dataRepository.DeleteAsync(reservation);

        return NoContent();
    }

    // =========================================================================
    // 4. MÉTHODES UTILITAIRES
    // =========================================================================

    private async Task<Date> GetOrCreateDate(DateOnly dateValue)
    {
        var dateRecord = await _dbContext.Dates.FirstOrDefaultAsync(d => d.Date1 == dateValue);
        if (dateRecord == null)
        {
            dateRecord = new Date { Date1 = dateValue };
            _dbContext.Dates.Add(dateRecord);
            await _dbContext.SaveChangesAsync();
        }
        return dateRecord;
    }
}

public class PaymentConfirmDto
{
    public string SessionId { get; set; }
}