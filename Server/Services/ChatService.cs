using Concerto.Server.Data.DatabaseContext;
using Concerto.Server.Data.Models;
using Concerto.Server.Extensions;
using Microsoft.EntityFrameworkCore;

namespace Concerto.Server.Services;

public class ChatService
{
    private readonly ILogger<ChatService> _logger;
    private readonly AppDataContext _context;

    public ChatService(ILogger<ChatService> logger, AppDataContext context)
    {
        _context = context;
        _logger = logger;
    }

    public async Task SaveMessageAsync(Dto.ChatMessage message, long senderId)
    {
        ChatMessage messageModel = message.ToModel(senderId, DateTime.UtcNow);
        await _context.SaveChangesAsync();
    }
    public async Task<IEnumerable<Dto.ChatMessage>> GetLastMessagesAsync(long senderId, long recipientId, int numberOfMessages)
    {
        IEnumerable<Dto.ChatMessage>? messages = await _context.ChatMessages
            .Where(uc => uc.SenderId == senderId && uc.RecipientId == recipientId)
            .Take(numberOfMessages)
            .Select(uc => uc.ToDto())
            .ToListAsync();
        return messages ?? Enumerable.Empty<Dto.ChatMessage>();
    }

    public async Task<IEnumerable<Dto.ChatMessage>> GetLastMessagesBeforeAsync(long senderId, long recipientId, DateTime startingMessageTimestamp, int numberOfMessages)
    {
        IEnumerable<Dto.ChatMessage>? messages = await _context.ChatMessages
            .Where(cm => cm.SendTimestamp <= startingMessageTimestamp
                         && cm.SenderId == senderId
                         && cm.RecipientId == recipientId)
            .OrderByDescending(cm => cm.SendTimestamp)
            .Take(numberOfMessages)
            .Select(cm => cm.ToDto())
            .ToListAsync();
        return messages ?? Enumerable.Empty<Dto.ChatMessage>();
    }
}

