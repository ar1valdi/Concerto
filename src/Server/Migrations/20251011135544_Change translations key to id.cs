using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Concerto.Server.Migrations
{
    /// <inheritdoc />
    public partial class Changetranslationskeytoid : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Translations",
                table: "Translations");

            migrationBuilder.AlterColumn<long>(
                name: "Id",
                table: "Translations",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint")
                .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.AddPrimaryKey(
                name: "PK_Translations",
                table: "Translations",
                column: "Id");

            migrationBuilder.CreateIndex(
                name: "IX_Translations_Language_View_Key",
                table: "Translations",
                columns: new[] { "Language", "View", "Key" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Translations",
                table: "Translations");

            migrationBuilder.DropIndex(
                name: "IX_Translations_Language_View_Key",
                table: "Translations");

            migrationBuilder.AlterColumn<long>(
                name: "Id",
                table: "Translations",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint")
                .OldAnnotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.AddPrimaryKey(
                name: "PK_Translations",
                table: "Translations",
                columns: new[] { "Language", "View", "Key" });
        }
    }
}
