using Concerto.Server.Data.DatabaseContext;
using Concerto.Server.Data.Models;
using Concerto.Server.Settings;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System.Text.Json;

namespace Concerto.Server.Services;

/// <summary>
/// Service responsible for synchronizing JSON translation files with the database
/// This service is primarily used during development to sync changes from JSON files to the database
/// </summary>
public class TranslationSyncService
{
    private readonly ConcertoDbContext _context;
    private readonly ILogger<TranslationSyncService> _logger;
    private readonly IWebHostEnvironment _environment;
    private readonly TranslationSyncOptions _options;

    public TranslationSyncService(
        ConcertoDbContext context, 
        ILogger<TranslationSyncService> logger,
        IWebHostEnvironment environment,
        IOptions<TranslationSyncOptions> options)
    {
        _context = context;
        _logger = logger;
        _environment = environment;
        _options = options.Value;
    }

    /// <summary>
    /// Synchronizes all JSON translation files with the database
    /// This method reads hierarchical JSON files and updates the database accordingly
    /// </summary>
    /// <param name="force">If true, overwrites existing database translations with JSON values</param>
    /// <returns>Number of translations synchronized</returns>
    public async Task<int> SyncAllTranslationsAsync(bool force = false)
    {
        _logger.LogInformation("Starting translation sync process. Force mode: {Force}", force);
        
        var totalSynced = 0;
        var supportedLanguages = _options.SupportedLanguages;
        
        foreach (var language in supportedLanguages)
        {
            var synced = await SyncLanguageAsync(language, force);
            totalSynced += synced;
        }
        
        _logger.LogInformation("Translation sync completed. Total translations synced: {Count}", totalSynced);
        return totalSynced;
    }

    /// <summary>
    /// Synchronizes translations for a specific language
    /// </summary>
    /// <param name="language">Language code (e.g., "en", "pl")</param>
    /// <param name="force">If true, overwrites existing database translations</param>
    /// <returns>Number of translations synchronized for this language</returns>
    public async Task<int> SyncLanguageAsync(string language, bool force = false)
    {
        _logger.LogInformation("Syncing translations for language: {Language}", language);
        
        var jsonPath = GetJsonFilePath(language);
        if (!File.Exists(jsonPath))
        {
            _logger.LogWarning("Translation file not found: {Path}", jsonPath);
            return 0;
        }

        try
        {
            var jsonContent = await File.ReadAllTextAsync(jsonPath);
            var translationData = JsonSerializer.Deserialize<Dictionary<string, object>>(jsonContent);
            
            if (translationData == null)
            {
                _logger.LogError("Failed to deserialize translation file: {Path}", jsonPath);
                return 0;
            }

            return await ProcessTranslationData(language, translationData, force);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error syncing translations for language {Language}", language);
            throw;
        }
    }

    /// <summary>
    /// Processes hierarchical translation data and updates the database
    /// </summary>
    private async Task<int> ProcessTranslationData(
        string language, 
        Dictionary<string, object> translationData, 
        bool force)
    {
        var syncedCount = 0;
        var timestamp = DateTime.UtcNow;

        foreach (var (view, viewData) in translationData)
        {
            if (viewData is JsonElement jsonElement && jsonElement.ValueKind == JsonValueKind.Object)
            {
                var viewTranslations = JsonSerializer.Deserialize<Dictionary<string, string>>(jsonElement.GetRawText());
                if (viewTranslations != null)
                {
                    foreach (var (key, value) in viewTranslations)
                    {
                        if (await SyncTranslationAsync(language, view, key, value, timestamp, force))
                        {
                            syncedCount++;
                        }
                    }
                }
            }
        }

        if (syncedCount > 0)
        {
            await _context.SaveChangesAsync();
            _logger.LogInformation("Saved {Count} translations for language {Language}", syncedCount, language);
        }

        return syncedCount;
    }

    /// <summary>
    /// Synchronizes a single translation entry
    /// </summary>
    private async Task<bool> SyncTranslationAsync(
        string language, 
        string view, 
        string key, 
        string value, 
        DateTime timestamp,
        bool force)
    {
        var existingTranslation = await _context.Translations
            .FirstOrDefaultAsync(t => 
                t.Language == language && 
                t.View == view && 
                t.Key == key);

        if (existingTranslation == null)
        {
            // Create new translation
            var newTranslation = new Translation
            {
                Language = language,
                View = view,
                Key = key,
                Value = value,
                LastUpdated = timestamp
            };

            _context.Translations.Add(newTranslation);
            _logger.LogInformation("Added new translation: {Language}_{View}_{Key}", language, view, key);
            return true;
        }
        else if (force)
        {
            // Update existing translation
            existingTranslation.Value = value;
            existingTranslation.LastUpdated = timestamp;
            
            _logger.LogDebug("Updated translation: {Language}_{View}_{Key}", language, view, key);
            return true;
        }

        return false; // No changes made
    }

    /// <summary>
    /// Gets the file path for a language's JSON file
    /// </summary>
    private string GetJsonFilePath(string language)
    {
        var path = _options.TranslationFilesPath;
        var hierarchicalFilePattern = _options.HierarchicalFilePattern;
        var filename = string.Format(hierarchicalFilePattern, language);
        return Path.Combine(_environment.ContentRootPath, path, filename);
    }

    /// <summary>
    /// Validates that all required translation files exist
    /// </summary>
    public bool ValidateTranslationFiles()
    {
        var supportedLanguages = _options.SupportedLanguages;
        var allFilesExist = true;

        foreach (var language in supportedLanguages)
        {
            var filePath = GetJsonFilePath(language);
            if (!File.Exists(filePath))
            {
                _logger.LogInformation("Translation file missing: {Path}", filePath);
                allFilesExist = false;
            }
        }

        return allFilesExist;
    }
}
