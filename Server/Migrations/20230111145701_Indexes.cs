using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Concerto.Server.Migrations
{
    /// <inheritdoc />
    public partial class Indexes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "OneTimeTokens");

            migrationBuilder.CreateIndex(
                name: "IX_UserFolderPermissions_UserId",
                table: "UserFolderPermissions",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_CourseUsers_CourseId",
                table: "CourseUsers",
                column: "CourseId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_UserFolderPermissions_UserId",
                table: "UserFolderPermissions");

            migrationBuilder.DropIndex(
                name: "IX_CourseUsers_CourseId",
                table: "CourseUsers");

            migrationBuilder.CreateTable(
                name: "OneTimeTokens",
                columns: table => new
                {
                    Token = table.Column<Guid>(type: "uuid", nullable: false),
                    FileId = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OneTimeTokens", x => x.Token);
                });

            migrationBuilder.CreateIndex(
                name: "IX_OneTimeTokens_FileId",
                table: "OneTimeTokens",
                column: "FileId");
        }
    }
}
