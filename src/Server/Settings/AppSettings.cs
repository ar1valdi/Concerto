using Concerto.Server.Extensions;

namespace Concerto.Server.Settings;

public static class AppSettings
{
    public static class Web
    {
        public static string AppUrl => $"{PublicUrl}{BasePath}";
        public static string PublicUrl = EnvironmentHelper.GetVariable("CONCERTO_BASE_URL");
        public static string BasePath = string.IsNullOrEmpty(EnvironmentHelper.GetVariable("CONCERTO_BASE_PATH"))
                                        ? ""
                                        : EnvironmentHelper.GetVariable("CONCERTO_BASE_PATH");
    }

    public static class Environment
    {
        public static bool Docker = EnvironmentHelper.GetVariable("DOTNET_RUNNING_IN_CONTAINER").Equals("true");
        public static bool Remote = EnvironmentHelper.GetVariable("ASPNETCORE_REMOTE").Equals("true");
    }

    public static class Storage
    {
        public static string StoragePath = string.IsNullOrEmpty(EnvironmentHelper.GetVariable("CONCERTO_STORAGE_PATH"))
                                           ? "/srv/concerto/storage"
                                           : EnvironmentHelper.GetVariable("CONCERTO_STORAGE_PATH");
        public static string TempPath = Path.Combine(StoragePath, "tmp");
        public static string DawPath = Path.Combine(StoragePath, "daw");
        public static TimeSpan TempFileExpirationSpan = TimeSpan.FromMinutes(5);
        public static long FileSizeLimit = long.MaxValue; // long.Parse(EnvironmentHelper.GetVariable("CONCERTO_FILE_SIZE_LIMIT_MB")) * 1024 * 1024;
        public static int MaxAllowedFiles = int.MaxValue; // int.Parse(EnvironmentHelper.GetVariable("CONCERTO_MAX_ALLOWED_FILES"));
        public static int StreamBufferSize = 524_288;
    }

    public static class IdentityProvider
    {
        public static string AccountConsoleUrl = EnvironmentHelper.GetVariable("IDENTITY_ACCOUNT_CONSOLE_URL");
        public static string AdminConsoleUrl = EnvironmentHelper.GetVariable("IDENTITY_ADMIN_CONSOLE_URL");
    }

    public static class Oidc
    {
        public static string ServerClientId = EnvironmentHelper.GetVariable("SERVER_CLIENT_ID");
        public static string ServerClientSecret = EnvironmentHelper.GetVariable("SERVER_CLIENT_SECRET");
        public static string OidcAdminRestApiBaseUrl = EnvironmentHelper.GetVariable("OIDC_ADMIN_REST_API_BASE");
        public static string MetadataAddress = EnvironmentHelper.GetVariable("OIDC_METADATA_ADDRESS");
        public static string Authority = EnvironmentHelper.GetVariable("OIDC_AUTHORITY");
        public static string ClientAuthority = EnvironmentHelper.GetVariable("OIDC_CLIENT_AUTHORITY");
        public static string ClientPostLogoutRedirectUrl = EnvironmentHelper.GetVariable("OIDC_CLIENT_POST_LOGOUT_REDIRECT_URL");
        public static string Audience = EnvironmentHelper.GetVariable("OIDC_AUDIENCE");
        public static bool AcceptAnyServerCertificateValidator = EnvironmentHelper.GetVariable("OIDC_ACCEPT_ANY_SERVER_CERTIFICATE_VALIDATOR").Equals("true");
        public static bool RequireHttpsMetadata = !EnvironmentHelper.GetVariable("OIDC_REQUIRE_HTTPS_METADATA").Equals("false");
    }

    public static class Database
    {
        public static string DbString = EnvironmentHelper.GetVariable("DB_STRING");
    }

    public static class Turn
    {
        private static int ParsePort(string variableName, int defaultValue)
        {
            var value = EnvironmentHelper.GetVariable(variableName);
            return int.TryParse(value, out var parsed) && parsed > 0 ? parsed : defaultValue;
        }

        // Primary TURN server configuration (backward compatible)
        public static string Domain = EnvironmentHelper.GetVariable("TURN_DOMAIN");
        public static string Username = EnvironmentHelper.GetVariable("TURN_USERNAME");
        public static string Password = EnvironmentHelper.GetVariable("TURN_PASSWORD");
        public static int StunPort = ParsePort("TURN_STUN_PORT", 3478);
        public static int TlsPort = ParsePort("TURN_TLS_PORT", 5349);
        public static int RelayMinPort = ParsePort("TURN_UDP_MIN_PORT", 10000);
        public static int RelayMaxPort = ParsePort("TURN_UDP_MAX_PORT", 10100);

        // Additional TURN servers (comma-separated: "turn2.example.com:user:pass,turn3.example.com:user:pass")
        public static string AdditionalServers = EnvironmentHelper.GetVariable("TURN_ADDITIONAL_SERVERS") ?? string.Empty;

        public static bool IsConfigured => !string.IsNullOrWhiteSpace(Domain);
        public static bool HasCredentials => !string.IsNullOrWhiteSpace(Username) && !string.IsNullOrWhiteSpace(Password);

        public static IEnumerable<TurnServerConfig> GetAllServers()
        {
            // Primary server
            if (IsConfigured && HasCredentials)
            {
                yield return new TurnServerConfig
                {
                    Domain = Domain,
                    Username = Username,
                    Password = Password,
                    StunPort = StunPort,
                    TlsPort = TlsPort
                };
            }

            // Additional servers
            if (!string.IsNullOrWhiteSpace(AdditionalServers))
            {
                foreach (var serverSpec in AdditionalServers.Split(',', StringSplitOptions.RemoveEmptyEntries))
                {
                    var parts = serverSpec.Trim().Split(':', StringSplitOptions.RemoveEmptyEntries);
                    if (parts.Length >= 3)
                    {
                        yield return new TurnServerConfig
                        {
                            Domain = parts[0],
                            Username = parts[1],
                            Password = parts[2],
                            StunPort = parts.Length > 3 && int.TryParse(parts[3], out var sp) ? sp : 3478,
                            TlsPort = parts.Length > 4 && int.TryParse(parts[4], out var tp) ? tp : 5349
                        };
                    }
                }
            }
        }
    }

    public class TurnServerConfig
    {
        public string Domain { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public int StunPort { get; set; } = 3478;
        public int TlsPort { get; set; } = 5349;
    }

    public static class Meetings { }
}

