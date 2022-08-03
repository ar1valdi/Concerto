using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace Concerto.Server.Data.Models;

[Index(nameof(SubjectId), IsUnique = true)]
public class User
{
    [Key]
    public long UserId { get; set; }

    public Guid? SubjectId { get; set; }

    [Required]
    public string Username { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public virtual ICollection<UserContact>? Contacts { get; set; }
    public virtual ICollection<UserContact>? ContactOf { get; set; }
}