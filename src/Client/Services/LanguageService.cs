using Blazored.LocalStorage;
using Concerto.Shared.Models.Dto;
using System.Net.Http.Json;

namespace Concerto.Client.Services
{
    public interface ILanguageService
    {
        public string T(string view, string key);
        public Task ChangeLanguage(string lang);
        public string GetCurrentLanguage();
        public Task FetchTranslationsAsync(string lang);
        public Task InitializeAsync();
    }

    public class LanguageService : ILanguageService
    {
        private const string LastUpdateKeyPrefix = "lang_lastUpdate_";
        private const string TranslationsKeyPrefix = "lang_translations_";
        private const string CurrentLanguageKey = "curr_language";
        private const string DefaultLanguage = "en";


        private Dictionary<string, string> translations;
        private readonly HttpClient httpClient;
        private ILocalStorageService localStorage;
        private string currentLanguage;


        public LanguageService(HttpClient _httpClient, ILocalStorageService _localStorage)
        {
            localStorage = _localStorage;
            httpClient = _httpClient;
            translations = new Dictionary<string, string>();
            currentLanguage = DefaultLanguage;
        }

        public string GetCurrentLanguage()
        {
            return currentLanguage;
        }

        public async Task InitializeAsync()
        {
            if (await localStorage.ContainKeyAsync(CurrentLanguageKey))
            {
                currentLanguage = await localStorage.GetItemAsync<string>(CurrentLanguageKey);
            }
        }

        public async Task FetchTranslationsAsync(string lang)
        {
            var lastUpdateParam = "";

            if (await localStorage.ContainKeyAsync($"{LastUpdateKeyPrefix}{lang}"))
            {
                var lastUpdatedAt = await localStorage.GetItemAsync<DateTime>($"{LastUpdateKeyPrefix}{lang}");
                lastUpdateParam = $"&lastUpdate={lastUpdatedAt:yyyy-MM-ddTHH:mm:ss.fffZ}";
            }

            var uri = $"/Tranlsations/GetTranslationsDiff?lang={lang}{lastUpdateParam}";
            var response = await httpClient.GetFromJsonAsync<List<Translation>>(uri);

            if (response is null)
            {
                throw new Exception($"Couldn't load language {lang}");
            }
         
            var now = DateTime.UtcNow;   
            await localStorage.SetItemAsync($"{LastUpdateKeyPrefix}{lang}", now);
            await localStorage.SetItemAsync($"{TranslationsKeyPrefix}{lang}", response.ToDictionary(t => $"{t.View}:{t.Key}", t => t.Value));
        }

        public async Task ChangeLanguage(string lang)
        {
            await FetchTranslationsAsync(lang);
            currentLanguage = lang;
            await localStorage.SetItemAsync(CurrentLanguageKey, lang);
            translations = await localStorage.GetItemAsync<Dictionary<string, string>>($"{TranslationsKeyPrefix}{lang}");
        }

        public string T(string view, string key)
        {
            var val = translations.GetValueOrDefault($"{view}:{key}");
            return val ?? key;
        }
    }
}
