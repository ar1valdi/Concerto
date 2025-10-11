using Concerto.Server.Data.DatabaseContext;
using Concerto.Server.Data.Models;
using Microsoft.EntityFrameworkCore;

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

    public async Task<List<TranslationLocation>> GetAllTranslationLocationsAsync()
    {
        return await _context.TranslationLocations.ToListAsync();
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
        var updatedTranslations = new List<Translation>();

        foreach (var translation in translations)
        {
            // if already exists
            var existingTranslation = await _context.Translations
                .FirstOrDefaultAsync(t => 
                    t.Language == translation.Language && 
                    t.View == translation.View && 
                    t.Key == translation.Key);

            // delete if empty value
            if (string.IsNullOrWhiteSpace(translation.Value))
            {
                if (existingTranslation != null)
                {
                    _logger.LogInformation("Deleting translation: {Language}/{View}/{Key}", 
                        translation.Language, translation.View, translation.Key);
                    _context.Translations.Remove(existingTranslation);
                }
            }
            // update if exists
            else if (existingTranslation != null)
            {
                _logger.LogInformation("Updating translation: {Language}/{View}/{Key}", 
                    translation.Language, translation.View, translation.Key);
                existingTranslation.Value = translation.Value;
                existingTranslation.LastUpdated = currDate;
                updatedTranslations.Add(existingTranslation);
            }
            // create if new
            else
            {
                _logger.LogInformation("Creating translation: {Language}/{View}/{Key}", 
                    translation.Language, translation.View, translation.Key);
                
                // Ensure TranslationLocation exists
                var location = await _context.TranslationLocations
                    .FirstOrDefaultAsync(tl => tl.View == translation.View && tl.Key == translation.Key);
                
                if (location == null)
                {
                    location = new TranslationLocation
                    {
                        View = translation.View,
                        Key = translation.Key
                    };
                    _context.TranslationLocations.Add(location);
                }

                var newTranslation = new Translation
                {
                    Language = translation.Language,
                    View = translation.View,
                    Key = translation.Key,
                    Value = translation.Value,
                    LastUpdated = currDate
                };
                _context.Translations.Add(newTranslation);
                updatedTranslations.Add(newTranslation);
            }
        }

        await _context.SaveChangesAsync();

        _logger.LogInformation("Translations range processed: {TranslationsCount}.", updatedTranslations.Count);

        return updatedTranslations;
    }
}