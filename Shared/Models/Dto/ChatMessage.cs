namespace Concerto.Shared.Models.Dto;

public class ChatMessage
{
    public DateTime SendTimestamp { get; set; }
    public long RecipientId { get; set; }
    public string Content { get; set; }
}
