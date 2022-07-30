using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Concerto.Shared.Models;

public class User
{
    [Key]
    public long UserId { get; set; }

    public string? OpenIdSubject { get; set; }

    [Required]
    public string Username { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public virtual ICollection<UserContact> Contacts { get; set; }
    public virtual ICollection<UserContact> ContactOf { get; set; }
}

public class UserContact
{
    public long UserId { get; set; }
    public User User { get; set; }

    public long ContactId { get; set; }
    public User Contact { get; set; }
}
