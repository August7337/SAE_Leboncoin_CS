using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class ConfigureAgentAssigneRelationship : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_incident_utilisateur_idagentassigne",
                table: "incident");

            migrationBuilder.AddForeignKey(
                name: "fk_incident_agent_assigne",
                table: "incident",
                column: "idagentassigne",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_incident_agent_assigne",
                table: "incident");

            migrationBuilder.AddForeignKey(
                name: "FK_incident_utilisateur_idagentassigne",
                table: "incident",
                column: "idagentassigne",
                principalTable: "utilisateur",
                principalColumn: "idutilisateur");
        }
    }
}
