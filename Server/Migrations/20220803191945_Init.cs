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
                name: "ChatMessages",
                columns: table => new
                {
                    ChatMessageId = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    SendTimestamp = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    SenderId = table.Column<long>(type: "bigint", nullable: false),
                    RecipientId = table.Column<long>(type: "bigint", nullable: false),
                    Content = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ChatMessages", x => x.ChatMessageId);
                    table.ForeignKey(
                        name: "FK_ChatMessages_Users_RecipientId",
                        column: x => x.RecipientId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ChatMessages_Users_SenderId",
                        column: x => x.SenderId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

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
                table: "Users",
                columns: new[] { "UserId", "FirstName", "LastName", "SubjectId", "Username" },
                values: new object[,]
                {
                    { 1L, "Jan", "Administracyjny", new Guid("95f418ac-e38f-41ec-a2ad-828bdd3895d0"), "admin" },
                    { 2L, "Piotr", "Testowy", new Guid("954af482-22dd-483f-ac99-975144f85a04"), "user2" },
                    { 3L, "Jacek", "Testowy", new Guid("c786cbc3-9924-410f-bcdb-75a2469107be"), "user3" },
                    { 4L, "John", "Smith", new Guid("f2c0a648-82bb-44a9-908e-8006577cb276"), "user4" }
                });

            migrationBuilder.InsertData(
                table: "ChatMessages",
                columns: new[] { "ChatMessageId", "Content", "RecipientId", "SendTimestamp", "SenderId" },
                values: new object[,]
                {
                    { 1L, "Test message 1", 2L, new DateTime(2022, 8, 3, 19, 14, 44, 934, DateTimeKind.Utc).AddTicks(8505), 1L },
                    { 2L, "Test message 2", 2L, new DateTime(2022, 8, 3, 19, 16, 44, 934, DateTimeKind.Utc).AddTicks(8509), 1L },
                    { 3L, "Test reply 1", 1L, new DateTime(2022, 8, 3, 19, 17, 44, 934, DateTimeKind.Utc).AddTicks(8509), 2L },
                    { 4L, "Test reply 2", 1L, new DateTime(2022, 8, 3, 19, 18, 44, 934, DateTimeKind.Utc).AddTicks(8510), 2L },
                    { 5L, "Test message 3", 2L, new DateTime(2022, 8, 3, 19, 18, 44, 934, DateTimeKind.Utc).AddTicks(8511), 3L }
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
                name: "IX_ChatMessages_RecipientId",
                table: "ChatMessages",
                column: "RecipientId");

            migrationBuilder.CreateIndex(
                name: "IX_ChatMessages_SenderId",
                table: "ChatMessages",
                column: "SenderId");

            migrationBuilder.CreateIndex(
                name: "IX_UserContacts_ContactId",
                table: "UserContacts",
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
                name: "ChatMessages");

            migrationBuilder.DropTable(
                name: "UserContacts");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
