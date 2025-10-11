using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Concerto.Server.Migrations
{
    /// <inheritdoc />
    public partial class AddLanguageModel : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Languages",
                columns: table => new
                {
                    Key = table.Column<string>(type: "text", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    IsPublic = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Languages", x => x.Key);
                });

            migrationBuilder.InsertData(
                table: "Languages",
                columns: new[] { "Key", "Name", "IsPublic" },
                values: new object[,]
                {
                    { "en", "English", true },
                    { "pl", "Polski", true }
                });

            migrationBuilder.AddForeignKey(
                name: "FK_Translations_Languages_Language",
                table: "Translations",
                column: "Language",
                principalTable: "Languages",
                principalColumn: "Key",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Translations_Languages_Language",
                table: "Translations");

            migrationBuilder.DeleteData(
                table: "Languages",
                keyColumn: "Key",
                keyValue: "en");

            migrationBuilder.DeleteData(
                table: "Languages",
                keyColumn: "Key",
                keyValue: "pl");

            migrationBuilder.DropTable(
                name: "Languages");
        }
    }
}
