﻿using Concerto.Server.Middlewares;
using Concerto.Server.Services;
using Concerto.Shared.Constants;
using Concerto.Shared.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace Concerto.Server.Hubs;

[Authorize]
public class DawHub : Hub
{
	private readonly ILogger<DawHub> _logger;

	public DawHub(ILogger<DawHub> logger) {
		_logger = logger;
	}

	private Guid? UserId => Context.User?.GetSubjectId();

	public static string DawProjectGroup(long sessionId)
	{
		return $"daw-{sessionId}";
	}

	public override async Task OnConnectedAsync()
	{
		await base.OnConnectedAsync();
	}

	[HubMethodName(DawHubMethods.Server.JoinDawProject)]
	public async Task JoinDawProject(long sessionId)
	{
		await Groups.AddToGroupAsync(Context.ConnectionId, DawProjectGroup(sessionId));
	}

	[HubMethodName(DawHubMethods.Server.RequestStopSharingVideo)]
	public async Task RequestStopSharingVideo(long sessionId)
	{
		await Clients.OthersInGroup(DawProjectGroup(sessionId)).SendAsync(DawHubMethods.Client.OnRequestStopSharingVideo);
	}
}