using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LeboncoinAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddResetPasswordFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "reset_password_expiry",
                table: "utilisateur",
                type: "timestamp without time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "reset_password_token",
                table: "utilisateur",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "reset_password_expiry",
                table: "utilisateur");

            migrationBuilder.DropColumn(
                name: "reset_password_token",
                table: "utilisateur");
        }
    }
}
