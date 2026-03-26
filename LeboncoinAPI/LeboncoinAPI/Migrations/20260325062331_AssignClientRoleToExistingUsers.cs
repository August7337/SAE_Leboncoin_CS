using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class AssignClientRoleToExistingUsers : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
                INSERT INTO attribuer (idutilisateur, idrole)
                SELECT DISTINCT u.idutilisateur, 2
                FROM utilisateur u
                WHERE u.idutilisateur NOT IN (
                    SELECT DISTINCT idutilisateur FROM attribuer
                )
                ON CONFLICT DO NOTHING;
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
                DELETE FROM attribuer
                WHERE idrole = 2;
            ");
        }
    }
}
