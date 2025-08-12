using System.ComponentModel.DataAnnotations;

namespace Concerto.Server.Data.Models;

/// <summary>
/// Database model for storing translations in a normalized format
/// Each row represents one translation key-value pair for a specific language and view
/// </summary>
public class Translation : Entity
{
    /// <summary>
    /// Language code (e.g., "en", "pl")
    /// </summary>
    [Required]
    [MaxLength(10)]
    public string Language { get; set; } = string.Empty;

    /// <summary>
    /// View/section name (e.g., "home", "admin", "navigation")
    /// </summary>
    [Required]
    [MaxLength(50)]
    public string View { get; set; } = string.Empty;

    /// <summary>
    /// Translation key within the view (e.g., "title", "adminVerificationRequired")
    /// </summary>
    [Required]
    [MaxLength(100)]
    public string Key { get; set; } = string.Empty;

    /// <summary>
    /// The translated text value
    /// </summary>
    [Required]
    [MaxLength(2000)]
    public string Value { get; set; } = string.Empty;

    /// <summary>
    /// When this translation was last updated
    /// </summary>
    public DateTime LastUpdated { get; set; } = DateTime.UtcNow;
}

/// <summary>
/// Statistics about translations in the database
/// </summary>
public class TranslationStats
{
    public int TotalTranslations { get; set; }
    public List<LanguageStats> LanguageStats { get; set; } = new();
}

/// <summary>
/// Statistics for a specific language
/// </summary>
public class LanguageStats
{
    public string Language { get; set; } = string.Empty;
    public int Count { get; set; }
    public DateTime LastUpdated { get; set; }
}

