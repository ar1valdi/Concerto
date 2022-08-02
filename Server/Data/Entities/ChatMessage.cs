using System.ComponentModel.DataAnnotations;

namespace Concerto.Server.Data.Entities
{
    public class ChatMessage
    {
        [Key]
        long ChatMessageId;



        string Content;
    }
}
