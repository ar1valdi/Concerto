namespace Concerto.Client.Contacts;

public interface IContactsManager
{
    public List<Dto.User> Contacts { get; }
    public Task LoadContactsAsync();
    public Task<String> GetContactNameAsync(long contactId);

    public void InvalidateCache();
}
