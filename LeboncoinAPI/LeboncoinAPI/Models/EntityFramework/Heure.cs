using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("heure")]
public partial class Heure
{
    [Key]
    [Column("idheure")]
    public int Idheure { get; set; }

    [Column("heure")]
    public TimeOnly Heure1 { get; set; }

    [InverseProperty("IdheurearriveeNavigation")]
    public virtual ICollection<Annonce> AnnonceIdheurearriveeNavigations { get; set; } = new List<Annonce>();

    [InverseProperty("IdheuredepartNavigation")]
    public virtual ICollection<Annonce> AnnonceIdheuredepartNavigations { get; set; } = new List<Annonce>();
}
