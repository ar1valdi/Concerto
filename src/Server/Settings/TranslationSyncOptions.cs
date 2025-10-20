namespace Concerto.Server.Settings;

/// <summary>
/// Configuration options for the Translation Sync Service
/// </summary>
public class TranslationSyncOptions
{
    public const string SectionName = "TranslationSync";

    /// <summary>
    /// Whether to automatically sync translations on application startup
    /// Default: true in Development, false in Production
    /// </summary>
    public bool AutoSyncOnStartup { get; set; } = true;

    /// <summary>
    /// Whether to force overwrite existing translations during sync
    /// Default: false (only adds missing translations)
    /// </summary>
    public bool ForceOverwrite { get; set; } = false;

    /// <summary>
    /// Supported language codes
    /// </summary>
    public string[] SupportedLanguages { get; set; } = { "en", "pl" };

    /// <summary>
    /// Path to the translation files directory (relative to ContentRootPath)
    /// </summary>
    public string TranslationFilesPath { get; set; } = "wwwroot/lang";

    /// <summary>
    /// File name pattern for hierarchical translation files
    /// {0} will be replaced with language code
    /// </summary>
    public string HierarchicalFilePattern { get; set; } = "{0}.hierarchical.json";

    /// <summary>
    /// Whether to validate translation files on startup
    /// </summary>
    public bool ValidateFilesOnStartup { get; set; } = true;
}
