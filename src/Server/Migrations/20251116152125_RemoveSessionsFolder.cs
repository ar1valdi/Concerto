using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Concerto.Server.Migrations
{
    /// <inheritdoc />
    public partial class RemoveSessionsFolder : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Sessions_Folders_FolderId",
                table: "Sessions");

            migrationBuilder.DropForeignKey(
                name: "FK_Workspaces_Folders_SessionsFolderId",
                table: "Workspaces");

            migrationBuilder.DropIndex(
                name: "IX_Workspaces_SessionsFolderId",
                table: "Workspaces");

            migrationBuilder.DropIndex(
                name: "IX_Sessions_FolderId",
                table: "Sessions");

            migrationBuilder.DropColumn(
                name: "SessionsFolderId",
                table: "Workspaces");

            migrationBuilder.DropColumn(
                name: "FolderId",
                table: "Sessions");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "SessionsFolderId",
                table: "Workspaces",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<long>(
                name: "FolderId",
                table: "Sessions",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.CreateIndex(
                name: "IX_Workspaces_SessionsFolderId",
                table: "Workspaces",
                column: "SessionsFolderId");

            migrationBuilder.CreateIndex(
                name: "IX_Sessions_FolderId",
                table: "Sessions",
                column: "FolderId",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Sessions_Folders_FolderId",
                table: "Sessions",
                column: "FolderId",
                principalTable: "Folders",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Workspaces_Folders_SessionsFolderId",
                table: "Workspaces",
                column: "SessionsFolderId",
                principalTable: "Folders",
                principalColumn: "Id");
        }
    }
}
