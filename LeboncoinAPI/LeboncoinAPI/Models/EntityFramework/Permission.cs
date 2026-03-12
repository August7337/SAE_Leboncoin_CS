using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Models.EntityFramework;

[Table("permission")]
public partial class Permission
{
    [Key]
    [Column("idpermission")]
    public int Idpermission { get; set; }

    [Column("nompermission")]
    [StringLength(100)]
    public string? Nompermission { get; set; }

    [ForeignKey("Idpermission")]
    [InverseProperty("Idpermissions")]
    public virtual ICollection<Role> Idroles { get; set; } = new List<Role>();
}
