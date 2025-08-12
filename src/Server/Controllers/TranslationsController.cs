using Concerto.Server.Data.Models;
using Concerto.Server.Middlewares;
using Concerto.Server.Services;
using Concerto.Shared.Extensions;
using Concerto.Shared.Models.Dto;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace Concerto.Server.Controllers;
[Route("[controller]/[action]")]
[ApiController]
[Authorize]
public class TranlsationsController : ControllerBase
{
	private readonly ITranslationsService _translationsService;

	public TranlsationsController(ITranslationsService translationsService)
	{
		_translationsService = translationsService;
	}

	[HttpGet]
	[AllowAnonymous]
	public async Task<ActionResult> GetTranslationsDiff([FromQuery] DateTime lastUpdate)
	{
		return Ok(await _translationsService.GetTranslationsDiff(lastUpdate));
	}

    [HttpPut]
    [Authorize(Policy = AuthorizationPolicies.IsAdmin.Name)]
    public async Task<ActionResult> UpdateTranslationsRange([FromBody] List<Translation> translations)
    {
        return Ok(await _translationsService.UpdateTranslationsRange(translations));
    }
}

