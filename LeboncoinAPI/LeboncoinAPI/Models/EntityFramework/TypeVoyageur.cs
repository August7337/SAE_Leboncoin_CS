using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("typevoyageur")]
[Index("Nomtypevoyageur", Name = "typevoyageur_nomtypevoyageur_key", IsUnique = true)]
public partial class Typevoyageur
{
    [Key]
    [Column("idtypevoyageur")]
    public int Idtypevoyageur { get; set; }

    [Column("nomtypevoyageur")]
    [StringLength(30)]
    public string Nomtypevoyageur { get; set; } = null!;

    [InverseProperty("IdtypevoyageurNavigation")]
    public virtual ICollection<Inclure> Inclures { get; set; } = new List<Inclure>();
}
