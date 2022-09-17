using Microsoft.AspNetCore.SignalR;
using Concerto.Shared.Extensions;

namespace Concerto.Server.Extensions;

public static class HubCallerContextExtensions
{
    public static long? GetUserId(this HubCallerContext context)
    {
        return context.User?.FindFirst("user_id")?.Value.ToUserId();
    }

    public static string? GetUserIdString(this HubCallerContext context)
    {
        return context.User?.FindFirst("user_id")?.Value;
    }
}