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

    public async Task SendMessage(long userId, string message)
    {
        await Clients.All.SendAsync("ReceiveMessage", userId, message);
    }

    public override Task OnConnectedAsync()
    {
        string? userId = Context.User?.GetUserIdString();

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
}
