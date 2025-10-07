using Blazored.LocalStorage;
using Concerto.Client.UI;
using Concerto.Client.Extensions;
using Concerto.Client.Services;
using Concerto.Shared.Extensions;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Authentication;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using MudBlazor.Services;
using MudBlazor;
using Microsoft.JSInterop;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

var baseAddress = new Uri(builder.HostEnvironment.BaseAddress);
// Add HTTP Client with base address and authorization handler 
if (builder.HostEnvironment.Environment == "Development")
{
    var configuredBase = builder.Configuration["ServerlessBaseURL"];
    if (!string.IsNullOrWhiteSpace(configuredBase))
    {
        baseAddress = new Uri(configuredBase);
    }
    builder.Services.AddHttpClient("WebAPI", client => client.BaseAddress = baseAddress)
    .AddHttpMessageHandler(sp =>
    {
        var handler = sp.GetRequiredService<AuthorizationMessageHandler>()
            .ConfigureHandler(new[] { baseAddress.ToString() });
        return handler;
    });

    builder.Services.AddHttpClient("AnonymousClient", client =>
    {
        client.BaseAddress = new Uri(baseAddress.ToString());
    });
}
else
{
    builder.Services.AddHttpClient("WebAPI", client => client.BaseAddress = baseAddress)
    .AddHttpMessageHandler<BaseAddressAuthorizationMessageHandler>();

    builder.Services.AddHttpClient("AnonymousClient", client =>
    {
        client.BaseAddress = new Uri(baseAddress.ToString());
    });
}

// Register it as scoped, each service will use the same HTTP client provided by DI
builder.Services.AddScoped(sp => sp.GetRequiredService<IHttpClientFactory>().CreateClient("WebAPI"));
AppSettingsService appSettingsService = new AppSettingsService(new HttpClient { BaseAddress = baseAddress });
await appSettingsService.FetchAppSettings();
var appSettings = appSettingsService.AppSettings;
builder.Services.AddSingleton<IAppSettingsService, AppSettingsService>(sp => appSettingsService);
builder.Services.AddScoped<IWorkspaceService, WorkspaceService>();
builder.Services.AddScoped<ISessionService, SessionService>();
builder.Services.AddScoped<IForumService, ForumService>();
builder.Services.AddScoped<DawService, DawService>();
builder.Services.AddScoped<IStorageService, StorageService>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IAccountClient, AccountClient>();
builder.Services.AddScoped<ILanguagesClient>(sp =>
{
    var http = sp.GetRequiredService<IHttpClientFactory>().CreateClient("AnonymousClient");
    return new LanguagesClient(http);
});
builder.Services.AddScoped<ITranlsationsClient>(sp =>
{
    var http = sp.GetRequiredService<IHttpClientFactory>().CreateClient("AnonymousClient");
    return new TranlsationsClient(http);
});
builder.Services.AddScoped<IBreadcrumbsService, BreadcrumbsService>();
builder.Services.AddScoped<ITranslationsService, TranslationsService>();
builder.Services.AddScoped<IOverridableLanguageService, LanguageServiceOverridable>();
builder.Services.AddScoped<ILanguageManagementService, LanguageManagementService>();

builder.Services.AddMudServices(config => 
    {
        config.SnackbarConfiguration.PositionClass = Defaults.Classes.Position.BottomRight;
        config.SnackbarConfiguration.HideTransitionDuration = 100;
        config.SnackbarConfiguration.ShowTransitionDuration = 100;
        config.SnackbarConfiguration.PreventDuplicates = false;
    });

builder.Services.AddBlazoredLocalStorage();

builder.Services.AddOidcAuthentication(options =>
    {
        options.ProviderOptions.Authority = appSettings.AuthorityUrl;
        options.ProviderOptions.ClientId = "concerto-client";
        options.ProviderOptions.ResponseType = "code";
        options.ProviderOptions.PostLogoutRedirectUri = appSettings.PostLogoutUrl;
        options.ProviderOptions.DefaultScopes.Add("roles");
        options.AuthenticationPaths.RemoteRegisterPath = $"{appSettings.AuthorityUrl}/login-actions/registration";
        options.UserOptions.RoleClaim = "role";  
    })
    .AddAccountClaimsPrincipalFactory<RemoteAuthenticationState, RemoteUserAccount, CustomAccountFactory>();

builder.Services.AddAuthorizationCore(options =>
{
    options.AddPolicy(AuthorizationPolicies.IsAuthenticated.Name, AuthorizationPolicies.IsAuthenticated.Policy());
    options.AddPolicy(AuthorizationPolicies.IsVerified.Name, AuthorizationPolicies.IsVerified.Policy());
    options.AddPolicy(AuthorizationPolicies.IsNotVerified.Name, AuthorizationPolicies.IsNotVerified.Policy());
    options.AddPolicy(AuthorizationPolicies.IsAdmin.Name, AuthorizationPolicies.IsAdmin.Policy());
    options.AddPolicy(AuthorizationPolicies.IsModerator.Name, AuthorizationPolicies.IsModerator.Policy());
    options.DefaultPolicy = AuthorizationPolicies.IsVerified.Policy();
});


var host = builder.Build();
var translationService = host.Services.GetRequiredService<ITranslationsService>();
try
{
    await translationService.InitializeAsync();
    await translationService.ChangeLanguage(translationService.GetCurrentLanguage());
}
catch (Exception ex)
{
    Console.Error.WriteLine($"Translations initialization failed: {ex}");
}
await host.RunAsync();