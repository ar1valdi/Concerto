using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Concerto.Server.Migrations
{
    /// <inheritdoc />
    public partial class AddTreeRoot : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Workspaces",
                columns: new[] { "Id", "Name", "Description", "CreatedDate", "RootFolderId", "SessionsFolderId" },
                values: new object[,]
                {
                    { -1, "MOCK_TREE_ROOT", "Mocked tree root for prototype purposes.", DateTime.UtcNow, null, null },
                });

            migrationBuilder.InsertData(
                table: "Folders",
                columns: new[] { "Id", "Name", "Type", "WorkspaceId", "OwnerId", "ParentId", "WorkspacePermission_Type", "WorkspacePermission_Inherited" },
                values: new object[,]
                {
                    { -1, "Root", 0, -1, null, null, 0, false }, // Root folder
                    { -2, "Sessions", 1, -1, null, null, 0, false } // Sessions folder probably to remove when done with prototyping
                });

            migrationBuilder.UpdateData(
                table: "Workspaces",
                keyColumn: "Id",
                keyValue: -1,
                columns: new[] { "RootFolderId", "SessionsFolderId" },
                values: new object[] { -1, -2 });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Workspaces",
                keyColumn: "Id",
                keyValue: -1,
                columns: new[] { "RootFolderId", "SessionsFolderId" },
                values: new object[] { null, null });

            migrationBuilder.DeleteData(
                table: "Folders",
                keyColumn: "Id",
                keyValue: -2);

            migrationBuilder.DeleteData(
                table: "Folders",
                keyColumn: "Id",
                keyValue: -1);

            migrationBuilder.DeleteData(
                table: "Workspaces",
                keyColumn: "Id",
                keyValue: -1);
        }
    }
}
