using Concerto.Shared.Extensions;
using Concerto.Server.Extensions;
using Concerto.Server.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace Concerto.Server.Hubs;

[Authorize]
public class ChatHub : Hub
{

    private readonly ILogger<ChatHub> _logger;
    private readonly ChatService _chatService;


    public ChatHub(ILogger<ChatHub> logger, ChatService chatService)
    {
        _logger = logger;
        _chatService = chatService;
    }

    public override Task OnConnectedAsync()
    {
        string? userId = Context.GetUserIdString();

        if (!string.IsNullOrEmpty(userId))
        {
            _logger.LogDebug($"User with ID {userId} conncted to ChatHub");
            Groups.AddToGroupAsync(Context.ConnectionId, userId);
        }
        else
        {
            throw new Exception("ChatHub connection attempt with empty UserId");
        }
        return base.OnConnectedAsync();
    }

    public async Task SendMessage(long recipientId, string content)
    {
        var message = new Dto.ChatMessage
        {
            RecipientId = recipientId,
            SendTimestamp = DateTime.UtcNow,
            Content = content
        };

        long? senderId = Context.GetUserId();
		if (senderId.HasValue)
		{
            Task saveMessageTask = _chatService.SaveMessageAsync(message, senderId!.Value);
            Task sendMessageTask = Clients.Group($"{recipientId}").SendAsync("ReceiveMessage", message);
            await Task.WhenAll(saveMessageTask, sendMessageTask);
        }

    }
}
