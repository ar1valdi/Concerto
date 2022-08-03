using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Concerto.Shared.Models.Dto;

public class ChatMessage
{
    public DateTime SendTimestamp;
    public long RecipientId;
    public string Content;
}
