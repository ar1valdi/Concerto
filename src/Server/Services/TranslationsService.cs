using Concerto.Client.Services;
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
    public async Task<List<Translation>> GetAllTranslationsAsync()
    {
        return await _context.Translations.ToListAsync();
    }
    public async Task<List<Translation>> GetTranslationsDiff(DateTime? lastUpdate, string lang)
    {
        _logger.LogInformation("Getting translations diff for last update: {LastUpdate}", lastUpdate);
        return await _context.Translations.Where(t => lastUpdate == null || t.LastUpdated >= lastUpdate && t.Language == lang).ToListAsync();
    }
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