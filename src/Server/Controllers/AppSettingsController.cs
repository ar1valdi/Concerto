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
		var servers = new List<ClientIceServer>();

		foreach (var turnServer in AppSettings.Turn.GetAllServers())
		{
			if (turnServer.StunPort > 0)
			{
				servers.Add(new ClientIceServer
				{
					Urls = new[]
					{
						$"stun:{turnServer.Domain}:{turnServer.StunPort}"
					}
				});
			}

			servers.Add(new ClientIceServer
			{
				Urls = new[]
				{
					$"turn:{turnServer.Domain}:{turnServer.StunPort}?transport=udp",
					$"turn:{turnServer.Domain}:{turnServer.StunPort}?transport=tcp"
				},
				Username = turnServer.Username,
				Credential = turnServer.Password
			});

			if (turnServer.TlsPort > 0)
			{
				servers.Add(new ClientIceServer
				{
					Urls = new[]
					{
						$"stuns:{turnServer.Domain}:{turnServer.TlsPort}",
						$"turns:{turnServer.Domain}:{turnServer.TlsPort}"
					},
					Username = turnServer.Username,
					Credential = turnServer.Password
				});
			}
		}

		return servers;
	}
}

