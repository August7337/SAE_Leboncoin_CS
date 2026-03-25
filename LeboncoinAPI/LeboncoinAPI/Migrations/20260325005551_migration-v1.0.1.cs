using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class migrationv101 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "statutdemande",
                columns: table => new
                {
                    idstatut = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nomstatut = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_statutdemande", x => x.idstatut);
                });

            migrationBuilder.CreateTable(
                name: "demandesuppressioncompte",
                columns: table => new
                {
                    iddemande = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    idutilisateur = table.Column<int>(type: "integer", nullable: false),
                    idstatut = table.Column<int>(type: "integer", nullable: false),
                    datedemande = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    motifrefus = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_demandesuppressioncompte", x => x.iddemande);
                    table.ForeignKey(
                        name: "FK_demandesuppressioncompte_statutdemande_idstatut",
                        column: x => x.idstatut,
                        principalTable: "statutdemande",
                        principalColumn: "idstatut",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_demandesuppressioncompte_utilisateur_idutilisateur",
                        column: x => x.idutilisateur,
                        principalTable: "utilisateur",
                        principalColumn: "idutilisateur",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_demandesuppressioncompte_idstatut",
                table: "demandesuppressioncompte",
                column: "idstatut");

            migrationBuilder.CreateIndex(
                name: "IX_demandesuppressioncompte_idutilisateur",
                table: "demandesuppressioncompte",
                column: "idutilisateur");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "demandesuppressioncompte");

            migrationBuilder.DropTable(
                name: "statutdemande");
        }
    }
}
