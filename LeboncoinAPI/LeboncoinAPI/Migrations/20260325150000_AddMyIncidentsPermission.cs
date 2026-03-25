using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LeboncoinAPI.Migrations
{
    public partial class AddMyIncidentsPermission : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Permission id 25 : app.view.my_incidents — accordée au rôle Client (idrole = 2)
            migrationBuilder.InsertData(
                table: "permission",
                columns: new[] { "idpermission", "nompermission" },
                values: new object[] { 25, "app.view.my_incidents" });

            migrationBuilder.InsertData(
                table: "permettre",
                columns: new[] { "idpermission", "idrole" },
                values: new object[] { 25, 2 });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 25, 2 });

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 25);
        }
    }
}
