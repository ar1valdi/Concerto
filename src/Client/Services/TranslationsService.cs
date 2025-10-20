using Blazored.LocalStorage;
using Concerto.Shared.Models.Dto;

namespace Concerto.Client.Services
{
    public interface ITranslationsService
    {
        public string T(string view, string key);
        public string T(string view, string key, params object[] args);
        public Task ChangeLanguage(string lang);
        public string GetCurrentLanguage();
        public Task FetchTranslationsFromLastUpdatedAsync(string lang);
        public Task InitializeAsync();
        public Task<List<Translation>> FetchFullTranslationsAsync();
        public Task<List<TranslationLocation>> FetchAllTranslationLocationsAsync();
        public Task UpdateTranslations(List<Translation> updatedTranslations);
    }

    public class TranslationsService : ITranslationsService
    {
        private const string LastUpdateKeyPrefix = "lang_lastUpdate_";
        private const string TranslationsKeyPrefix = "lang_translations_";
        private const string CurrentLanguageKey = "curr_language";
        private const string DefaultLanguage = "en";


        private Dictionary<string, string> translations;
        private readonly ITranlsationsClient translationsClient;
        private readonly ITranlsationsClient translationsClientUnauthroized;
        private ILocalStorageService localStorage;
        private string currentLanguage;


        public TranslationsService(
            ITranlsationsClient _translationsClient, 
            ITranlsationsClient _translationsClientUnauthroized, 
            ILocalStorageService _localStorage)
        {
            localStorage = _localStorage;
            translationsClient = _translationsClient;
            translationsClientUnauthroized = _translationsClientUnauthroized;
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
            await ChangeLanguage(currentLanguage);
        }

        public async Task<List<Translation>> FetchFullTranslationsAsync()
        {
            var response = await translationsClient.GetTranslationsFullAsync();
            if (response is null || response.Count == 0)
            {
                return new List<Translation>();
            }
            return response.ToList();
        }

        public async Task<List<TranslationLocation>> FetchAllTranslationLocationsAsync()
        {
            var response = await translationsClient.GetTranslationLocationsAsync();
            if (response is null || response.Count == 0)
            {
                return new List<TranslationLocation>();
            }
            return response.ToList();
        }

        public async Task FetchTranslationsFromLastUpdatedAsync(string lang)
        {
            DateTimeOffset? lastUpdate = null;
            if (await localStorage.ContainKeyAsync($"{LastUpdateKeyPrefix}{lang}"))
            {
                var lastUpdatedAt = await localStorage.GetItemAsync<DateTime>($"{LastUpdateKeyPrefix}{lang}");
                lastUpdate = new DateTimeOffset(DateTime.SpecifyKind(lastUpdatedAt, DateTimeKind.Utc));
            }

            var response = await translationsClientUnauthroized.GetTranslationsDiffAsync(lang, lastUpdate);
            
            var now = DateTime.UtcNow;
            await localStorage.SetItemAsync($"{LastUpdateKeyPrefix}{lang}", now);

            if (response is null || response.Count == 0)
            {
                return;
            }

            var currTranslations = await localStorage.ContainKeyAsync($"{TranslationsKeyPrefix}{lang}")
                ? await localStorage.GetItemAsync<Dictionary<string, string>>($"{TranslationsKeyPrefix}{lang}")
                : new Dictionary<string, string>();
            var newTranslations = response.ToDictionary(t => $"{t.View}:{t.Key}", t => t.Value);

            if (currTranslations != null)
            {
                foreach (var t in currTranslations)
                {
                    newTranslations.TryAdd(t.Key, t.Value);
                }
            }

            await localStorage.SetItemAsync($"{TranslationsKeyPrefix}{lang}", newTranslations);
        }

        public async Task ChangeLanguage(string lang)
        {
            await FetchTranslationsFromLastUpdatedAsync(lang);
            currentLanguage = lang;
            await localStorage.SetItemAsync(CurrentLanguageKey, lang);
            translations = await localStorage.GetItemAsync<Dictionary<string, string>>($"{TranslationsKeyPrefix}{lang}");
        }

        public string T(string view, string key)
        {
            var val = translations.GetValueOrDefault($"{view}:{key}");
            return val ?? key;
        }

        public string T(string view, string key, params object[] args)
        {
            var val = translations.GetValueOrDefault($"{view}:{key}");
            if (val is null) return key;
            return string.Format(val, args);
        }

        public async Task UpdateTranslations(List<Translation> updatedTranslations)
        {
            await translationsClient.UpdateTranslationsRangeAsync(updatedTranslations);
        }
    }
}
