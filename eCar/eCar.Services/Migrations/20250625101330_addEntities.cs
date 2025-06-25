using System;
using Microsoft.EntityFrameworkCore.Migrations;
using NetTopologySuite.Geometries;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eCar.Services.Migrations
{
    /// <inheritdoc />
    public partial class addEntities : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
           

            migrationBuilder.CreateTable(
                name: "KategorijaTransakcije250602025e",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Tip = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KategorijaTransakcije250602025e", x => x.Id);
                });

         

            migrationBuilder.CreateTable(
                name: "FinansijskiLimit250602025e",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Limit = table.Column<double>(type: "float", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    KategorijaId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FinansijskiLimit250602025e", x => x.Id);
                    table.ForeignKey(
                        name: "FK_FinansijskiLimit250602025e_KategorijaTransakcije250602025e_KategorijaId",
                        column: x => x.KategorijaId,
                        principalTable: "KategorijaTransakcije250602025e",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_FinansijskiLimit250602025e_User_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "User",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Transakcija250602025e",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Iznos = table.Column<double>(type: "float", nullable: false),
                    DatumTransakcije = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    KategorijaId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Transakcija250602025e", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Transakcija250602025e_KategorijaTransakcije250602025e_KategorijaId",
                        column: x => x.KategorijaId,
                        principalTable: "KategorijaTransakcije250602025e",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Transakcija250602025e_User_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "User",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

          

            migrationBuilder.CreateIndex(
                name: "IX_FinansijskiLimit250602025e_KategorijaId",
                table: "FinansijskiLimit250602025e",
                column: "KategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_FinansijskiLimit250602025e_KorisnikId",
                table: "FinansijskiLimit250602025e",
                column: "KorisnikId");

         

            migrationBuilder.CreateIndex(
                name: "IX_Transakcija250602025e_KategorijaId",
                table: "Transakcija250602025e",
                column: "KategorijaId");

            migrationBuilder.CreateIndex(
                name: "IX_Transakcija250602025e_KorisnikId",
                table: "Transakcija250602025e",
                column: "KorisnikId");
        }

        /// <inheritdoc />
      
    }
}
