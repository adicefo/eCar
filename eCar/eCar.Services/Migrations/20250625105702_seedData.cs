using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eCar.Services.Migrations
{
    /// <inheritdoc />
    public partial class seedData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {

            migrationBuilder.InsertData(
                table: "KategorijaTransakcije250602025e",
                columns: new[] { "Id", "Naziv", "Tip" },
                values: new object[,]
                {
                    { 1, "Hrana", "Prihod" },
                    { 2, "Zabava", "Rashod" },
                    { 3, "Plata", "Prihod" }
                });


            migrationBuilder.InsertData(
                table: "FinansijskiLimit250602025e",
                columns: new[] { "Id", "KategorijaId", "KorisnikId", "Limit" },
                values: new object[,]
                {
                    { 1, 1, 1, 300.0 },
                    { 2, 2, 1, 300.0 },
                    { 3, 1, 2, 300.0 },
                    { 4, 1, 2, 300.0 }
                });
        }

        /// <inheritdoc />

    }
}
