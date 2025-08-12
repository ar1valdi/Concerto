using Concerto.Server.Data.DatabaseContext;
using Concerto.Server.Data.Models;
using Concerto.Server.Settings;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System.Text.Json;

namespace Concerto.Server.Services;

/// <summary>
/// Service responsible for managing translations
/// </summary>
public class TranslationsService : ITranslationsService
{
    private readonly ConcertoDbContext _context;
    private readonly ILogger<TranslationsService> _logger;

    public TranslationsService(
        ConcertoDbContext context, 
        ILogger<TranslationsService> logger)
    {
        _context = context;
        _logger = logger;
    }

    /// <summary>
    /// Get translations that have been updated since the last update
    /// </summary>
    /// <param name="lastUpdate">The last update time. If set to null, all translations will be returned.</param>
    /// <returns>A list of translations</returns>
    public async Task<List<Translation>> GetTranslationsDiff(DateTime? lastUpdate)
    {
        _logger.LogInformation("Getting translations diff for last update: {LastUpdate}", lastUpdate);
        return await _context.Translations.Where(t => lastUpdate == null || t.LastUpdated >= lastUpdate).ToListAsync();
    }

    /// <summary>
    /// Update a range of translations. Last update time is set to the current date and time.
    /// </summary>
    /// <param name="translations">The translations to update</param>
    /// <returns>A list of translations</returns>
    public async Task<List<Translation>> UpdateTranslationsRange(List<Translation> translations)
    {
        _logger.LogInformation("Updating translations range: {TranslationsCount}.", translations.Count);

        var currDate = DateTime.UtcNow;
        translations.ForEach(t => t.LastUpdated = currDate);
        
        _context.Translations.UpdateRange(translations);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Translations range updated: {TranslationsCount}.", translations.Count);

        return translations;
    }
}