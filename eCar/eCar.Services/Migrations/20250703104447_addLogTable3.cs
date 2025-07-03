using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCar.Services.Migrations
{
    /// <inheritdoc />
    public partial class addLogTable3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "TranskacijaLog25062025s",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    StariIznos = table.Column<double>(type: "float", nullable: false),
                    StariOpis = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    StariStatus = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NoviIznos = table.Column<double>(type: "float", nullable: false),
                    NoviOpis = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    NoviStatus = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Kategorija = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    VrijemeLog = table.Column<TimeOnly>(type: "time", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TranskacijaLog25062025s", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TranskacijaLog25062025s_User_KorisnikId",
                        column: x => x.KorisnikId,
                        principalTable: "User",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

        }

       
          
    }
}
