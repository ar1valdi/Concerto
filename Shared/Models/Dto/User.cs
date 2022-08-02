namespace Concerto.Shared.Models.Dto;

public class User
{
    public long UserId { get; set; }
    public string Username { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }

    public virtual ICollection<User>? Contacts { get; set; }
}