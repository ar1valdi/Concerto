using Concerto.Client.Services;

namespace Concerto.Client.Services;

public interface IStorageService : IStorageClient { }

public class StorageService : StorageClient, IStorageService
{
	public StorageService(HttpClient httpClient) : base(httpClient) { }
}

