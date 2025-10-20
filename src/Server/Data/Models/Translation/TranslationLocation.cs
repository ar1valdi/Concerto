using System.ComponentModel.DataAnnotations;

namespace Concerto.Server.Data.Models;

/// <summary>
/// Represents a unique location where a translation can exist (View + Key pair)
/// This is separate from the actual translation values per language
/// </summary>
public class TranslationLocation : IEntityWithoutId
{
    /// <summary>
    /// View/section name (e.g., "home", "admin", "navigation")
    /// </summary>
    [Required]
    public string View { get; set; } = string.Empty;

    /// <summary>
    /// Translation key within the view (e.g., "title", "adminVerificationRequired")
    /// </summary>
    [Required]
    public string Key { get; set; } = string.Empty;
}


public static partial class ViewModelConversions
{
    public static Dto.TranslationLocation ToViewModel(this TranslationLocation location)
    {
        return new Dto.TranslationLocation(
            location.View, 
            location.Key
        );
    }

    public static IEnumerable<Dto.TranslationLocation> ToViewModel(this IEnumerable<TranslationLocation> locations)
    {
        return locations.Select(l => l.ToViewModel());
    }
}


