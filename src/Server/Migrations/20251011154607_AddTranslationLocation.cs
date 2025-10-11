using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Concerto.Server.Migrations
{
    /// <inheritdoc />
    public partial class AddTranslationLocation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Create TranslationLocations table
            migrationBuilder.CreateTable(
                name: "TranslationLocations",
                columns: table => new
                {
                    View = table.Column<string>(type: "text", nullable: false),
                    Key = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TranslationLocations", x => new { x.View, x.Key });
                });

            migrationBuilder.Sql(@"
                INSERT INTO ""TranslationLocations"" (""View"", ""Key"")
                SELECT DISTINCT ""View"", ""Key""
                FROM ""Translations""
                ON CONFLICT DO NOTHING;
            ");

            migrationBuilder.CreateIndex(
                name: "IX_Translations_View_Key",
                table: "Translations",
                columns: new[] { "View", "Key" });

            migrationBuilder.AddForeignKey(
                name: "FK_Translations_TranslationLocations_View_Key",
                table: "Translations",
                columns: new[] { "View", "Key" },
                principalTable: "TranslationLocations",
                principalColumns: new[] { "View", "Key" },
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Translations_TranslationLocations_View_Key",
                table: "Translations");

            migrationBuilder.DropTable(
                name: "TranslationLocations");

            migrationBuilder.DropIndex(
                name: "IX_Translations_View_Key",
                table: "Translations");
        }
    }
}
