using System;
using System.Collections.Generic;
using Concerto.Server.Settings;
using Concerto.Shared.Models.Dto;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Concerto.Server.Controllers;

[Route("[controller]/[action]")]
[ApiController]
public class AppSettingsController : ControllerBase
{
	[AllowAnonymous]
	[HttpGet]
	public ActionResult<ClientAppSettings> GetClientAppSettings()
	{
		var x = new ClientAppSettings
		{
			AuthorityUrl = AppSettings.Oidc.ClientAuthority,
			AdminConsoleUrl = AppSettings.IdentityProvider.AdminConsoleUrl,
			AccountManagementUrl = AppSettings.IdentityProvider.AccountConsoleUrl,
			PostLogoutUrl = AppSettings.Oidc.ClientPostLogoutRedirectUrl,
			FileSizeLimit = AppSettings.Storage.FileSizeLimit,
			MaxAllowedFiles = AppSettings.Storage.MaxAllowedFiles,
			IceServers = BuildIceServers(),
			// Jitsi disabled
			// JitsiUrl = AppSettings.Meetings.JitsiUrl,
			// JitsiAppDownloadUrl = AppSettings.Meetings.JitsiAppDownloadUrl
		};
		return Ok(x);
	}

	private static IReadOnlyCollection<ClientIceServer> BuildIceServers()
	{
		if (!AppSettings.Turn.IsConfigured || !AppSettings.Turn.HasCredentials)
		{
			return Array.Empty<ClientIceServer>();
		}

		var servers = new List<ClientIceServer>
		{
			new ClientIceServer
			{
				Urls = new[]
				{
					$"turn:{AppSettings.Turn.Domain}:{AppSettings.Turn.StunPort}?transport=udp",
					$"turn:{AppSettings.Turn.Domain}:{AppSettings.Turn.StunPort}?transport=tcp"
				},
				Username = AppSettings.Turn.Username,
				Credential = AppSettings.Turn.Password
			}
		};

		if (AppSettings.Turn.TlsPort > 0)
		{
			servers.Add(new ClientIceServer
			{
				Urls = new[]
				{
					$"turns:{AppSettings.Turn.Domain}:{AppSettings.Turn.TlsPort}"
				},
				Username = AppSettings.Turn.Username,
				Credential = AppSettings.Turn.Password
			});
		}

		return servers;
	}
}

