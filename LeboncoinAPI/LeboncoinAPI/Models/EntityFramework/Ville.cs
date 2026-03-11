using LeboncoinAPI.Models.EntityFramework;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("ville")]
public partial class Ville
{
    [Key]
    [Column("idville")]
    public int VilleId { get; set; }

    [Column("iddepartement")]
    public int DepartementId { get; set; }

    [Required]
    [Column("codepostal", TypeName = "char(5)")]

    public string CodePostal { get; set; } = null!;

    [Required]
    [Column("nomville")]
    [StringLength(40,ErrorMessage = "Le nom doit avoir moins de 40 caractères")]
    public string NomVille { get; set; } = null!;

    [Column("taxedesejour", TypeName = "decimal(10,2)")]
    [Range(0, double.MaxValue)]
    public decimal TaxeDeSejour { get; set; }

    // Navigation vers Adresse (One to Many)
    [InverseProperty("VilleAdresse")]
    public virtual ICollection<Adresse> Adresses { get; set; } = new List<Adresse>();

    [ForeignKey(nameof(DepartementId))]
    public virtual Departement DepartementAssocie { get; set; } = null!;
}