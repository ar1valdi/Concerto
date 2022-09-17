using Concerto.Server.Data.DatabaseContext;
using Concerto.Server.Data.Models;
using Concerto.Server.Extensions;
using Microsoft.EntityFrameworkCore;

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

    public async Task<Dto.User?> GetUser(long userId)
    {
        User? user = await _context.Users.FindAsync(userId);
        if (user == null) return null;
        return user.ToDto();
    }

    public async Task<Dto.User?> GetUser(Guid subjectId)
    {
        return await _context.Users.Where(u => u.SubjectId == subjectId).Select(u => u.ToDto()).FirstOrDefaultAsync();
    }

    public async Task<IEnumerable<Dto.User>> GetUserContacts(long userId)
    {
        IEnumerable<Dto.User>? contacts = await _context.UserContacts.Where(uc => uc.UserId == userId).Include(uc => uc.Contact).Select(uc => uc.Contact.ToDto()).ToListAsync();
        contacts ??= Enumerable.Empty<Dto.User>();
        return contacts;
    }

    public async Task<IEnumerable<Dto.User>> SearchUsers(string usernamePart)
    {
        return await _context.Users.Where(u => u.Username.Contains(usernamePart)).Select(u => u.ToDto()).ToListAsync();
    }

}
