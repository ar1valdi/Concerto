namespace Concerto.Server.Data.Entities;

public class UserContact
{
    public long UserId { get; set; }
    public User User { get; set; }

    public long ContactId { get; set; }
    public User Contact { get; set; }
}

