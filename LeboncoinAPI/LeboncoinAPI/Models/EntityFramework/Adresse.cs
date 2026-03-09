using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("adresse")]
public partial class Adresse
{
    [Key]
    [Column("idadresse")]
    [Required]
    public int AdresseId { get; set; }

    [Column("idville")]
    public int VilleId { get; set; }

    [Column("numerorue")]
    public int? NumeroRue { get; set; }

    [Column("nomrue")]
    [StringLength(39,ErrorMessage = "La longueur du nom de la rue doit être inférieure à 39 caractères")]
    public string? NomRue { get; set; }

    // --- Navigation Properties ---

    [ForeignKey(nameof(VilleId))]
    public virtual Ville VilleAdresse { get; set; } = null!;
}