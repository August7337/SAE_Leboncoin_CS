using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class IncidentWorkflowRbac : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
                UPDATE incident
                SET idstatutincident = 4
                WHERE idstatutincident = 8;
            ");

            migrationBuilder.DeleteData(
                table: "statut_incident",
                keyColumn: "idstatutincident",
                keyValue: 8);

            migrationBuilder.InsertData(
                table: "permission",
                columns: new[] { "idpermission", "nompermission" },
                values: new object[,]
                {
                    { 1, "incident.create" },
                    { 2, "incident.read.own" },
                    { 3, "incident.read.property" },
                    { 4, "incident.read.all" },
                    { 5, "incident.take_in_charge" },
                    { 6, "incident.class_without_follow_up" },
                    { 7, "incident.request_owner_explanation" },
                    { 8, "incident.submit_owner_explanation" },
                    { 9, "incident.decide_refund" },
                    { 10, "incident.process_refund" },
                    { 11, "incident.accept_refusal" },
                    { 12, "incident.contest_refusal" },
                    { 13, "incident.contentieux.close" },
                    { 14, "incident.contentieux.legal" }
                });

            migrationBuilder.InsertData(
                table: "role",
                columns: new[] { "idrole", "nomrole" },
                values: new object[,]
                {
                    { 1, "Locataire" },
                    { 2, "Proprietaire" },
                    { 3, "Service_Location" },
                    { 4, "Service_Comptabilite" },
                    { 5, "Service_Contentieux" }
                });

            migrationBuilder.UpdateData(
                table: "statut_incident",
                keyColumn: "idstatutincident",
                keyValue: 9,
                column: "ordre",
                value: 8);

            migrationBuilder.UpdateData(
                table: "statut_incident",
                keyColumn: "idstatutincident",
                keyValue: 10,
                column: "ordre",
                value: 9);

            migrationBuilder.UpdateData(
                table: "statut_incident",
                keyColumn: "idstatutincident",
                keyValue: 11,
                column: "ordre",
                value: 10);

            migrationBuilder.UpdateData(
                table: "statut_incident",
                keyColumn: "idstatutincident",
                keyValue: 12,
                column: "ordre",
                value: 11);

            migrationBuilder.InsertData(
                table: "permettre",
                columns: new[] { "idpermission", "idrole" },
                values: new object[,]
                {
                    { 1, 1 },
                    { 2, 1 },
                    { 11, 1 },
                    { 12, 1 },
                    { 3, 2 },
                    { 8, 2 },
                    { 4, 3 },
                    { 5, 3 },
                    { 6, 3 },
                    { 7, 3 },
                    { 9, 3 },
                    { 4, 4 },
                    { 10, 4 },
                    { 4, 5 },
                    { 13, 5 },
                    { 14, 5 }
                });

            migrationBuilder.CreateIndex(
                name: "uq_role_nomrole",
                table: "role",
                column: "nomrole",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "uq_permission_nompermission",
                table: "permission",
                column: "nompermission",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "uq_role_nomrole",
                table: "role");

            migrationBuilder.DropIndex(
                name: "uq_permission_nompermission",
                table: "permission");

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 1, 1 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 2, 1 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 11, 1 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 12, 1 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 3, 2 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 8, 2 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 4, 3 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 5, 3 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 6, 3 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 7, 3 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 9, 3 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 4, 4 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 10, 4 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 4, 5 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 13, 5 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 14, 5 });

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "role",
                keyColumn: "idrole",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "role",
                keyColumn: "idrole",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "role",
                keyColumn: "idrole",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "role",
                keyColumn: "idrole",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "role",
                keyColumn: "idrole",
                keyValue: 5);

            migrationBuilder.UpdateData(
                table: "statut_incident",
                keyColumn: "idstatutincident",
                keyValue: 9,
                column: "ordre",
                value: 9);

            migrationBuilder.UpdateData(
                table: "statut_incident",
                keyColumn: "idstatutincident",
                keyValue: 10,
                column: "ordre",
                value: 10);

            migrationBuilder.UpdateData(
                table: "statut_incident",
                keyColumn: "idstatutincident",
                keyValue: 11,
                column: "ordre",
                value: 11);

            migrationBuilder.UpdateData(
                table: "statut_incident",
                keyColumn: "idstatutincident",
                keyValue: 12,
                column: "ordre",
                value: 12);

            migrationBuilder.InsertData(
                table: "statut_incident",
                columns: new[] { "idstatutincident", "code", "estfinal", "libelle", "ordre" },
                values: new object[] { 8, "EN_ATTENTE_RETOUR_LOUEUR", false, "En attente de la reponse du loueur", 8 });
        }
    }
}
