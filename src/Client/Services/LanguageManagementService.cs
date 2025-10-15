using Concerto.Shared.Models.Dto;

namespace Concerto.Client.Services
{
    public interface ILanguageManagementService
    {
        Task<List<Language>> GetAvailableLanguagesAsync();
        Task<List<Language>> GetAllLanguagesAsync();
        Task<Language?> GetLanguageByKeyAsync(string key);
        Task<Language> CreateLanguageAsync(CreateLanguageRequest request);
        Task<Language> PublishLanguageAsync(string key);
        Task<Language> HideLanguageAsync(string key);
        Task DeleteLanguageAsync(string key);
    }

    public class LanguageManagementService : ILanguageManagementService
    {
        private readonly ILanguagesClient _languagesClient;
        private readonly ILanguagesClient _languagesClientUnauthroized;

        public LanguageManagementService(ILanguagesClient languagesClient, ILanguagesClient languagesClientUnauthroized )
        {
            _languagesClient = languagesClient;
            _languagesClientUnauthroized = languagesClientUnauthroized;
        }

        public async Task<List<Language>> GetAvailableLanguagesAsync()
        {
            try
            {
                var response = await _languagesClientUnauthroized.AvailableAsync();
                return response?.ToList() ?? new List<Language>();
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
                var response = await _languagesClient.AllAsync();
                return response?.ToList() ?? new List<Language>();
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
                var response = await _languagesClient.LanguagesGetAsync(key);
                return response;
            }
            catch
            {
                return null;
            }
        }

        public async Task<Language> CreateLanguageAsync(CreateLanguageRequest request)
        {
            return await _languagesClient.LanguagesPostAsync(request);
        }

        public async Task<Language> PublishLanguageAsync(string key)
        {
            return await _languagesClient.PublishAsync(key);
        }

        public async Task<Language> HideLanguageAsync(string key)
        {
            return await _languagesClient.HideAsync(key);
        }

        public async Task DeleteLanguageAsync(string key)
        {
            await _languagesClient.LanguagesDeleteAsync(key);
        }
    }
}

public class CreateLanguageRequest
{
    public string Key { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public bool IsPublic { get; set; } = false;
}
