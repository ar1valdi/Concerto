using System.ComponentModel.DataAnnotations;

namespace Concerto.Server.Data.Models;

public class Conversation
{
    [Key]
    public long ConversationId { get; set; }
    public bool IsPrivate { get; set; }
    public ICollection<ChatMessage> ChatMessages { get; set; }
    public ICollection<ConversationUser> ConversationUsers { get; set; }
}
