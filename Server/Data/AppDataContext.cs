using Microsoft.EntityFrameworkCore;
using Concerto.Shared.Models;
using Concerto.Shared.Extensions;

namespace Concerto.Server.Data;

public class AppDataContext : DbContext
{

    public DbSet<User> Users { get; set; }

    public AppDataContext(DbContextOptions<AppDataContext> options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);


        User[] users = {
            new User { UserId = 1, FirstName = "Jan", LastName = "Administracyjny", Username = "admin", OpenIdSubject = "95f418ac-e38f-41ec-a2ad-828bdd3895d0"},
            new User { UserId = 2, FirstName = "Piotr", LastName = "Testowy", Username = "user", OpenIdSubject = "9bb46cbd-c04c-4c1c-b129-8401d59c878d"},
            new User { UserId = 3, FirstName = "Jane", LastName = "Doe", Username = "jadoe" },
            new User { UserId = 4, FirstName = "John", LastName = "Smith", Username = "jsmith" }
        };

        modelBuilder.Entity<User>().HasData(
            users[0],
            users[1],
            users[2],
            users[3]
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
    }
}
