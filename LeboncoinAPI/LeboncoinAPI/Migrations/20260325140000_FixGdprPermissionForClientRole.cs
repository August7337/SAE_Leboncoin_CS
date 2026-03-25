using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LeboncoinAPI.Migrations
{
    [DbContext(typeof(LeboncoinDBContext))]
    [Migration("20260325140000_FixGdprPermissionForClientRole")]
    public partial class FixGdprPermissionForClientRole : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // La migration AddGdprViewPermission est enregistrée dans __EFMigrationsHistory
            // mais ses deux INSERTs n'ont pas été persistés en base.
            // On force l'insertion des deux lignes manquantes avec ON CONFLICT DO NOTHING.
            migrationBuilder.Sql(@"
                INSERT INTO permission (idpermission, nompermission)
                VALUES (24, 'app.view.gdpr_data')
                ON CONFLICT DO NOTHING;
            ");
            migrationBuilder.Sql(@"
                INSERT INTO permettre (idpermission, idrole)
                VALUES (24, 2)
                ON CONFLICT DO NOTHING;
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 24, 2 });
        }
    }
}
