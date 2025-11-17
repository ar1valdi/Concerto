using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using System.Collections.Concurrent;

namespace Concerto.Server.Hubs;

[Authorize]
public class StreamingHub : Hub
{
    private static readonly ConcurrentDictionary<string, StreamSession> ActiveStreams = new();
    private static readonly ConcurrentDictionary<string, List<string>> StreamViewers = new();
    
    private readonly ILogger<StreamingHub> _logger;

    public StreamingHub(ILogger<StreamingHub> logger)
    {
        _logger = logger;
    }

    public async Task StartStream(string streamId)
    {
        var connectionId = Context.ConnectionId;
        var userId = GetUserId();
        
        var streamSession = new StreamSession
        {
            StreamId = streamId,
            HostConnectionId = connectionId,
            HostUserId = userId,
            StartTime = DateTime.UtcNow,
            IsActive = true
        };
        
        ActiveStreams.TryAdd(streamId, streamSession);
        StreamViewers.TryAdd(streamId, new List<string>());
        
        await Groups.AddToGroupAsync(connectionId, GetStreamGroup(streamId));
        
        _logger.LogInformation("Stream {StreamId} started by user {UserId}", streamId, userId);
        
        await Clients.Caller.SendAsync("StreamStarted", streamId);
    }

    public async Task StopStream(string streamId)
    {
        if (ActiveStreams.TryRemove(streamId, out var streamSession))
        {
            StreamViewers.TryRemove(streamId, out _);
            
            await Clients.Group(GetStreamGroup(streamId)).SendAsync("StreamEnded", streamId);
            await Groups.RemoveFromGroupAsync(streamSession.HostConnectionId, GetStreamGroup(streamId));
            
            _logger.LogInformation("Stream {StreamId} stopped", streamId);
        }
    }

    public async Task JoinStream(string streamId)
    {
        var connectionId = Context.ConnectionId;
        var userId = GetUserId();
        
        if (!ActiveStreams.ContainsKey(streamId))
        {
            await Clients.Caller.SendAsync("StreamNotFound", streamId);
            return;
        }
        
        if (StreamViewers.TryGetValue(streamId, out var viewers))
        {
            viewers.Add(connectionId);
        }
        
        await Groups.AddToGroupAsync(connectionId, GetStreamGroup(streamId));
        
        var streamSession = ActiveStreams[streamId];
        await Clients.Caller.SendAsync("StreamJoined", streamId, streamSession.HostConnectionId);
        
        await Clients.Client(streamSession.HostConnectionId).SendAsync("ViewerJoined", connectionId);
        
        _logger.LogInformation("User {UserId} joined stream {StreamId}", userId, streamId);
    }

    public async Task LeaveStream(string streamId)
    {
        var connectionId = Context.ConnectionId;
        
        if (StreamViewers.TryGetValue(streamId, out var viewers))
        {
            viewers.Remove(connectionId);
        }
        
        await Groups.RemoveFromGroupAsync(connectionId, GetStreamGroup(streamId));
        
        if (ActiveStreams.TryGetValue(streamId, out var streamSession))
        {
            await Clients.Client(streamSession.HostConnectionId).SendAsync("ViewerLeft", connectionId);
        }
        
        _logger.LogInformation("Connection {ConnectionId} left stream {StreamId}", connectionId, streamId);
    }

    public async Task SendOffer(string streamId, string targetConnectionId, string offer)
    {
        await Clients.Client(targetConnectionId).SendAsync("ReceiveOffer", streamId, Context.ConnectionId, offer);
    }

    public async Task SendAnswer(string streamId, string targetConnectionId, string answer)
    {
        await Clients.Client(targetConnectionId).SendAsync("ReceiveAnswer", streamId, Context.ConnectionId, answer);
    }

    public async Task SendIceCandidate(string streamId, string targetConnectionId, string candidate)
    {
        await Clients.Client(targetConnectionId).SendAsync("ReceiveIceCandidate", streamId, Context.ConnectionId, candidate);
    }

    public async Task GetActiveStreams()
    {
        var streams = ActiveStreams.Values.Select(s => new
        {
            s.StreamId,
            s.HostUserId,
            s.StartTime,
            ViewerCount = StreamViewers.TryGetValue(s.StreamId, out var viewers) ? viewers.Count : 0
        }).ToList();
        
        await Clients.Caller.SendAsync("ActiveStreams", streams);
    }

    public override async Task OnDisconnectedAsync(Exception? exception)
    {
        var connectionId = Context.ConnectionId;
        
        foreach (var stream in ActiveStreams.Values.Where(s => s.HostConnectionId == connectionId))
        {
            await StopStream(stream.StreamId);
        }
        
        foreach (var streamId in StreamViewers.Keys.ToList())
        {
            if (StreamViewers.TryGetValue(streamId, out var viewers))
            {
                viewers.Remove(connectionId);
            }
        }
        
        await base.OnDisconnectedAsync(exception);
    }

    private static string GetStreamGroup(string streamId) => $"stream-{streamId}";
    
    private Guid? GetUserId()
    {
        return (Guid?)Context.GetHttpContext()?.Items["AppUserId"];
    }

    private class StreamSession
    {
        public string StreamId { get; set; } = string.Empty;
        public string HostConnectionId { get; set; } = string.Empty;
        public Guid? HostUserId { get; set; }
        public DateTime StartTime { get; set; }
        public bool IsActive { get; set; }
    }
}
