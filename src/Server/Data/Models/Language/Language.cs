using System.ComponentModel.DataAnnotations;

namespace Concerto.Server.Data.Models;

/// <summary>
/// Represents a language configuration in the system
/// </summary>
public class Language : IEntityWithoutId
{
    /// <summary>
    /// Unique language key identifier (e.g., "en", "pl", "es")
    /// </summary>
    [Key]
    public string Key { get; set; } = string.Empty;

    /// <summary>
    /// Display name of the language (e.g., "English", "Polski", "Español")
    /// </summary>
    [Required]
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Indicates whether the language is publicly available to users
    /// </summary>
    public bool IsPublic { get; set; } = false;
}


public static partial class ViewModelConversions
{
    public static Dto.Language ToViewModel(this Language language)
    {
        return new Dto.Language { Key = language.Key, Name = language.Name, IsPublic = language.IsPublic };
    }

    public static IEnumerable<Dto.Language> ToViewModel(this IEnumerable<Language> languages)
    {
        return languages.Select(c => c.ToViewModel());
    }
}
