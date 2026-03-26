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
    public async Task<ActionResult<IEnumerable<ReservationReadDto>>> GetReservations()
    {
        var reservations = await _dataRepository.GetAllAsync();
        return Ok(reservations.Select(MapToReadDto));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ReservationReadDto>> GetReservation(int id)
    {
        var reservation = await _dataRepository.GetByIdAsync(id);

        if (reservation == null)
        {
            return NotFound();
        }

<<<<<<< HEAD
        return Ok(MapReservation(reservation));
    }

    [HttpGet("user/{userId}")]
    public async Task<ActionResult<IEnumerable<ReservationResponseDto>>> GetByUserId(int userId)
    {
        return Ok((await _dataRepository.GetByUserIdAsync(userId)).Select(MapReservation));
=======
        return Ok(MapToReadDto(reservation));
    }

    [HttpGet("user/{userId}")]
    public async Task<ActionResult<IEnumerable<ReservationReadDto>>> GetByUserId(int userId)
    {
        var reservations = await _dataRepository.GetByUserIdAsync(userId);
        return Ok(reservations.Select(MapToReadDto));
    }

    private static ReservationReadDto MapToReadDto(Reservation r)
    {
        return new ReservationReadDto
        {
            Idreservation = r.Idreservation,
            Idannonce = r.Idannonce,
            Iddatedebutreservation = r.Iddatedebutreservation,
            Iddatefinreservation = r.Iddatefinreservation,
            Idutilisateur = r.Idutilisateur,
            Nomclient = r.Nomclient,
            Prenomclient = r.Prenomclient,
            Telephoneclient = r.Telephoneclient,
            IddatedebutreservationNavigation = r.IddatedebutreservationNavigation == null ? null : new DateReadDto { Date1 = r.IddatedebutreservationNavigation.Date1 },
            IddatefinreservationNavigation = r.IddatefinreservationNavigation == null ? null : new DateReadDto { Date1 = r.IddatefinreservationNavigation.Date1 },
            IdannonceNavigation = r.IdannonceNavigation == null ? null : new AnnonceReadDto
            {
                Idannonce = r.IdannonceNavigation.Idannonce,
                Titreannonce = r.IdannonceNavigation.Titreannonce,
                Prixnuitee = r.IdannonceNavigation.Prixnuitee,
                Idutilisateur = r.IdannonceNavigation.Idutilisateur,
                Photos = r.IdannonceNavigation.Photos.Select(p => new PhotoReadDto { Lienphoto = p.Lienphoto }).ToList(),
                IdadresseNavigation = r.IdannonceNavigation.IdadresseNavigation == null ? null : new AdresseReadDto
                {
                    IdvilleNavigation = r.IdannonceNavigation.IdadresseNavigation.IdvilleNavigation == null ? null : new VilleReadDto
                    {
                        Nomville = r.IdannonceNavigation.IdadresseNavigation.IdvilleNavigation.Nomville
                    }
                }
            },
            Inclures = r.Inclures.Select(i => new InclureReadDto
            {
                Idtypevoyageur = i.Idtypevoyageur,
                Nombrevoyageur = i.Nombrevoyageur,
                IdtypevoyageurNavigation = i.IdtypevoyageurNavigation == null ? null : new TypeVoyageurReadDto
                {
                    Nomtypevoyageur = i.IdtypevoyageurNavigation.Nomtypevoyageur
                }
            }).ToList(),
            Transactions = r.Transactions.Select(t => new TransactionReadDto { Montanttransaction = t.Montanttransaction }).ToList()
        };
>>>>>>> 1c5c4e08850941806f3d0b25f104ef5cd1ee9b8f
    }


    // =========================================================================
    // 2. MÉTHODES DE PAIEMENT ET CRÉATION (Stripe & Solde)
    // =========================================================================

    [HttpPost("create-update-checkout-session")]
    public async Task<IActionResult> CreateUpdateCheckoutSession([FromBody] ReservationCreateDto dto)
    {
        if (!dto.Idreservation.HasValue) return BadRequest("ID de réservation manquant.");

        var existingRes = await _dbContext.Reservations
            .Include(r => r.Transactions)
            .Include(r => r.Inclures)
            .Include(r => r.IddatedebutreservationNavigation)
            .Include(r => r.IddatefinreservationNavigation)
            .FirstOrDefaultAsync(r => r.Idreservation == dto.Idreservation);
            
        if (existingRes == null) return NotFound("Réservation introuvable.");

        var annonce = await _dbContext.Annonces.FindAsync(dto.Idannonce);
        if (annonce == null) return NotFound("Annonce introuvable.");

        var utilisateur = await _dbContext.Utilisateurs.FindAsync(existingRes.Idutilisateur);
        if (utilisateur == null) return NotFound("Utilisateur propriétaire introuvable.");

        // Calcul du nouveau montant d'acompte
        var voyageurs = dto.Inclures ?? new List<InclureCreateDto>();
        int totalAdults = voyageurs.FirstOrDefault(i => i.Idtypevoyageur == 1)?.Nombrevoyageur ?? 1;
        int totalEnfants = voyageurs.FirstOrDefault(i => i.Idtypevoyageur == 2)?.Nombrevoyageur ?? 0;

        int nights = (dto.DateFin - dto.DateDebut).Days;
        if (nights <= 0) nights = 1;

        decimal totalRent = annonce.Prixnuitee * nights;
        decimal serviceFee = totalRent * 0.14m;
        decimal touristTax = 4.00m * nights * totalAdults;
        decimal newDepositAmount = serviceFee + (totalRent * 0.35m) + touristTax;

        decimal alreadyPaid = existingRes.Transactions.Sum(t => t.Montanttransaction);
        
        // --- FALLBACK POUR ANCIENNES RÉSERVATIONS ---
        if (alreadyPaid <= 0)
        {
            // Si pas de transactions, on estime ce qui a dû être payé initialement
            int oldAdults = existingRes.Inclures.FirstOrDefault(i => i.Idtypevoyageur == 1)?.Nombrevoyageur ?? 1;
            int oldNights = 1;
            if (existingRes.IddatedebutreservationNavigation?.Date1 != null && existingRes.IddatefinreservationNavigation?.Date1 != null)
            {
                oldNights = (existingRes.IddatefinreservationNavigation.Date1.Value.ToDateTime(TimeOnly.MinValue) - 
                             existingRes.IddatedebutreservationNavigation.Date1.Value.ToDateTime(TimeOnly.MinValue)).Days;
            }
            if (oldNights <= 0) oldNights = 1;

            decimal oldTotalRent = annonce.Prixnuitee * oldNights;
            decimal oldServiceFee = oldTotalRent * 0.14m;
            decimal oldTouristTax = 4.00m * oldNights * oldAdults;
            alreadyPaid = oldServiceFee + (oldTotalRent * 0.35m) + oldTouristTax;
            
            Console.WriteLine($"[DEBUG] Fallback calculation for Res {existingRes.Idreservation}: Estimated Paid={alreadyPaid}");
        }

        decimal supplementAmount = newDepositAmount - alreadyPaid;

        Console.WriteLine($"[DEBUG] Update Reservation {dto.Idreservation}: New Deposit={newDepositAmount}, Already Paid={alreadyPaid}, Supplement={supplementAmount}");

        // --- CAS A : Remboursement (Si nouveau montant < déjà payé) ---
        if (supplementAmount < 0)
        {
            decimal refundAmount = Math.Abs(supplementAmount);
            Console.WriteLine($"[DEBUG] Refund triggered for User {utilisateur.Idutilisateur}: Current Solde={utilisateur.Solde}, Refund={refundAmount}");
            
            utilisateur.Solde += refundAmount;
            _dbContext.Utilisateurs.Update(utilisateur); // Force tracking update

            var result = await UpdateReservationInternal(existingRes, dto);
            
            // Ajouter la transaction de remboursement
            var dToday = await GetOrCreateDate(DateOnly.FromDateTime(DateTime.Now));
            _dbContext.Transactions.Add(new Transaction
            {
                Iddate = dToday.Iddate,
                Idreservation = existingRes.Idreservation,
                Idutilisateur = utilisateur.Idutilisateur,
                Montanttransaction = -refundAmount
            });
            await _dbContext.SaveChangesAsync();

            Console.WriteLine($"[DEBUG] Refund saved. New Solde={utilisateur.Solde}");

            return Ok(new { url = "http://localhost:5173/my-reservations?payment=success", message = $"La modification a été enregistrée. Un remboursement de {refundAmount:F2}€ a été ajouté à votre solde." });
        }

        // --- CAS B : Pas de supplément à payer (Équilibre) ---
        if (supplementAmount == 0)
        {
            return await UpdateReservationInternal(existingRes, dto);
        }

        decimal soldeDisponible = utilisateur.Solde;

        // --- CAS C : Paiement par Solde ---
        if (soldeDisponible >= supplementAmount)
        {
            Console.WriteLine($"[DEBUG] Solde payment triggered for User {utilisateur.Idutilisateur}: Current Solde={utilisateur.Solde}, Deducting={supplementAmount}");
            utilisateur.Solde -= supplementAmount;
            _dbContext.Utilisateurs.Update(utilisateur);

            var result = await UpdateReservationInternal(existingRes, dto);
            
            // Ajouter la transaction du supplément
            var dToday = await GetOrCreateDate(DateOnly.FromDateTime(DateTime.Now));
            _dbContext.Transactions.Add(new Transaction
            {
                Iddate = dToday.Iddate,
                Idreservation = existingRes.Idreservation,
                Idutilisateur = utilisateur.Idutilisateur,
                Montanttransaction = supplementAmount
            });
            await _dbContext.SaveChangesAsync();

            Console.WriteLine($"[DEBUG] Solde payment saved. New Solde={utilisateur.Solde}");
            
            return result;
        }

        // --- CAS D : Stripe ---
        decimal soldeAUtiliser = 0;
        decimal montantRestantStripe = supplementAmount;

        if (soldeDisponible > 0)
        {
            soldeAUtiliser = soldeDisponible;
            montantRestantStripe = supplementAmount - soldeAUtiliser;
        }

        var metadata = new Dictionary<string, string>
        {
            { "type", "update" },
            { "idreservation", existingRes.Idreservation.ToString() },
            { "idannonce", dto.Idannonce.ToString() },
            { "idutilisateur", dto.Idutilisateur.ToString() },
            { "dateDebut", dto.DateDebut.ToString("yyyy-MM-dd") },
            { "dateFin", dto.DateFin.ToString("yyyy-MM-dd") },
            { "nomclient", dto.Nomclient ?? "Inconnu" },
            { "prenomclient", dto.Prenomclient ?? "Inconnu" },
            { "telephone", dto.Telephoneclient ?? "" },
            { "adultes", totalAdults.ToString() },
            { "enfants", totalEnfants.ToString() },
            { "bebes", (voyageurs.FirstOrDefault(i => i.Idtypevoyageur == 3)?.Nombrevoyageur ?? 0).ToString() },
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
                            Name = $"Supplément réservation - {annonce.Titreannonce}",
                            Description = $"Mise à jour des dates/voyageurs. Solde déduit : {soldeAUtiliser}€"
                        },
                    },
                    Quantity = 1,
                },
            },
            Mode = "payment",
            Metadata = metadata,
            SuccessUrl = "http://localhost:5173/my-reservations?session_id={CHECKOUT_SESSION_ID}",
            CancelUrl = "http://localhost:5173/reservation/cancel",
        };

        var service = new SessionService();
        Session session = await service.CreateAsync(options);
        return Ok(new { url = session.Url });
    }

    private async Task<IActionResult> UpdateReservationInternal(Reservation existingRes, ReservationCreateDto dto)
    {
        existingRes.Nomclient = dto.Nomclient;
        existingRes.Prenomclient = dto.Prenomclient;
        existingRes.Telephoneclient = dto.Telephoneclient;

        var dDebut = await GetOrCreateDate(DateOnly.FromDateTime(dto.DateDebut));
        var dFin = await GetOrCreateDate(DateOnly.FromDateTime(dto.DateFin));
        existingRes.Iddatedebutreservation = dDebut.Iddate;
        existingRes.Iddatefinreservation = dFin.Iddate;

        _dbContext.Inclures.RemoveRange(existingRes.Inclures);
        foreach (var incDto in dto.Inclures)
        {
            _dbContext.Inclures.Add(new Inclure
            {
                Idreservation = existingRes.Idreservation,
                Idtypevoyageur = incDto.Idtypevoyageur,
                Nombrevoyageur = incDto.Nombrevoyageur
            });
        }

        await _dbContext.SaveChangesAsync();
        return Ok(new { url = "http://localhost:5173/my-reservations?payment=success" });
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
            Console.WriteLine($"[DEBUG] Deducting solde from ConfirmPayment: User={utilisateur.Idutilisateur}, Current={utilisateur.Solde}, Used={soldeUsed}");
            utilisateur.Solde -= soldeUsed;
            if (utilisateur.Solde < 0) utilisateur.Solde = 0;
            _dbContext.Utilisateurs.Update(utilisateur);
            Console.WriteLine($"[DEBUG] New solde after ConfirmPayment: {utilisateur.Solde}");
        }

        var dateDebut = DateOnly.Parse(meta["dateDebut"]);
        var dateFin = DateOnly.Parse(meta["dateFin"]);
        var dateDebutRecord = await GetOrCreateDate(dateDebut);
        var dateFinRecord = await GetOrCreateDate(dateFin);
        var dateAujourdhui = await GetOrCreateDate(DateOnly.FromDateTime(DateTime.Now));

        Reservation reservation;
        if (meta.ContainsKey("type") && meta["type"] == "update")
        {
            int idRes = int.Parse(meta["idreservation"]);
            reservation = await _dbContext.Reservations.Include(r => r.Inclures).FirstOrDefaultAsync(r => r.Idreservation == idRes);
            if (reservation == null) return NotFound("Réservation à mettre à jour introuvable.");

            reservation.Iddatedebutreservation = dateDebutRecord.Iddate;
            reservation.Iddatefinreservation = dateFinRecord.Iddate;
            reservation.Nomclient = meta["nomclient"];
            reservation.Prenomclient = meta["prenomclient"];
            reservation.Telephoneclient = meta["telephone"];

            _dbContext.Inclures.RemoveRange(reservation.Inclures);
        }
        else
        {
            reservation = new Reservation
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
        }

        await _dbContext.SaveChangesAsync();

        _dbContext.Inclures.Add(new Inclure { Idreservation = reservation.Idreservation, Idtypevoyageur = 1, Nombrevoyageur = int.Parse(meta["adultes"]) });
        if (int.Parse(meta["enfants"]) > 0)
            _dbContext.Inclures.Add(new Inclure { Idreservation = reservation.Idreservation, Idtypevoyageur = 2, Nombrevoyageur = int.Parse(meta["enfants"]) });
        if (meta.ContainsKey("bebes") && int.Parse(meta["bebes"]) > 0)
            _dbContext.Inclures.Add(new Inclure { Idreservation = reservation.Idreservation, Idtypevoyageur = 3, Nombrevoyageur = int.Parse(meta["bebes"]) });

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

        return Ok(new { message = meta.ContainsKey("type") ? "Réservation mise à jour !" : "Réservation créée avec succès !" });
    }


    // =========================================================================
    // 3. MÉTHODES DE MODIFICATION ET SUPPRESSION
    // =========================================================================

    [HttpPut("{id}")]
    public async Task<IActionResult> PutReservation(int id, Reservation reservation)
    {
        if (id != reservation.Idreservation)
        {
            return BadRequest("L'ID de la réservation ne correspond pas.");
        }

        var existingReservation = await _dbContext.Reservations
            .Include(r => r.Inclures)
            .FirstOrDefaultAsync(r => r.Idreservation == id);

        if (existingReservation == null)
        {
            return NotFound("Réservation introuvable.");
        }

        // 1. Mise à jour des champs simples
        existingReservation.Nomclient = reservation.Nomclient;
        existingReservation.Prenomclient = reservation.Prenomclient;
        existingReservation.Telephoneclient = reservation.Telephoneclient;

        // 2. Mise à jour des dates (via GetOrCreateDate)
        if (reservation.IddatedebutreservationNavigation != null && reservation.IddatedebutreservationNavigation.Date1.HasValue)
        {
            var newDateDebut = await GetOrCreateDate(reservation.IddatedebutreservationNavigation.Date1.Value);
            existingReservation.Iddatedebutreservation = newDateDebut.Iddate;
        }

        if (reservation.IddatefinreservationNavigation != null && reservation.IddatefinreservationNavigation.Date1.HasValue)
        {
            var newDateFin = await GetOrCreateDate(reservation.IddatefinreservationNavigation.Date1.Value);
            existingReservation.Iddatefinreservation = newDateFin.Iddate;
        }

        // 3. Mise à jour des voyageurs (Inclures)
        // On supprime les anciens et on ajoute les nouveaux
        _dbContext.Inclures.RemoveRange(existingReservation.Inclures);
        foreach (var inc in reservation.Inclures)
        {
            inc.Idreservation = id; // Sécurité
            _dbContext.Inclures.Add(inc);
        }

        try
        {
            await _dbContext.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[ERROR] Failed to update reservation {id}: {ex.Message}");
            if (!_dbContext.Reservations.Any(e => e.Idreservation == id))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return NoContent();
    }

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

    private static ReservationResponseDto MapReservation(Reservation reservation)
    {
        return new ReservationResponseDto
        {
            Idreservation = reservation.Idreservation,
            Idannonce = reservation.Idannonce,
            Iddatedebutreservation = reservation.Iddatedebutreservation,
            Iddatefinreservation = reservation.Iddatefinreservation,
            Idutilisateur = reservation.Idutilisateur,
            Nomclient = reservation.Nomclient,
            Prenomclient = reservation.Prenomclient,
            Telephoneclient = reservation.Telephoneclient,
            IdannonceNavigation = reservation.IdannonceNavigation == null ? null : new ReservationAnnonceDto
            {
                Idannonce = reservation.IdannonceNavigation.Idannonce,
                Idutilisateur = reservation.IdannonceNavigation.Idutilisateur,
                Titreannonce = reservation.IdannonceNavigation.Titreannonce,
                Prixnuitee = reservation.IdannonceNavigation.Prixnuitee,
                Capacite = reservation.IdannonceNavigation.Capacite,
                IdadresseNavigation = reservation.IdannonceNavigation.IdadresseNavigation == null ? null : new ReservationAdresseDto
                {
                    Idadresse = reservation.IdannonceNavigation.IdadresseNavigation.Idadresse,
                    IdvilleNavigation = reservation.IdannonceNavigation.IdadresseNavigation.IdvilleNavigation == null ? null : new ReservationVilleDto
                    {
                        Idville = reservation.IdannonceNavigation.IdadresseNavigation.IdvilleNavigation.Idville,
                        Nomville = reservation.IdannonceNavigation.IdadresseNavigation.IdvilleNavigation.Nomville,
                    }
                },
                Photos = reservation.IdannonceNavigation.Photos
                    .Select(photo => new ReservationPhotoDto
                    {
                        Idphoto = photo.Idphoto,
                        Lienphoto = photo.Lienphoto,
                    })
                    .ToList(),
            },
            IddatedebutreservationNavigation = reservation.IddatedebutreservationNavigation == null ? null : new ReservationDateDto
            {
                Iddate = reservation.IddatedebutreservationNavigation.Iddate,
                Date1 = reservation.IddatedebutreservationNavigation.Date1,
            },
            IddatefinreservationNavigation = reservation.IddatefinreservationNavigation == null ? null : new ReservationDateDto
            {
                Iddate = reservation.IddatefinreservationNavigation.Iddate,
                Date1 = reservation.IddatefinreservationNavigation.Date1,
            },
            Inclures = reservation.Inclures
                .Select(inclure => new ReservationInclureDto
                {
                    Idreservation = inclure.Idreservation,
                    Idtypevoyageur = inclure.Idtypevoyageur,
                    Nombrevoyageur = inclure.Nombrevoyageur,
                    IdtypevoyageurNavigation = inclure.IdtypevoyageurNavigation == null ? null : new ReservationTypeVoyageurDto
                    {
                        Idtypevoyageur = inclure.IdtypevoyageurNavigation.Idtypevoyageur,
                        Nomtypevoyageur = inclure.IdtypevoyageurNavigation.Nomtypevoyageur,
                    }
                })
                .ToList(),
        };
    }
}

public class PaymentConfirmDto
{
    public string SessionId { get; set; }
}