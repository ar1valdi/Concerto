using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Concerto.Server.Migrations
{
    public partial class Init : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    UserId = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    SubjectId = table.Column<Guid>(type: "uuid", nullable: true),
                    Username = table.Column<string>(type: "text", nullable: false),
                    FirstName = table.Column<string>(type: "text", nullable: false),
                    LastName = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.UserId);
                });

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
                table: "Users",
                columns: new[] { "UserId", "FirstName", "LastName", "SubjectId", "Username" },
                values: new object[,]
                {
                    { 1L, "Jan", "Administracyjny", new Guid("95f418ac-e38f-41ec-a2ad-828bdd3895d0"), "admin" },
                    { 2L, "Piotr", "Testowy", new Guid("9bb46cbd-c04c-4c1c-b129-8401d59c878d"), "user" },
                    { 3L, "Jacek", "Testowy", new Guid("71e82c06-a4d5-4c48-a8d3-8a9c8916790e"), "user1" },
                    { 4L, "John", "Smith", null, "jsmith" }
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

            migrationBuilder.CreateIndex(
                name: "IX_Users_SubjectId",
                table: "Users",
                column: "SubjectId",
                unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserContact");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
