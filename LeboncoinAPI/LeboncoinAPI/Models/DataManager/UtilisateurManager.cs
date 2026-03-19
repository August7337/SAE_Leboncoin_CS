using BCrypt.Net;
using LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.DTOs.LeboncoinAPI.Models.DTOs;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Formats.Asn1;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
namespace LeboncoinAPI.Models.DataManager;

public class UtilisateurManager : IDataUtilisateurRepository<Utilisateur>
{
    private readonly LeboncoinDBContext _dbContext;

    private static readonly Dictionary<string, (string DepName, string RegName)> GeoData = new()
{{"01", ("Ain", "Auvergne-Rhône-Alpes")}, {"02", ("Aisne", "Hauts-de-France")}, {"03", ("Allier", "Auvergne-Rhône-Alpes")},{"04", ("Alpes-de-Haute-Provence", "Provence-Alpes-Côte d'Azur")}, {"05", ("Hautes-Alpes", "Provence-Alpes-Côte d'Azur")},{"06", ("Alpes-Maritimes", "Provence-Alpes-Côte d'Azur")}, {"07", ("Ardèche", "Auvergne-Rhône-Alpes")},{"08", ("Ardennes", "Grand Est")}, {"09", ("Ariège", "Occitanie")}, {"10", ("Aube", "Grand Est")},{"11", ("Aude", "Occitanie")}, {"12", ("Aveyron", "Occitanie")}, {"13", ("Bouches-du-Rhône", "Provence-Alpes-Côte d'Azur")},{"14", ("Calvados", "Normandie")}, {"15", ("Cantal", "Auvergne-Rhône-Alpes")}, {"16", ("Charente", "Nouvelle-Aquitaine")},{"17", ("Charente-Maritime", "Nouvelle-Aquitaine")}, {"18", ("Cher", "Centre-Val de Loire")}, {"19", ("Corrèze", "Nouvelle-Aquitaine")},{"2A", ("Corse-du-Sud", "Corse")}, {"2B", ("Haute-Corse", "Corse")}, {"21", ("Côte-d'Or", "Bourgogne-Franche-Comté")},{"22", ("Côtes-d'Armor", "Bretagne")}, {"23", ("Creuse", "Nouvelle-Aquitaine")}, {"24", ("Dordogne", "Nouvelle-Aquitaine")},{"25", ("Doubs", "Bourgogne-Franche-Comté")}, {"26", ("Drôme", "Auvergne-Rhône-Alpes")}, {"27", ("Eure", "Normandie")},{"28", ("Eure-et-Loir", "Centre-Val de Loire")}, {"29", ("Finistère", "Bretagne")}, {"30", ("Gard", "Occitanie")},{"31", ("Haute-Garonne", "Occitanie")}, {"32", ("Gers", "Occitanie")}, {"33", ("Gironde", "Nouvelle-Aquitaine")},{"34", ("Hérault", "Occitanie")}, {"35", ("Ille-et-Vilaine", "Bretagne")}, {"36", ("Indre", "Centre-Val de Loire")},{"37", ("Indre-et-Loire", "Centre-Val de Loire")}, {"38", ("Isère", "Auvergne-Rhône-Alpes")}, {"39", ("Jura", "Bourgogne-Franche-Comté")},{"40", ("Landes", "Nouvelle-Aquitaine")}, {"41", ("Loir-et-Cher", "Centre-Val de Loire")}, {"42", ("Loire", "Auvergne-Rhône-Alpes")},{"43", ("Haute-Loire", "Auvergne-Rhône-Alpes")}, {"44", ("Loire-Atlantique", "Pays de la Loire")}, {"45", ("Loiret", "Centre-Val de Loire")},{"46", ("Lot", "Occitanie")}, {"47", ("Lot-et-Garonne", "Nouvelle-Aquitaine")}, {"48", ("Lozère", "Occitanie")},{"49", ("Maine-et-Loire", "Pays de la Loire")}, {"50", ("Manche", "Normandie")}, {"51", ("Marne", "Grand Est")},{"52", ("Haute-Marne", "Grand Est")}, {"53", ("Mayenne", "Pays de la Loire")}, {"54", ("Meurthe-et-Moselle", "Grand Est")},{"55", ("Meuse", "Grand Est")}, {"56", ("Morbihan", "Bretagne")}, {"57", ("Moselle", "Grand Est")},{"58", ("Nièvre", "Bourgogne-Franche-Comté")}, {"59", ("Nord", "Hauts-de-France")}, {"60", ("Oise", "Hauts-de-France")},{"61", ("Orne", "Normandie")}, {"62", ("Pas-de-Calais", "Hauts-de-France")}, {"63", ("Puy-de-Dôme", "Auvergne-Rhône-Alpes")},{"64", ("Pyrénées-Atlantiques", "Nouvelle-Aquitaine")}, {"65", ("Hautes-Pyrénées", "Occitanie")}, {"66", ("Pyrénées-Orientales", "Occitanie")},{"67", ("Bas-Rhin", "Grand Est")}, {"68", ("Haut-Rhin", "Grand Est")}, {"69", ("Rhône", "Auvergne-Rhône-Alpes")},{"70", ("Haute-Saône", "Bourgogne-Franche-Comté")}, {"71", ("Saône-et-Loire", "Bourgogne-Franche-Comté")}, {"72", ("Sarthe", "Pays de la Loire")},{"73", ("Savoie", "Auvergne-Rhône-Alpes")}, {"74", ("Haute-Savoie", "Auvergne-Rhône-Alpes")}, {"75", ("Paris", "Île-de-France")},{"76", ("Seine-Maritime", "Normandie")}, {"77", ("Seine-et-Marne", "Île-de-France")}, {"78", ("Yvelines", "Île-de-France")},{"79", ("Deux-Sèvres", "Nouvelle-Aquitaine")}, {"80", ("Somme", "Hauts-de-France")}, {"81", ("Tarn", "Occitanie")},{"82", ("Tarn-et-Garonne", "Occitanie")}, {"83", ("Var", "Provence-Alpes-Côte d'Azur")}, {"84", ("Vaucluse", "Provence-Alpes-Côte d'Azur")},{"85", ("Vendée", "Pays de la Loire")}, {"86", ("Vienne", "Nouvelle-Aquitaine")}, {"87", ("Haute-Vienne", "Nouvelle-Aquitaine")},{"88", ("Vosges", "Grand Est")}, {"89", ("Yonne", "Bourgogne-Franche-Comté")}, {"90", ("Territoire de Belfort", "Bourgogne-Franche-Comté")},{"91", ("Essonne", "Île-de-France")}, {"92", ("Hauts-de-Seine", "Île-de-France")}, {"93", ("Seine-Saint-Denis", "Île-de-France")},{"94", ("Val-de-Marne", "Île-de-France")}, {"95", ("Val-d'Oise", "Île-de-France")}
};
    public UtilisateurManager(LeboncoinDBContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<IEnumerable<Utilisateur>> GetAllAsync()
    {
      
        return await _dbContext.Utilisateurs.ToListAsync();
    }

    public async Task<Utilisateur?> GetByIdAsync(int id)
    {
        
        return await _dbContext.Utilisateurs.FindAsync(id);
    }

    public async Task<Utilisateur?> GetPublicProfileAsync(int id)
    {
        return await _dbContext.Utilisateurs
            .Include(u => u.IddateNavigation)
            .Include(u => u.Annonces)
            .Include(u => u.Avis)
            .FirstOrDefaultAsync(u => u.Idutilisateur == id);
    }

    public async Task AddAsync(Utilisateur entity)
    {
      
        var today = DateOnly.FromDateTime(DateTime.Now);
        entity.IddateNavigation = await _dbContext.Dates.FirstOrDefaultAsync(d => d.Date1 == today)
                                 ?? new Date { Date1 = today };

    
        var adr = entity.IdadresseNavigation;
        var ville = adr.IdvilleNavigation;
        var dep = ville.IddepartementNavigation;
        var reg = dep.IdregionNavigation;

        
        if (GeoData.TryGetValue(dep.Numerodepartement, out var geo))
        {
            dep.Nomdepartement = geo.DepName;
            reg.Nomregion = geo.RegName;
        }

        
        var existingReg = await _dbContext.Regions.FirstOrDefaultAsync(r => r.Nomregion == reg.Nomregion);
        if (existingReg != null)
        {
            dep.IdregionNavigation = existingReg;
        }

       
        var existingDep = await _dbContext.Departements.FirstOrDefaultAsync(d => d.Numerodepartement == dep.Numerodepartement);
        if (existingDep != null)
        {
            ville.IddepartementNavigation = existingDep;
        }

       
        var existingVille = await _dbContext.Villes
            .FirstOrDefaultAsync(v => v.Nomville.ToLower() == ville.Nomville.ToLower() && v.Codepostal == ville.Codepostal);
        if (existingVille != null)
        {
            adr.IdvilleNavigation = existingVille;
        }


        entity.Password = BCrypt.Net.BCrypt.HashPassword(entity.Password);

        await _dbContext.Utilisateurs.AddAsync(entity);
        await _dbContext.SaveChangesAsync();
    }




    public async Task UpdateAsync(Utilisateur entityToUpdate, Utilisateur entity)
    {

        _dbContext.Entry(entityToUpdate).CurrentValues.SetValues(entity);
        await _dbContext.SaveChangesAsync();
    }


    public async Task DeleteAsync(Utilisateur entity)
    {
        _dbContext.Utilisateurs.Remove(entity);
        await _dbContext.SaveChangesAsync();
    }

    public async Task<Utilisateur?> GetByEmailAsync(string email)
    {
        return await _dbContext.Utilisateurs
            .Include(u => u.Particulier)
            .Include(u => u.Professionnel)
            .FirstOrDefaultAsync(u => u.Email.ToLower() == email.ToLower());
    }

    public async Task<bool> RegisterFullParticulierAsync(RegisterParticulierDTO dto)
    {
        using var transaction = await _dbContext.Database.BeginTransactionAsync();
        try
        {

            var nouvelUtilisateur = new Utilisateur
            {
                Pseudonyme = dto.Pseudonyme,
                Email = dto.Email,
                Password = dto.Password, // Sera haché dans AddAsync
                Telephoneutilisateur = dto.Telephoneutilisateur,
                IdadresseNavigation = BuildAdresseFromDto(dto)
            };


            await AddAsync(nouvelUtilisateur);


            var bDay = DateOnly.FromDateTime(dto.DateNaissance);
            var dateEntity = await _dbContext.Dates.FirstOrDefaultAsync(d => d.Date1 == bDay)
                             ?? new Date { Date1 = bDay };

            if (dateEntity.Iddate == 0)
            {
                _dbContext.Dates.Add(dateEntity);
                await _dbContext.SaveChangesAsync();
            }


            var particulier = new Particulier
            {
                Idutilisateur = nouvelUtilisateur.Idutilisateur,
                Nomutilisateur = dto.Nomutilisateur,
                Prenomutilisateur = dto.Prenomutilisateur,
                Civilite = dto.Civilite,
                Iddate = dateEntity.Iddate
            };

            _dbContext.Particuliers.Add(particulier);
            await _dbContext.SaveChangesAsync();

            await transaction.CommitAsync();
            return true;
        }
        catch (Exception)
        {
            await transaction.RollbackAsync();
            throw;
        }
    }
    public async Task UpdateProfileAsync(Utilisateur existingUser, UtilisateurUpdateDTO dto)
    {
        
        if (existingUser.Particulier == null)
        {
            await _dbContext.Entry(existingUser).Reference(u => u.Particulier).LoadAsync();
        }

    
        existingUser.Pseudonyme = dto.Pseudonyme;
        existingUser.Email = dto.Email;
        existingUser.Telephoneutilisateur = dto.Telephoneutilisateur;

       
        if (existingUser.Particulier != null)
        {
            existingUser.Particulier.Civilite = dto.Civilite;
            existingUser.Particulier.Nomutilisateur = dto.Nomutilisateur;
            existingUser.Particulier.Prenomutilisateur = dto.Prenomutilisateur;
        }

        await _dbContext.SaveChangesAsync();
    }

    private static Adresse BuildAdresseFromDto(RegisterParticulierDTO dto)
    {
    
        var match = Regex.Match(dto.Rue ?? string.Empty, "^(\\d+)\\s*(.*)$");
        int num = match.Success && int.TryParse(match.Groups[1].Value, out var n) ? n : 0;
        string street = match.Success ? match.Groups[2].Value : dto.Rue;

        var depCode = !string.IsNullOrEmpty(dto.CodePostal) && dto.CodePostal.Length >= 2
            ? dto.CodePostal.Substring(0, 2)
            : "00";

        return new Adresse
        {
            Numerorue = num,
            Nomrue = street,
            IdvilleNavigation = new Ville
            {
                Nomville = dto.Ville,
                Codepostal = dto.CodePostal,
                IddepartementNavigation = new Departement
                {
                    Numerodepartement = depCode,
                    IdregionNavigation = new Region()
                }
            }
        };
    }
    public async Task<bool> RegisterFullProfessionnelAsync(RegisterProfessionnelDTO dto)
    {
        using var transaction = await _dbContext.Database.BeginTransactionAsync();
        try
        {

            var nouvelUtilisateur = new Utilisateur
            {
                Pseudonyme = dto.Pseudonyme,
                Email = dto.Email,
                Password = dto.Password,
                Telephoneutilisateur = dto.Telephoneutilisateur,
                IdadresseNavigation = BuildAdresseFromDto(new RegisterParticulierDTO
                {
                    Rue = dto.Rue,
                    Ville = dto.Ville,
                    CodePostal = dto.CodePostal
                })
            };

            await AddAsync(nouvelUtilisateur);


            var professionnel = new Professionnel
            {
                Idutilisateur = nouvelUtilisateur.Idutilisateur,
                Numsiret = dto.Numsiret,
                Nomsociete = dto.Nomsociete,
                Secteuractivite = dto.Secteuractivite
            };

            _dbContext.Professionnels.Add(professionnel);
            await _dbContext.SaveChangesAsync();

            await transaction.CommitAsync();
            return true;
        }
        catch (DbUpdateException ex)
        {
            await transaction.RollbackAsync();
            var inner = ex.InnerException?.Message ?? "";

            if (inner.Contains("utilisateur_email_key"))
                throw new RegistrationConflictException("email", "Cet email est déjà utilisé.");

          
            if (inner.Contains("utilisateur_telephoneutilisateur_key"))
                throw new RegistrationConflictException("telephoneUtilisateur", "Ce numéro de téléphone est déjà utilisé.");

            
            if (inner.Contains("professionnel_numsiret_key"))
                throw new RegistrationConflictException("numsiret", "Ce numéro SIRET est déjà utilisé.");

            throw;
        }
        catch (Exception)
        {
            await transaction.RollbackAsync();
            throw;
        }
    }
    public class RegistrationConflictException : Exception
    {
        public string TargetField { get; }
        public RegistrationConflictException(string target, string message) : base(message)
        {
            TargetField = target;
        }
    }
}