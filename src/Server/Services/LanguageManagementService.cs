using Concerto.Server.Data.DatabaseContext;
using Concerto.Server.Data.Models;
using Microsoft.EntityFrameworkCore;

namespace Concerto.Server.Services;

public class LanguageManagementService : ILanguageManagementService
{
    private readonly ConcertoDbContext _context;
    private readonly ILogger<LanguageManagementService> _logger;

    public LanguageManagementService(
        ConcertoDbContext context,
        ILogger<LanguageManagementService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<Language> CreateLanguageAsync(string key, string name, bool isPublic = false)
    {
        _logger.LogInformation("Creating language: {Key} - {Name} (Public: {IsPublic})", key, name, isPublic);

        var existingLanguage = await _context.Languages.FindAsync(key);
        if (existingLanguage != null)
        {
            throw new InvalidOperationException($"Language with key '{key}' already exists");
        }

        var language = new Language
        {
            Key = key,
            Name = name,
            IsPublic = isPublic
        };

        _context.Languages.Add(language);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Language created successfully: {Key}", key);
        return language;
    }

    public async Task<Language> PublishLanguageAsync(string key)
    {
        _logger.LogInformation("Publishing language: {Key}", key);

        var language = await _context.Languages.FindAsync(key);
        if (language == null)
        {
            throw new InvalidOperationException($"Language with key '{key}' not found");
        }

        language.IsPublic = true;

        await _context.SaveChangesAsync();

        _logger.LogInformation("Language published successfully: {Key}", key);
        return language;
    }

    public async Task<Language> HideLanguageAsync(string key)
    {
        _logger.LogInformation("Hiding language: {Key}", key);

        var language = await _context.Languages.FindAsync(key);
        if (language == null)
        {
            throw new InvalidOperationException($"Language with key '{key}' not found");
        }

        language.IsPublic = false;

        await _context.SaveChangesAsync();

        _logger.LogInformation("Language hidden successfully: {Key}", key);
        return language;
    }

    public async Task<List<Language>> GetAvailableLanguagesAsync()
    {
        return await _context.Languages
            .Where(l => l.IsPublic)
            .OrderBy(l => l.Name)
            .ToListAsync();
    }

    public async Task<List<Language>> GetAllLanguagesAsync()
    {
        return await _context.Languages
            .OrderBy(l => l.Name)
            .ToListAsync();
    }

    public async Task<Language?> GetLanguageByKeyAsync(string key)
    {
        return await _context.Languages.FindAsync(key);
    }

    public async Task DeleteLanguageAsync(string key)
    {
        _logger.LogInformation("Deleting language: {Key}", key);

        var language = await _context.Languages.FindAsync(key);
        if (language == null)
        {
            throw new InvalidOperationException($"Language with key '{key}' not found");
        }

        _context.Languages.Remove(language);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Language deleted successfully: {Key}", key);
    }
}
