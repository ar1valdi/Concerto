using Concerto.Shared.Models.Dto;
using System.Net.Http.Json;

namespace Concerto.Client.Services
{
    public interface ILanguageManagementService
    {
        Task<List<Language>> GetAvailableLanguagesAsync();
        Task<List<Language>> GetAllLanguagesAsync();
        Task<Language?> GetLanguageByKeyAsync(string key);
        Task<bool> IsLanguageAvailableAsync(string key);
        Task<Language> CreateLanguageAsync(CreateLanguageRequest request);
        Task<Language> PublishLanguageAsync(string key);
        Task<Language> HideLanguageAsync(string key);
    }

    public class LanguageManagementService : ILanguageManagementService
    {
        private readonly HttpClient _httpClient;

        public LanguageManagementService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<List<Language>> GetAvailableLanguagesAsync()
        {
            try
            {
                var response = await _httpClient.GetFromJsonAsync<List<Language>>("/Languages/available");
                return response ?? new List<Language>();
            }
            catch
            {
                return new List<Language>();
            }
        }

        public async Task<List<Language>> GetAllLanguagesAsync()
        {
            try
            {
                var response = await _httpClient.GetFromJsonAsync<List<Language>>("/Language/all");
                return response ?? new List<Language>();
            }
            catch
            {
                return new List<Language>();
            }
        }

        public async Task<Language?> GetLanguageByKeyAsync(string key)
        {
            try
            {
                var response = await _httpClient.GetFromJsonAsync<Language>($"/Language/{key}");
                return response;
            }
            catch
            {
                return null;
            }
        }

        public async Task<bool> IsLanguageAvailableAsync(string key)
        {
            try
            {
                var response = await _httpClient.GetFromJsonAsync<bool>($"/Language/{key}/available");
                return response;
            }
            catch
            {
                return false;
            }
        }

        public async Task<Language> CreateLanguageAsync(CreateLanguageRequest request)
        {
            var response = await _httpClient.PostAsJsonAsync("/Language/CreateLanguage", request);
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadFromJsonAsync<Language>() ?? throw new InvalidOperationException("Failed to create language");
        }

        public async Task<Language> PublishLanguageAsync(string key)
        {
            var response = await _httpClient.PutAsync($"/Language/{key}/publish", null);
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadFromJsonAsync<Language>() ?? throw new InvalidOperationException("Failed to publish language");
        }

        public async Task<Language> HideLanguageAsync(string key)
        {
            var response = await _httpClient.PutAsync($"/Language/{key}/hide", null);
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadFromJsonAsync<Language>() ?? throw new InvalidOperationException("Failed to hide language");
        }
    }
}

public class CreateLanguageRequest
{
    public string Key { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public bool IsPublic { get; set; } = false;
}
