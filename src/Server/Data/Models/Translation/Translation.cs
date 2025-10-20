using System.ComponentModel.DataAnnotations;

namespace Concerto.Server.Data.Models;

/// <summary>
/// Database model for storing translations in a normalized format
/// Each row represents one translation value for a specific language and location (view+key)
/// </summary>
public class Translation : Entity
{
    /// <summary>
    /// Language code (e.g., "en", "pl")
    /// </summary>
    [Required]
    public string Language { get; set; } = string.Empty;

    /// <summary>
    /// Navigation property to the Language entity
    /// </summary>
    public virtual Language LanguageEntity { get; set; } = null!;

    /// <summary>
    /// View/section name (e.g., "home", "admin", "navigation")
    /// Part of the composite foreign key to TranslationLocation
    /// </summary>
    [Required]
    public string View { get; set; } = string.Empty;

    /// <summary>
    /// Translation key within the view (e.g., "title", "adminVerificationRequired")
    /// Part of the composite foreign key to TranslationLocation
    /// </summary>
    [Required]
    public string Key { get; set; } = string.Empty;

    /// <summary>
    /// Navigation property to the TranslationLocation entity
    /// </summary>
    public virtual TranslationLocation Location { get; set; } = null!;

    /// <summary>
    /// The translated text value
    /// </summary>
    [Required]
    public string Value { get; set; } = string.Empty;

    /// <summary>
    /// When this translation was last updated
    /// </summary>
    public DateTime LastUpdated { get; set; } = DateTime.UtcNow;
}


public static partial class ViewModelConversions
{
    public static Dto.Translation ToViewModel(this Translation translation)
    {
        return new Dto.Translation(
            translation.Id, 
            translation.Language, 
            translation.View, 
            translation.Key, 
            translation.Value, 
            translation.LastUpdated
        );
    }

    public static Dto.TranslationSlim ToViewModelSlim(this Translation translation)
    {
        return new Dto.TranslationSlim(
            translation.View, 
            translation.Key, 
            translation.Value
        );
    }

    public static Translation ToEntity(this Dto.Translation translation)
    {
        return new Translation {
            Id = translation.Id, 
            Language = translation.Language, 
            View = translation.View, 
            Key = translation.Key, 
            Value = translation.Value, 
            LastUpdated = translation.LastUpdated
        };
    }
}