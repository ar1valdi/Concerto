using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Concerto.Shared.Models.Dto;
public record Conversation
{
    public long ConversationId { get; init; }
    public bool IsPrivate { get; init; }
    public IEnumerable<Dto.User>? Users { get; init; }
    public Dto.ChatMessage? LastMessage { get; set; }
}
