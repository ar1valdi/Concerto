namespace Concerto.Client.Chat;

public interface IChatManager
{
    public bool IsConnected { get; }
    public Task ConnectToChatAsync();
    public Task SendChatMessageAsync(Dto.ChatMessage message);

    public delegate void OnMessageReceivedCallback(Dto.ChatMessage message);
    public OnMessageReceivedCallback onMessageReceivedCallback { get; set; }
    
    public Dictionary<long, Dto.Conversation> Conversations { get; }
    public Dictionary<long, List<Dto.ChatMessage>> Messages { get; }

    public Task LoadChatMessagesAsync(long contactId);
    public Task LoadConversationsAsync();
    public void InvalidateCache();


}
