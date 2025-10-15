﻿using Concerto.Server.Extensions;

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

	public static class Meetings
	{
		public static string RecorderKey = EnvironmentHelper.GetVariable("JITSI_RECORDER_PASSWORD");
		public static string JwtSecret = EnvironmentHelper.GetVariable("JITSI_JWT_SECRET");
		public static string JwtAppId = EnvironmentHelper.GetVariable("JITSI_JWT_APP_ID");
		public static Uri  JitsiUrl = new Uri(EnvironmentHelper.GetVariable("JITSI_MEET_URL"));
		public static string JitsiAppDownloadUrl = EnvironmentHelper.GetVariable("JITSI_APP_DOWNLOAD_URL");
	}
}

