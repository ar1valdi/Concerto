using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Concerto.Server.Migrations
{
    public partial class Contacts : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserContact");

            migrationBuilder.CreateTable(
                name: "UserContacts",
                columns: table => new
                {
                    UserId = table.Column<long>(type: "bigint", nullable: false),
                    ContactId = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserContacts", x => new { x.UserId, x.ContactId });
                    table.ForeignKey(
                        name: "FK_UserContacts_Users_ContactId",
                        column: x => x.ContactId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_UserContacts_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "UserContacts",
                columns: new[] { "ContactId", "UserId" },
                values: new object[,]
                {
                    { 2L, 1L },
                    { 3L, 1L },
                    { 4L, 1L },
                    { 1L, 2L }
                });

            migrationBuilder.CreateIndex(
                name: "IX_UserContacts_ContactId",
                table: "UserContacts",
                column: "ContactId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserContacts");

            migrationBuilder.CreateTable(
                name: "UserContact",
                columns: table => new
                {
                    UserId = table.Column<long>(type: "bigint", nullable: false),
                    ContactId = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserContact", x => new { x.UserId, x.ContactId });
                    table.ForeignKey(
                        name: "FK_UserContact_Users_ContactId",
                        column: x => x.ContactId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_UserContact_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "UserContact",
                columns: new[] { "ContactId", "UserId" },
                values: new object[,]
                {
                    { 2L, 1L },
                    { 3L, 1L },
                    { 4L, 1L },
                    { 1L, 2L }
                });

            migrationBuilder.CreateIndex(
                name: "IX_UserContact_ContactId",
                table: "UserContact",
                column: "ContactId");
        }
    }
}
