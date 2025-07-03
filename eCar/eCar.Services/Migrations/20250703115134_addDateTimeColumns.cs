using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCar.Services.Migrations
{
    /// <inheritdoc />
    public partial class addDateTimeColumns : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<DateTime>(
                name: "VrijemeLog",
                table: "TranskacijaLog25062025s",
                type: "datetime2",
                nullable: false,
                oldClrType: typeof(TimeOnly),
                oldType: "time");

            migrationBuilder.AddColumn<DateTime>(
                name: "NoviDatum",
                table: "TranskacijaLog25062025s",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "StariDatum",
                table: "TranskacijaLog25062025s",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

        }
        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

            migrationBuilder.AlterColumn<TimeOnly>(
                name: "VrijemeLog",
                table: "TranskacijaLog25062025s",
                type: "time",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

        }
    }
}
