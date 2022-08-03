using Concerto.Shared.Extensions;

namespace Concerto.Server.Extensions;

public static class IWebHostEnvironmentExtensions
{
    public static bool IsDocker (this IWebHostEnvironment environment)
    {
        return EnvironmentHelper.GetVariable("ASPNETCORE_DOCKER").Equals("true");
    }
}
