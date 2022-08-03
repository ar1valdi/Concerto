using Concerto.Shared.Extensions;
using System.Security.Claims;

namespace Concerto.Server.Extensions;

public static class ClaimsPrincipalExtensions
{
    public static long? GetUserId(this ClaimsPrincipal user)
    {
        return user.FindFirst("user_id")?.Value.ToUserId();
    }

    public static string? GetUserIdString(this ClaimsPrincipal user)
    {
        return user.FindFirst("user_id")?.Value;
    }
}