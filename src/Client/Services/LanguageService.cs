using Microsoft.JSInterop;
using System.Net.Http.Json;

namespace Concerto.Client.Services
{
    public interface ILanguageService
    {
        public string T(string key);
        public Task ChangeLanguage(Language lang);
    }

    public enum Language
    {
        PL,
        EN
    }

    public static partial class Extensions
    {
        public static string Stringify(this Language lang)
        {
            return lang switch
            {
                Language.EN => "en",
                Language.PL => "pl",
                _ => throw new Exception("Unknown language")
            };
        }
    }

    public class LanguageService : ILanguageService
    {
        private Dictionary<string, string> translations;
        private readonly HttpClient httpClient;
        private IJSRuntime jsRuntime;

        public LanguageService(HttpClient _httpClient, IJSRuntime _jSRuntime)
        {
            jsRuntime = _jSRuntime;
            httpClient = _httpClient;
            translations = new Dictionary<string, string>();
        }

        private async Task LoadTranslationsAsync(Language lang)
        {
            var uri = $"lang/{lang.Stringify()}.json";
            var response = await httpClient.GetFromJsonAsync<Dictionary<string, string>>(uri);

            if (response is null)
            {
                throw new Exception($"Couldn't load language {lang.Stringify()}");
            }

            translations = response;
        }

        public async Task ChangeLanguage(Language lang)
        {
            await LoadTranslationsAsync(lang);
        }

        public string T(string key)
        {
            var val = translations.GetValueOrDefault(key);
            return val ?? key;
        }
    }
}
