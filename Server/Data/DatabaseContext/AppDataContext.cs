using Concerto.Server.Data.Models;
using Microsoft.EntityFrameworkCore;

namespace Concerto.Server.Data.DatabaseContext;

public class AppDataContext : DbContext
{

    public DbSet<User> Users { get; set; }
    public DbSet<UserContact> UserContacts { get; set; }
    public DbSet<ChatMessage> ChatMessages { get; set; }

    public AppDataContext(DbContextOptions<AppDataContext> options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<User>().HasData(
            new User { UserId = 1, FirstName = "Jan", LastName = "Administracyjny", Username = "admin", SubjectId = Guid.Parse("95f418ac-e38f-41ec-a2ad-828bdd3895d0") },
            new User { UserId = 2, FirstName = "Piotr", LastName = "Testowy", Username = "user2", SubjectId = Guid.Parse("954af482-22dd-483f-ac99-975144f85a04") },
            new User { UserId = 3, FirstName = "Jacek", LastName = "Testowy", Username = "user3", SubjectId = Guid.Parse("c786cbc3-9924-410f-bcdb-75a2469107be") },
            new User { UserId = 4, FirstName = "John", LastName = "Smith", Username = "user4", SubjectId = Guid.Parse("f2c0a648-82bb-44a9-908e-8006577cb276") }
            );

        modelBuilder.Entity<UserContact>().HasKey(uc => new { uc.UserId, uc.ContactId });

        modelBuilder.Entity<UserContact>()
            .HasOne(uc => uc.User)
            .WithMany(u => u.Contacts)
            .HasForeignKey(uc => uc.ContactId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<UserContact>()
            .HasOne(uc => uc.Contact)
            .WithMany(u => u.ContactOf)
            .HasForeignKey(uc => uc.ContactId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<UserContact>().HasData(
                new UserContact { UserId = 1, ContactId = 2 },
                new UserContact { UserId = 2, ContactId = 1 },
                new UserContact { UserId = 1, ContactId = 3 },
                new UserContact { UserId = 1, ContactId = 4 }
            );

        modelBuilder.Entity<ChatMessage>().HasData(
            new ChatMessage { ChatMessageId = 1, SenderId = 1, RecipientId = 2, Content = "Test message 1", SendTimestamp = DateTime.UtcNow.AddMinutes(-5) },
            new ChatMessage { ChatMessageId = 2, SenderId = 1, RecipientId = 2, Content = "Test message 2", SendTimestamp = DateTime.UtcNow.AddMinutes(-3) },
            new ChatMessage { ChatMessageId = 3, SenderId = 2, RecipientId = 1, Content = "Test reply 1", SendTimestamp = DateTime.UtcNow.AddMinutes(-2) },
            new ChatMessage { ChatMessageId = 4, SenderId = 2, RecipientId = 1, Content = "Test reply 2", SendTimestamp = DateTime.UtcNow.AddMinutes(-1) },
            new ChatMessage { ChatMessageId = 5, SenderId = 3, RecipientId = 2, Content = "Test message 3", SendTimestamp = DateTime.UtcNow.AddMinutes(-1) }
            );
    }
}
