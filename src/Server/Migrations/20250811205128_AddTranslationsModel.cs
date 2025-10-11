using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Concerto.Server.Migrations
{
    /// <inheritdoc />
    public partial class AddTranslationsModel : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Post_Workspaces_WorkspaceId",
                table: "Post");

            migrationBuilder.CreateTable(
                name: "Translations",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Language = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    View = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    Key = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Value = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: false),
                    LastUpdated = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "CURRENT_TIMESTAMP")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Translations", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Translation_Language_View_Key",
                table: "Translations",
                columns: new[] { "Language", "View", "Key" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Translation_LastUpdated",
                table: "Translations",
                column: "LastUpdated");

            migrationBuilder.AddForeignKey(
                name: "FK_Post_Workspaces_WorkspaceId",
                table: "Post",
                column: "WorkspaceId",
                principalTable: "Workspaces",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Post_Workspaces_WorkspaceId",
                table: "Post");

            migrationBuilder.DropTable(
                name: "Translations");

            migrationBuilder.AddForeignKey(
                name: "FK_Post_Workspaces_WorkspaceId",
                table: "Post",
                column: "WorkspaceId",
                principalTable: "Workspaces",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }
    }
}
