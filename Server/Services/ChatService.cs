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

    public async Task SaveMessageAsync(Dto.ChatMessage message)
    {
        ChatMessage messageModel = message.ToModel(DateTime.UtcNow);
        await _context.ChatMessages.AddAsync(messageModel);
        await _context.SaveChangesAsync();
    }
    public async Task<IEnumerable<Dto.ChatMessage>> GetLastMessagesAsync(long userId, long recipientId, int numberOfMessages)
    {
        IEnumerable<Dto.ChatMessage>? messages = await _context.ChatMessages
            .Where(cm => (cm.SenderId == userId && cm.RecipientId == recipientId) || (cm.SenderId == recipientId && cm.RecipientId == userId))
            .OrderByDescending(cm => cm.SendTimestamp)
            .Take(numberOfMessages)
            .Select(cm => cm.ToDto())
            .ToListAsync();
        return messages ?? Enumerable.Empty<Dto.ChatMessage>();
    }

    public async Task<IEnumerable<Dto.ChatMessage>> GetLastMessagesBeforeAsync(long userId, long recipientId, DateTime startingMessageTimestamp, int numberOfMessages)
    {
        IEnumerable<Dto.ChatMessage>? messages = await _context.ChatMessages
            .Where(cm => (cm.SendTimestamp <= startingMessageTimestamp) && (cm.SenderId == userId && cm.RecipientId == recipientId) || (cm.SenderId == recipientId && cm.RecipientId == userId))
            .OrderByDescending(cm => cm.SendTimestamp)
            .Take(numberOfMessages)
            .Select(cm => cm.ToDto())
            .ToListAsync();
        return messages ?? Enumerable.Empty<Dto.ChatMessage>();
    }
}

