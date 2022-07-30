using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Hosting.StaticWebAssets;
using Microsoft.AspNetCore.ResponseCompression;
using Concerto.Shared.Extensions;
using Concerto.Server.Data;
using Microsoft.EntityFrameworkCore;
using Concerto.Shared.Models;

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
       options.MetadataAddress = "http://keycloak:8080/realms/concerto/.well-known/openid-configuration";
       options.Authority = "http://keycloak:8080/realms/concerto";
       options.Audience = "account";
   });

builder.Services.AddAuthorization();

// Configure database context
builder.Services.AddDbContext<AppDataContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("ConcertoDb"))
);
builder.Services.AddScoped<AppDataContext>();

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