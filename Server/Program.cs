global using Dto = Concerto.Shared.Models.Dto;

using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Hosting.StaticWebAssets;
using Microsoft.AspNetCore.ResponseCompression;
using Concerto.Shared.Extensions;
using Microsoft.EntityFrameworkCore;
using Concerto.Shared.Models;
using Concerto.Server.Services;
using Concerto.Server.Data.DatabaseContext;

var builder = WebApplication.CreateBuilder(args);

StaticWebAssetsLoader.UseStaticWebAssets(builder.Environment, builder.Configuration);

// Add services to the container.

builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages();

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, options =>
   {
       if (builder.Environment.IsDevelopment())
       {
           options.BackchannelHttpHandler = new HttpClientHandler()
           {
               ServerCertificateCustomValidationCallback =
                   HttpClientHandler.DangerousAcceptAnyServerCertificateValidator,
           };
       }

       options.RequireHttpsMetadata = builder.Environment.IsProduction();

       if (EnvironmentHelper.GetVariable("ASPNETCORE_DOCKER").Equals("true"))
       {
           options.MetadataAddress = "http://keycloak:8080/realms/concerto/.well-known/openid-configuration";
           options.Authority = "http://keycloak:8080/realms/concerto";
       }
       else
       {
           options.MetadataAddress = "http://localhost:7200/realms/concerto/.well-known/openid-configuration";
           options.Authority = "http://localhost:7200/realms/concerto";
       }
       options.Audience = "account";


   });

builder.Services.AddAuthorization();

// Configure database context
builder.Services.AddDbContext<AppDataContext>(options =>
    options.UseNpgsql(EnvironmentHelper.GetVariable("DB_STRING"))
);
builder.Services.AddScoped<AppDataContext>();

// Add Services
builder.Services.AddScoped<UserService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseWebAssemblyDebugging();
}
else
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseAuthentication();

app.UseBlazorFrameworkFiles();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();
app.MapControllers();
app.MapFallbackToFile("index.html");


await using var scope = app.Services.CreateAsyncScope();
using (var db = scope.ServiceProvider.GetService<AppDataContext>())
{
    db.Database.Migrate();
}

app.Run();