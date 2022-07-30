using Concerto.Server.Data;
using Concerto.Shared.Models;

namespace Concerto.Server.Services;

public class UserService
{
    private readonly ILogger<UserService> _logger;

    private readonly AppDataContext _context;
    public UserService(ILogger<UserService> logger, AppDataContext context)
    {
        _logger = logger;
        _context = context;
    }
    
    public async Task<User?> GetUser(long userId)
    {
        return await _context.Users.FindAsync(userId);
    }
    
}
