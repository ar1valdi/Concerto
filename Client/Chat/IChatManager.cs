namespace Concerto.Client.Chat
{
    public interface IChatManager
    {
        Task<List<Dto.User>> GetContactsAsync();
    }
}
