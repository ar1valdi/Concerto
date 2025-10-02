using Concerto.Server.Data.Models;

public interface ITranslationsService
{

    /// <summary>
    /// Get translations that have been updated since the last update
    /// </summary>
    /// <param name="lastUpdate">The last update time. If set to null, all translations will be returned.</param>
    /// <returns>A list of translations</returns>
    Task<List<Translation>> GetTranslationsDiff(DateTime? lastUpdate, string lang);

    /// <summary>
    /// Update a range of translations. Last update time is set to the current date and time.
    /// </summary>
    /// <param name="translations">The translations to update</param>
    /// <returns>A list of translations</returns>
    Task<List<Translation>> UpdateTranslationsRange(List<Translation> translations);

    /// <summary>
    /// Get all translations
    /// </summary>
    /// <returns>A list of translations</returns>
    Task<List<Translation>> GetAllTranslationsAsync();
}