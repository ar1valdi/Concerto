namespace Concerto.Shared.Models.Dto;

/// <summary>
/// Data Transfer Object for TranslationLocation entity
/// Represents a unique location where translations can exist (View + Key pair)
/// </summary>
public record TranslationLocation(
    /// <summary>
    /// View name (e.g., "home", "admin", "navigation")
    /// </summary>
    string View,
    
    /// <summary>
    /// Translation key within the view (e.g., "title", "adminVerificationRequired")
    /// </summary>
    string Key
);


