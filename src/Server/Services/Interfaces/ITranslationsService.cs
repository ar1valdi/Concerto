using Concerto.Server.Data.Models;

public interface ITranslationsService
{
    Task<List<Translation>> GetTranslationsDiff(DateTime? lastUpdate);
    Task<List<Translation>> UpdateTranslationsRange(List<Translation> translations);
}