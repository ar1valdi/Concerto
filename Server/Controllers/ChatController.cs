using Concerto.Server.Services;
using Concerto.Shared.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Concerto.Server.Controllers;

[Route("[controller]/[action]")]
[ApiController]
[Authorize]
public class ChatController : ControllerBase
{
    private readonly ILogger<ChatController> _logger;
	private readonly ChatService _chatService;

	public ChatController(ILogger<ChatController> logger, ChatService chatService)
	{
		_logger = logger;
		_chatService = chatService;
	}

	[HttpGet]
    public async Task<IEnumerable<Dto.ChatMessage>> GetCurrentUserLastMessages([FromQuery] long recipientId)
    {
		// TODO move this to config
		const int numberOfMessages = 100;

		long? userId = User.GetUserId();
		if (userId == null) return Enumerable.Empty<Dto.ChatMessage>();
		return await _chatService.GetLastMessagesAsync(userId!.Value, recipientId, numberOfMessages);

	}

	[HttpGet]
	public async Task<IEnumerable<Dto.ChatMessage>> GetCurrentUserLastMessagesBefore([FromQuery] long recipientId, [FromQuery] DateTime startingMessageTimestamp)
	{
		// TODO move this to config
		const int numberOfMessages = 100;

		long? userId = User.GetUserId();
		if (userId == null) return Enumerable.Empty<Dto.ChatMessage>();
		return await _chatService.GetLastMessagesBeforeAsync(userId!.Value, recipientId, startingMessageTimestamp, numberOfMessages);
	}

}
