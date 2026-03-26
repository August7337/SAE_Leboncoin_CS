using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddIncidentHistoriqueAndAgentAssignment : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "originephoto",
                table: "photo",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "idagentassigne",
                table: "incident",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "incident_historique",
                columns: table => new
                {
                    idincidentshistorique = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idincident = table.Column<int>(type: "integer", nullable: false),
                    idstatutincident = table.Column<int>(type: "integer", nullable: false),
                    datechangement = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    idutilisateurmodificateur = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_incident_historique", x => x.idincidentshistorique);
                    table.ForeignKey(
                        name: "fk_incident_historique_incident",
                        column: x => x.idincident,
                        principalTable: "incident",
                        principalColumn: "idincident",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_incident_historique_statut",
                        column: x => x.idstatutincident,
                        principalTable: "statut_incident",
                        principalColumn: "idstatutincident",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_incident_historique_utilisateur",
                        column: x => x.idutilisateurmodificateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_incident_idagentassigne",
                table: "incident",
                column: "idagentassigne");

            migrationBuilder.CreateIndex(
                name: "idx_incident_historique_idincident",
                table: "incident_historique",
                column: "idincident");

            migrationBuilder.CreateIndex(
                name: "IX_incident_historique_idstatutincident",
                table: "incident_historique",
                column: "idstatutincident");

            migrationBuilder.CreateIndex(
                name: "IX_incident_historique_idutilisateurmodificateur",
                table: "incident_historique",
                column: "idutilisateurmodificateur");

            migrationBuilder.AddForeignKey(
                name: "FK_incident_utilisateur_idagentassigne",
                table: "incident",
                column: "idagentassigne",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_incident_utilisateur_idagentassigne",
                table: "incident");

            migrationBuilder.DropTable(
                name: "incident_historique");

            migrationBuilder.DropIndex(
                name: "IX_incident_idagentassigne",
                table: "incident");

            migrationBuilder.DropColumn(
                name: "originephoto",
                table: "photo");

            migrationBuilder.DropColumn(
                name: "idagentassigne",
                table: "incident");
        }
    }
}
