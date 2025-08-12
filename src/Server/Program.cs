global using Dto = Concerto.Shared.Models.Dto;
using Concerto.Server.Data.DatabaseContext;
using Concerto.Server.Extensions;
using Concerto.Server.Hubs;
using Concerto.Server.Middlewares;
using Concerto.Server.Services;
using Concerto.Server.Settings;
using Concerto.Shared.Extensions;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.ResponseCompression;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Logging;
using Microsoft.IdentityModel.Tokens;
using Npgsql;
using System.Diagnostics;
using System.Text.RegularExpressions;

var builder = WebApplication.CreateBuilder(args);
var logger = LoggerFactory.Create(config => config.AddConsole()).CreateLogger("Concerto.Server Builder");

builder.WebHost.ConfigureKestrel(serverOptions =>
{
    serverOptions.Limits.MaxRequestBodySize = 1_000_000_000;
});

builder.Services.AddSwaggerGen();
builder.Services.AddControllersWithViews();

builder.Services.AddRazorPages();
builder.Services.AddSignalR();
builder.Services.AddHttpClient();

builder.Services.AddHostedService<ScheduledTasksService>();
builder.Services.AddScoped<DawService, DawService>();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<ForumService>();
builder.Services.AddScoped<WorkspaceService>();
builder.Services.AddScoped<SessionService>();
builder.Services.AddScoped<StorageService>();
builder.Services.AddScoped<IdentityManagerService>();
builder.Services.AddScoped<ITranslationsService, TranslationsService>();

builder.Services.AddAuthentication(options =>
		{
			options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
			options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
			options.DefaultSignInScheme = CookieAuthenticationDefaults.AuthenticationScheme;
		}
	)
	.AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, options =>
		{
			options.RequireHttpsMetadata = AppSettings.Oidc.RequireHttpsMetadata;

			// Developement only - toggled by OIDC_ACCEPT_ANY_SERVER_CERTIFICATE_VALIDATOR enviroment variable
			if (AppSettings.Oidc.AcceptAnyServerCertificateValidator)
				options.BackchannelHttpHandler = new HttpClientHandler
				{
					ServerCertificateCustomValidationCallback = HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
				};

			options.MetadataAddress = AppSettings.Oidc.MetadataAddress;
			options.Authority = AppSettings.Oidc.Authority;
			options.Audience = AppSettings.Oidc.Audience;

			// Sending the access token in the query string is required when using WebSockets or ServerSentEvents
			// due to a limitation in Browser APIs.
			// https://learn.microsoft.com/en-us/aspnet/core/signalr/authn-and-authz?view=aspnetcore-7.0
			// Query is enrypted with HTTPS
			options.Events = new JwtBearerEvents
			{
				OnMessageReceived = context =>
				{
					if (string.IsNullOrEmpty(context.Token))
					{
						var accessToken = context.Request.Query["access_token"];
						if (!string.IsNullOrEmpty(accessToken))
						{
							context.Token = accessToken;
						}
					}
					return Task.CompletedTask;
				}
			};
		}
	);


// No request logging in production - avoids logging access tokens in SignalR requests
if (builder.Environment.IsProduction())
{
	builder.Logging.SetMinimumLevel(LogLevel.Warning);
}

builder.Services.AddAuthorization(options =>
{
	options.AddPolicy(AuthorizationPolicies.IsAuthenticated.Name, AuthorizationPolicies.IsAuthenticated.Policy());
	options.AddPolicy(AuthorizationPolicies.IsVerified.Name, AuthorizationPolicies.IsVerified.Policy());
	options.AddPolicy(AuthorizationPolicies.IsNotVerified.Name, AuthorizationPolicies.IsNotVerified.Policy());
	options.AddPolicy(AuthorizationPolicies.IsAdmin.Name, AuthorizationPolicies.IsAdmin.Policy());
	options.AddPolicy(AuthorizationPolicies.IsModerator.Name, AuthorizationPolicies.IsModerator.Policy());
	options.DefaultPolicy = AuthorizationPolicies.IsVerified.Policy();
});


// Configure database context
var connectionString = AppSettings.Database.DbString;
if (string.IsNullOrEmpty(connectionString))
{
    connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
}

builder.Services.AddDbContext<ConcertoDbContext>(options =>
	options.UseNpgsql(connectionString)
);
builder.Services.AddScoped<ConcertoDbContext>();
builder.Services.AddTranslationSync(builder.Configuration);

// Configure the HTTP request pipeline
if (builder.Environment.IsDevelopment())
{
	// Allow any origin if development environment
	builder.Services.AddCors(options =>
	{
		options.AddPolicy("DevPolicy", builder =>
		 builder.AllowAnyOrigin()
				.AllowAnyMethod()
				.AllowAnyHeader());
	});
}

var app = builder.Build();

app.UsePathBase($"/{AppSettings.Web.BasePath.Trim('/')}");

if (builder.Environment.IsDevelopment())
{
	// Enable swagger if development
	app.UseSwagger();
	app.UseSwaggerUI(c => { c.SwaggerEndpoint("/swagger/v1/swagger.json", "Blazor API V1"); });

	// Enable WebAssembly debugging if development
	app.UseWebAssemblyDebugging();
	app.UseCors("DevPolicy");
}
else
{	app.UseExceptionHandler("/Error");
	// Use HSTS in production
	// HTTPS is handled by the reverse proxy - the app should not be exposed directly to the internet
	// app.UseHttpsRedirection();
	// app.UseHsts();
}

await app.InitializeTranslationSyncAsync();
app.UseAuthentication();
app.UseUserIdMapperMiddleware();
app.UseBlazorFrameworkFiles();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();

app.MapRazorPages();
app.MapControllers();
app.MapHub<NotificationHub>("/notifications");
app.MapHub<DawHub>("/daw");

app.MapFallbackToFile("index.html");

app.MapGet("manifest.json", async (HttpContext context) =>
{
    context.Response.ContentType = "application/json";
    await context.Response.WriteAsync(
	$@"
		{{
		  ""name"": ""Concerto"",
		  ""description"": ""Collaborative music"",
		  ""short_name"": ""Concerto"",
		  ""start_url"": ""{AppSettings.Web.AppUrl}"",
		  ""display"": ""standalone"",
		  ""background_color"": ""#ffffff"",
		  ""theme_color"": ""#03173d"",
		  ""prefer_related_applications"": false,
		  ""icons"": [
			{{
			  ""src"": ""icon-512.png"",
			  ""type"": ""image/png"",
			  ""sizes"": ""512x512""
			}},
			{{
			  ""src"": ""icon-192.png"",
			  ""type"": ""image/png"",
			  ""sizes"": ""192x192""
			}}
		  ]
		}}
	"
	);
});


await using var scope = app.Services.CreateAsyncScope();
await using (var db = scope.ServiceProvider.GetService<ConcertoDbContext>())
{
	if (db == null) throw new NullReferenceException("Error while getting database context.");

	while (true)
	{
		try
		{
			db.Database.Migrate();
			break;
		}
		catch (NpgsqlException)
		{
			app.Logger.LogError("Can't connect to database, retrying in 5 seconds");
			await Task.Delay(5000);
		}
	}
}

Directory.CreateDirectory(AppSettings.Storage.StoragePath);
Directory.CreateDirectory(AppSettings.Storage.TempPath);
Directory.CreateDirectory(AppSettings.Storage.DawPath);

app.Run();