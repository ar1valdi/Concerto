using Microsoft.JSInterop;

namespace Concerto.Client.Services
{
    public interface IOverridableLanguageService : ILanguageService
    {
        public Task<Dictionary<string, string>> OverrideTranslation(Language lang, string key, string value);
    }

    public class LanguageServiceOverridable : ILanguageService, IOverridableLanguageService
    {
        private Dictionary<Language, Dictionary<string, string>> overridedTranslations;
        private Dictionary<Language, Dictionary<string, string>> translations;
        private IJSRuntime jsRuntime;
        private ILanguageService languageService;
        private Language lang = Language.PL;

        public LanguageServiceOverridable(
            IJSRuntime _jSRuntime,
            ILanguageService _languageService
            )
        {
            jsRuntime = _jSRuntime;
            overridedTranslations = new Dictionary<Language, Dictionary<string, string>>();
            translations = new Dictionary<Language, Dictionary<string, string>>();
            languageService = _languageService;
        }

        public async Task ChangeLanguage(Language lang)
        {
            this.lang = lang;

            if (translations.GetValueOrDefault(lang) is not null)
            {
                translations[lang] = await FetchTranslationsAsync(lang);
            }
        }

        public async Task<Dictionary<string, string>> OverrideTranslation(Language lang, string key, string value)
        {
            if (overridedTranslations.GetValueOrDefault(lang) is null)
            {
                overridedTranslations[lang] = new Dictionary<string, string>();
            }

            overridedTranslations[lang][key] = value;
            return await FetchTranslationsAsync(lang);
        }

        public async Task<Dictionary<string, string>> FetchTranslationsAsync(Language lang)
        {
            return await languageService.FetchTranslationsAsync(lang);
        }

        public string T(string key)
        {
            var val = overridedTranslations.GetValueOrDefault(lang)?[key];
            if (val is not null)
            {
                return val;
            }
            return languageService.T(key);
        }
    }
}
