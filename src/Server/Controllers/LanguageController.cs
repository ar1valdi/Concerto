using Concerto.Server.Data.Models;
using Concerto.Server.Services;
using Concerto.Shared.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Concerto.Server.Controllers;

[Route("[controller]")]
[ApiController]
[Authorize]
public class LanguageController : ControllerBase
{
    private readonly ILanguageManagementService _languageManagementService;
    private readonly ILogger<LanguageController> _logger;

    public LanguageController(
        ILanguageManagementService languageManagementService,
        ILogger<LanguageController> logger)
    {
        _languageManagementService = languageManagementService;
        _logger = logger;
    }

    [HttpPost]
    [Authorize(Policy = AuthorizationPolicies.IsAdmin.Name)]
    public async Task<ActionResult<Dto.Language>> CreateLanguage([FromBody] CreateLanguageRequest request)
    {
        try
        {
            var language = await _languageManagementService.CreateLanguageAsync(
                request.Key, 
                request.Name, 
                request.IsPublic);

            return Ok(language.ToViewModel());
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating language: {Key}", request.Key);
            return StatusCode(500, "Internal server error");
        }
    }

    [HttpPut("{key}/publish")]
    [Authorize(Policy = AuthorizationPolicies.IsAdmin.Name)]
    public async Task<ActionResult<Dto.Language>> PublishLanguage(string key)
    {
        try
        {
            var language = await _languageManagementService.PublishLanguageAsync(key);
            return Ok(language.ToViewModel());
        }
        catch (InvalidOperationException ex)
        {
            return NotFound(ex.Message);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error publishing language: {Key}", key);
            return StatusCode(500, "Internal server error");
        }
    }

    [HttpPut("{key}/hide")]
    [Authorize(Policy = AuthorizationPolicies.IsAdmin.Name)]
    public async Task<ActionResult<Dto.Language>> HideLanguage(string key)
    {
        try
        {
            var language = await _languageManagementService.HideLanguageAsync(key);
            return Ok(language.ToViewModel());
        }
        catch (InvalidOperationException ex)
        {
            return NotFound(ex.Message);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error hiding language: {Key}", key);
            return StatusCode(500, "Internal server error");
        }
    }

    [HttpGet("{key}/available")]
    [AllowAnonymous]
    public async Task<ActionResult<bool>> IsLanguageAvailable(string key)
    {
        try
        {
            var isAvailable = await _languageManagementService.IsLanguageAvailableAsync(key);
            return Ok(isAvailable);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error checking language availability: {Key}", key);
            return StatusCode(500, "Internal server error");
        }
    }

    [HttpGet("available")]
    [AllowAnonymous]
    public async Task<ActionResult<List<Dto.Language>>> GetAvailableLanguages()
    {
        try
        {
            var languages = await _languageManagementService.GetAvailableLanguagesAsync();
            return Ok(languages.ToViewModel());
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting available languages");
            return StatusCode(500, "Internal server error");
        }
    }

    [HttpGet("all")]
    [Authorize(Policy = AuthorizationPolicies.IsAdmin.Name)]
    public async Task<ActionResult<List<Dto.Language>>> GetAllLanguages()
    {
        try
        {
            var languages = await _languageManagementService.GetAllLanguagesAsync();
            return Ok(languages.ToViewModel());
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting all languages");
            return StatusCode(500, "Internal server error");
        }
    }

    [HttpGet("{key}")]
    [AllowAnonymous]
    public async Task<ActionResult<Dto.Language>> GetLanguage(string key)
    {
        try
        {
            var language = await _languageManagementService.GetLanguageByKeyAsync(key);
            if (language == null)
            {
                return NotFound($"Language with key '{key}' not found");
            }

            return Ok(language.ToViewModel());
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting language: {Key}", key);
            return StatusCode(500, "Internal server error");
        }
    }
}

public class CreateLanguageRequest
{
    public string Key { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public bool IsPublic { get; set; } = false;
}
