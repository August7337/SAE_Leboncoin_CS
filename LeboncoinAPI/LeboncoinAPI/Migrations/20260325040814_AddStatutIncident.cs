using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddStatutIncident : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "estclasse",
                table: "incident");

            migrationBuilder.DropColumn(
                name: "estrembourse",
                table: "incident");

            migrationBuilder.DropColumn(
                name: "estremisaucontentieux",
                table: "incident");

            migrationBuilder.CreateTable(
                name: "statut_incident",
                columns: table => new
                {
                    idstatutincident = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    code = table.Column<string>(type: "character varying(60)", maxLength: 60, nullable: false),
                    libelle = table.Column<string>(type: "character varying(120)", maxLength: 120, nullable: false),
                    ordre = table.Column<int>(type: "integer", nullable: false),
                    estfinal = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_statut_incident", x => x.idstatutincident);
                });

            migrationBuilder.InsertData(
                table: "statut_incident",
                columns: new[] { "idstatutincident", "code", "estfinal", "libelle", "ordre" },
                values: new object[,]
                {
                    { 1, "SIGNALE", false, "Signale", 1 },
                    { 2, "EN_ANALYSE_SERVICE_LOCATION", false, "En cours d'analyse par le service location", 2 },
                    { 3, "CLASSE_SANS_SUITE", true, "Classe sans suite", 3 },
                    { 4, "EN_ATTENTE_EXPLICATION_PROPRIETAIRE", false, "En attente de l'explication du proprietaire", 4 },
                    { 5, "EXPLICATION_PROPRIETAIRE_RECUE", false, "Explication du proprietaire recue", 5 },
                    { 6, "REMBOURSEMENT_ACCEPTE", false, "Remboursement accepte", 6 },
                    { 7, "REFUS_REMBOURSEMENT", false, "Remboursement refuse", 7 },
                    { 8, "EN_ATTENTE_RETOUR_LOUEUR", false, "En attente de la reponse du loueur", 8 },
                    { 9, "TRANSFERE_CONTENTIEUX", false, "Transfere au contentieux", 9 },
                    { 10, "CLOTURE_SANS_REMBOURSEMENT", true, "Cloture sans remboursement", 10 },
                    { 11, "PROCEDURE_JURIDIQUE_ENGAGEE", true, "Procedure juridique engagee", 11 },
                    { 12, "REMBOURSEMENT_EFFECTUE", true, "Remboursement effectue", 12 }
                });

            migrationBuilder.AddColumn<int>(
                name: "idstatutincident",
                table: "incident",
                type: "integer",
                nullable: false,
                defaultValue: 1);

            migrationBuilder.Sql(
                "UPDATE incident SET idstatutincident = 1 WHERE idstatutincident IS NULL OR idstatutincident = 0;");

            migrationBuilder.DropColumn(
                name: "etape",
                table: "incident");

            migrationBuilder.CreateIndex(
                name: "idx_incident_idstatutincident",
                table: "incident",
                column: "idstatutincident");

            migrationBuilder.CreateIndex(
                name: "uq_statut_incident_code",
                table: "statut_incident",
                column: "code",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "fk_incident_statut_incident",
                table: "incident",
                column: "idstatutincident",
                principalTable: "statut_incident",
                principalColumn: "idstatutincident",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_incident_statut_incident",
                table: "incident");

            migrationBuilder.DropTable(
                name: "statut_incident");

            migrationBuilder.DropIndex(
                name: "idx_incident_idstatutincident",
                table: "incident");

            migrationBuilder.DropColumn(
                name: "idstatutincident",
                table: "incident");

            migrationBuilder.AddColumn<bool>(
                name: "estclasse",
                table: "incident",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "estrembourse",
                table: "incident",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "estremisaucontentieux",
                table: "incident",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "etape",
                table: "incident",
                type: "integer",
                nullable: false,
                defaultValue: 1);
        }
    }
}
