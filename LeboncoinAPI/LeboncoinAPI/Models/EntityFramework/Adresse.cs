using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("adresse")]
[Index("Idville", Name = "idx_adresse_idville")]
public partial class Adresse
{
    [Key]
    [Column("idadresse")]
    public int Idadresse { get; set; }

    [Column("idville")]
    public int Idville { get; set; }

    [Column("numerorue")]
    public int? Numerorue { get; set; }

    [Column("nomrue")]
    [StringLength(39)]
    public string? Nomrue { get; set; }

    [InverseProperty("IdadresseNavigation")]
    public virtual ICollection<Annonce> Annonces { get; set; } = new List<Annonce>();

    [ForeignKey("Idville")]
    [InverseProperty("Adresses")]
    public virtual Ville IdvilleNavigation { get; set; } = null!;

    [InverseProperty("IdadresseNavigation")]
    public virtual ICollection<Utilisateur> Utilisateurs { get; set; } = new List<Utilisateur>();
}
