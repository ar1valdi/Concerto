using System.ComponentModel.DataAnnotations;

namespace Concerto.Shared.Models.Dto;

/// <summary>
/// Represents a language configuration in the system
/// </summary>
public class Language
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
    [Required]
    public bool IsPublic { get; set; } = false;
}
