using Concerto.Server.Services;
using Concerto.Server.Settings;

namespace Concerto.Server.Extensions;

/// <summary>
/// Extension methods for registering translation services
/// </summary>
public static class TranslationServiceExtensions
{
    /// <summary>
    /// Adds translation sync service to the DI container
    /// </summary>
    public static IServiceCollection AddTranslationSync(
        this IServiceCollection services, 
        IConfiguration configuration)
    {
        // Configure options
        services.Configure<TranslationSyncOptions>(
            configuration.GetSection(TranslationSyncOptions.SectionName));

        // Register the sync service
        services.AddScoped<TranslationSyncService>();

        return services;
    }

    /// <summary>
    /// Initializes translation sync on application startup (if configured)
    /// </summary>
    public static async Task<WebApplication> InitializeTranslationSyncAsync(this WebApplication app)
    {
        var options = app.Configuration
            .GetSection(TranslationSyncOptions.SectionName)
            .Get<TranslationSyncOptions>() ?? new TranslationSyncOptions();

        // Only auto-sync in development environment by default
        var shouldAutoSync = options.AutoSyncOnStartup && 
                           (app.Environment.IsDevelopment() || options.ForceOverwrite);

        if (shouldAutoSync)
        {
            using var scope = app.Services.CreateScope();
            var syncService = scope.ServiceProvider.GetRequiredService<TranslationSyncService>();
            var logger = scope.ServiceProvider.GetRequiredService<ILogger<TranslationSyncService>>();

            try
            {
                if (options.ValidateFilesOnStartup && !syncService.ValidateTranslationFiles())
                {
                    logger.LogWarning("Some translation files are missing. Skipping auto-sync.");
                    return app;
                }

                var syncedCount = await syncService.SyncAllTranslationsAsync(options.ForceOverwrite);
                logger.LogInformation("Auto-sync completed. Synced {Count} translations.", syncedCount);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Failed to auto-sync translations on startup.");
                // Don't throw - let the app start even if sync fails
            }
        }

        return app;
    }
}
