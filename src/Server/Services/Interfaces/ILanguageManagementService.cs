using Concerto.Server.Data.Models;

namespace Concerto.Server.Services;

public interface ILanguageManagementService
{
    /// <summary>
    /// Creates a new language configuration
    /// </summary>
    /// <param name="key">Language key identifier (e.g., "en", "pl")</param>
    /// <param name="name">Display name of the language</param>
    /// <param name="isPublic">Whether the language should be publicly available</param>
    /// <returns>Created language entity</returns>
    Task<Language> CreateLanguageAsync(string key, string name, bool isPublic = false);

    /// <summary>
    /// Publishes a language, making it available to all users
    /// </summary>
    /// <param name="key">Language key to publish</param>
    /// <returns>Updated language entity</returns>
    Task<Language> PublishLanguageAsync(string key);

    /// <summary>
    /// Hides a language, making it unavailable to regular users
    /// </summary>
    /// <param name="key">Language key to hide</param>
    /// <returns>Updated language entity</returns>
    Task<Language> HideLanguageAsync(string key);

    /// <summary>
    /// Checks if a language key is available in the application
    /// </summary>
    /// <param name="key">Language key to check</param>
    /// <returns>True if language exists and is public, false otherwise</returns>
    Task<bool> IsLanguageAvailableAsync(string key);

    /// <summary>
    /// Gets all available (public) languages
    /// </summary>
    /// <returns>List of available languages</returns>
    Task<List<Language>> GetAvailableLanguagesAsync();

    /// <summary>
    /// Gets all languages (including private ones) - admin only
    /// </summary>
    /// <returns>List of all languages</returns>
    Task<List<Language>> GetAllLanguagesAsync();

    /// <summary>
    /// Gets a specific language by key
    /// </summary>
    /// <param name="key">Language key</param>
    /// <returns>Language entity or null if not found</returns>
    Task<Language?> GetLanguageByKeyAsync(string key);
}
