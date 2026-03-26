using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

public enum OriginePhoto
{
    Locataire = 1,
    Proprietaire = 2
}

[Table("photo")]
public partial class Photo
{
    [Key]
    [Column("idphoto")]
    public int Idphoto { get; set; }

    [Column("idannonce")]
    public int? Idannonce { get; set; }

    [Column("idincident")]
    public int? Idincident { get; set; }

    [Column("lienphoto")]
    [StringLength(200)]
    public string? Lienphoto { get; set; }

    [Column("originephoto")]
    public int? Originephoto { get; set; } = (int)OriginePhoto.Locataire;

    [ForeignKey("Idannonce")]
    [InverseProperty("Photos")]
    public virtual Annonce? IdannonceNavigation { get; set; }

    [ForeignKey("Idincident")]
    [InverseProperty("Photos")]
    public virtual Incident? IdincidentNavigation { get; set; }
}
