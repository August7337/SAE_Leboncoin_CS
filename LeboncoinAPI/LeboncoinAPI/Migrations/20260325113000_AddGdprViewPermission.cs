using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LeboncoinAPI.Migrations
{
    public partial class AddGdprViewPermission : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "permission",
                columns: new[] { "idpermission", "nompermission" },
                values: new object[] { 24, "app.view.gdpr_data" });

            migrationBuilder.InsertData(
                table: "permettre",
                columns: new[] { "idpermission", "idrole" },
                values: new object[] { 24, 2 });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "permettre",
                keyColumns: new[] { "idpermission", "idrole" },
                keyValues: new object[] { 24, 2 });

            migrationBuilder.DeleteData(
                table: "permission",
                keyColumn: "idpermission",
                keyValue: 24);
        }
    }
}