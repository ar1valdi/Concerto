namespace Concerto.Shared.Models;

/// <summary>
/// Data Transfer Object for Language entity
/// </summary>
public class LanguageDto
{
    /// <summary>
    /// Unique language key identifier (e.g., "en", "pl", "es")
    /// </summary>
    public string Key { get; set; } = string.Empty;

    /// <summary>
    /// Display name of the language (e.g., "English", "Polski", "Español")
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Indicates whether the language is publicly available to users
    /// </summary>
    public bool IsPublic { get; set; } = false;
}