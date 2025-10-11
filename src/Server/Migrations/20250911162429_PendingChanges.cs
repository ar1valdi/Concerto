using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Concerto.Server.Migrations
{
    /// <inheritdoc />
    public partial class PendingChanges : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Post_Workspaces_WorkspaceId",
                table: "Post");

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
