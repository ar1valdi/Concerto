using Blazored.LocalStorage;
using Microsoft.JSInterop;

namespace Concerto.Client.Services
{
    public interface IOverridableLanguageService : ILanguageService
    {
        public void OverrideTranslation(string lang, string key, string value);
    }

    public class LanguageServiceOverridable : ILanguageService, IOverridableLanguageService
    {
        private Dictionary<string, Dictionary<string, string>> overridedTranslations;
        private Dictionary<string, Dictionary<string, string>> translations;
        private IJSRuntime jsRuntime;
        private ILanguageService languageService;
        private string lang = "en";
        private const string TranslationsKeyPrefix = "lang_translations_";
        private ILocalStorageService localStorage;

        public LanguageServiceOverridable(
            IJSRuntime _jSRuntime,
            ILanguageService _languageService,
            ILocalStorageService _localStorage
            )
        {
            jsRuntime = _jSRuntime;
            overridedTranslations = new Dictionary<string, Dictionary<string, string>>();
            translations = new Dictionary<string, Dictionary<string, string>>();
            languageService = _languageService;
            localStorage = _localStorage;
        }

        public async Task ChangeLanguage(string lang)
        {
            this.lang = lang;

            if (translations.GetValueOrDefault(lang) is null)
            {
                translations[lang] = new Dictionary<string, string>();
            }

            await FetchTranslationsAsync(lang);
            translations[lang] = await localStorage.GetItemAsync<Dictionary<string, string>>($"{TranslationsKeyPrefix}{lang}");
        }

        public void OverrideTranslation(string lang, string key, string value)
        {
            if (overridedTranslations.GetValueOrDefault(lang) is null)
            {
                overridedTranslations[lang] = new Dictionary<string, string>();
            }

            overridedTranslations[lang][key] = value;
        }

        public async Task FetchTranslationsAsync(string lang)
        {
            await languageService.FetchTranslationsAsync(lang);
        }

        public string T(string view, string key)
        {
            var val = overridedTranslations.GetValueOrDefault(lang)?[key];
            if (val is not null)
            {
                return val;
            }
            return languageService.T(view, key);
        }

        public string GetCurrentLanguage()
        {
            return lang;
        }

        public Task InitializeAsync()
        {
            return Task.CompletedTask;
        }
    }
}
