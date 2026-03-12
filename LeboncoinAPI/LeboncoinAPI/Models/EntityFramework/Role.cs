using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("role")]
public partial class Role
{
    [Key]
    [Column("idrole")]
    public int Idrole { get; set; }

    [Column("nomrole")]
    [StringLength(100)]
    public string? Nomrole { get; set; }

    [ForeignKey("Idrole")]
    [InverseProperty("Idroles")]
    public virtual ICollection<Permission> Idpermissions { get; set; } = new List<Permission>();

    [ForeignKey("Idrole")]
    [InverseProperty("Idroles")]
    public virtual ICollection<Utilisateur> Idutilisateurs { get; set; } = new List<Utilisateur>();
}
