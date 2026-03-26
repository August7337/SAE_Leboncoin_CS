using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddPermissionsAndClientRole : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "permission",
                columns: new[] { "idpermission", "nompermission" },
                values: new object[,]
                {
                    { 15, "app.view.home" },
                    { 16, "app.view.favorites" },
                    { 17, "app.view.messages" },
                    { 18, "app.view.my_annonces" },
                    { 19, "app.view.my_reservations" },
                    { 20, "dashboard.settings" },
                    { 21, "dashboard.incidents.location" },
                    { 22, "dashboard.incidents.comptabilite" },
                    { 23, "dashboard.incidents.contentieux" }
                });

            migrationBuilder.InsertData(
                table: "role",
                columns: new[] { "idrole", "nomrole" },
                values: new object[] { 2, "Client" });

            migrationBuilder.InsertData(
                table: "permettre",
                columns: new[] { "idpermission", "idrole" },
                values: new object[,]
                {
                    { 15, 2 },
                    { 16, 2 },
                    { 17, 2 },
                    { 18, 2 },
                    { 19, 2 },
                    { 20, 2 },
                    { 20, 3 },
                    { 21, 3 },
                    { 20, 4 },
                    { 22, 4 },
                    { 20, 5 },
                    { 23, 5 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 15, 2 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 16, 2 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 17, 2 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 18, 2 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 19, 2 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 20, 2 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 20, 3 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 21, 3 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 20, 4 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 22, 4 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 20, 5 });

            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 23, 5 });

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "role",
                keyColumn: "idrole",
                keyValue: 2);
        }
    }
}
