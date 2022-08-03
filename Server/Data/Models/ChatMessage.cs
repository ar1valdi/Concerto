using System.ComponentModel.DataAnnotations;

namespace Concerto.Server.Data.Models;
public class ChatMessage
{
    [Key]
    public long ChatMessageId { get; set; }

    [Required]
    public DateTime SendTimestamp { get; set; }

    [Required]
    public long SenderId { get; set; }
    public User Sender { get; set; }

    [Required]
    public long RecipientId { get; set; }
    public User Recipient { get; set; }

    [Required]
    public string Content { get; set; }
}
