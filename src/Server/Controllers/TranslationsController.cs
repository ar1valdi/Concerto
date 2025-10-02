using Concerto.Server.Data.Models;
using Concerto.Shared.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

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
	public async Task<ActionResult<List<Dto.TranslationSlim>>> GetTranslationsDiff([FromQuery] string lang, [FromQuery] DateTime lastUpdate)
	{
		var translations = await _translationsService.GetTranslationsDiff(lastUpdate, lang);
		var translationsSlim = translations.Select(t => t.ToViewModelSlim());
		return Ok(translationsSlim);
	}

	[AllowAnonymous]
	public async Task<ActionResult<List<Dto.TranslationSlim>>> GetTranslationsFull()
	{
		var translations = await _translationsService.GetAllTranslationsAsync();
		return Ok(translations.Select(t => t.ToViewModelSlim()).ToList());
	}

    [HttpPut]
    [Authorize(Policy = AuthorizationPolicies.IsAdmin.Name)]
    public async Task<ActionResult> UpdateTranslationsRange([FromBody] List<Dto.Translation> translations)
    {
        return Ok(await _translationsService.UpdateTranslationsRange(translations.Select(x => x.ToEntity()).ToList()));
    }
}

