namespace Concerto.Shared.Models.Dto;

public record Translation(
    /// <summary>
    /// The unique identifier for the translation
    /// </summary>
    long Id,

    /// <summary>
    /// Language code (e.g., "en", "pl")
    /// </summary>
    string Language,

    /// <summary>
    /// View/section name (e.g., "home", "admin", "navigation")
    /// </summary>
    string View,

    /// <summary>
    /// Translation key within the view (e.g., "title", "adminVerificationRequired")
    /// </summary>
    string Key,

    /// <summary>
    /// The translated text value
    /// </summary>
    string Value,

    /// <summary>
    /// When this translation was last updated
    /// </summary>
    DateTime LastUpdated
);
public record TranslationSlim(
    /// <summary>
    /// View/section name (e.g., "home", "admin", "navigation")
    /// </summary>
    string View,
    
    /// <summary>
    /// Translation key within the view (e.g., "title", "adminVerificationRequired")
    /// </summary>
    string Key,
    
    /// <summary>
    /// The translated text value
    /// </summary>
    string Value
);