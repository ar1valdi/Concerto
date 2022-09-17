using Concerto.Client.Contacts;
using Concerto.Client.Pages;
using Concerto.Shared.Models.Dto;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.WebAssembly.Authentication;
using Microsoft.AspNetCore.SignalR.Client;
using MudBlazor;
using System.Net.Http.Json;
using System.Security.AccessControl;
using static System.Net.WebRequestMethods;

namespace Concerto.Client.Chat;

public class CachedChatManager : IChatManager
{
    private readonly AuthenticationStateProvider _authenticationStateProvider;
    private readonly NavigationManager _navigationManager;
    private readonly IAccessTokenProvider _accessTokenProvider;
    private readonly HttpClient _http;
    private readonly IContactsManager _contactsManager;
    private readonly ISnackbar _snackbar;

    public IChatManager.OnMessageReceivedCallback onMessageReceivedCallback { get; set; }

    private HubConnection ChatHubConnection { get; set; }
    public bool IsConnected
    {
        get
        {
            return ChatHubConnection?.State == HubConnectionState.Connected;
        }
    }
    
    private SemaphoreSlim semaphore = new SemaphoreSlim(1, 1);
    private Dictionary<long, List<Dto.ChatMessage>> messagesCache = new Dictionary<long, List<Dto.ChatMessage>>();
    public Dictionary<long, List<Dto.ChatMessage>> Messages
    {
        get
        {
            return messagesCache;
        }
    }

    public CachedChatManager(AuthenticationStateProvider authenticationStateProvider, NavigationManager navigationManager, HttpClient http, IContactsManager contactsManager, IAccessTokenProvider accessTokenProvider, ISnackbar snackbar)
    {
        _authenticationStateProvider = authenticationStateProvider;
        _navigationManager = navigationManager;
        _http = http;
        this._contactsManager = contactsManager;
        _accessTokenProvider = accessTokenProvider;
        _snackbar = snackbar;

        ChatHubConnection = new HubConnectionBuilder()
                .WithUrl(_navigationManager.ToAbsoluteUri("/chat"), options =>
                {
                    options.AccessTokenProvider = async () =>
                    {
                        var accessTokenResult = await _accessTokenProvider.RequestAccessToken();
                        accessTokenResult.TryGetToken(out var accessToken);
                        return accessToken.Value;
                    };
                })
                .Build();

        ChatHubConnection.On("ReceiveMessage", async (Dto.ChatMessage message) =>
        {
            messagesCache[message.SenderId].Insert(0, message);
            string name = await _contactsManager.GetContactNameAsync(message.SenderId);
            if (!_navigationManager.Uri.Contains("chat"))
            {
                _snackbar.Add($"New message from {name}", Severity.Info);
            }
            else if (onMessageReceivedCallback != null)
            {
                onMessageReceivedCallback(message);
            }
        });

    }

    public async Task ConnectToChatAsync()
    {
        AuthenticationState authenticationState = await _authenticationStateProvider.GetAuthenticationStateAsync();
        if (authenticationState.User.Identity?.IsAuthenticated == true)
        {
            await ChatHubConnection.StartAsync();
        }
    }

    public async Task LoadChatMessagesAsync(long contactId)
    {
        await semaphore.WaitAsync();
        if (!messagesCache.ContainsKey(contactId))
        {
            var messagesResponse = await _http.GetFromJsonAsync<Dto.ChatMessage[]>($"Chat/GetCurrentUserLastMessages?recipientId={contactId}");
            var messages = messagesResponse?.ToList() ?? new List<Dto.ChatMessage>();
            messages.Sort((x, y) => DateTime.Compare(y.SendTimestamp, x.SendTimestamp));
            messagesCache.Add(contactId, messages);
        }
        semaphore.Release();
    }

    public async Task SendChatMessageAsync(Dto.ChatMessage message)
    {
        var list = messagesCache[message.RecipientId];
        list.Insert(0, message);
        await ChatHubConnection.SendAsync("SendMessage", message.RecipientId, message.Content);
    }

    public void InvalidateCache()
    {
        messagesCache.Clear();
    }

    public async ValueTask DisposeAsync()
    {
        if (ChatHubConnection is not null)
        {
            await ChatHubConnection.DisposeAsync();
        }
    }
}
