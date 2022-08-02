using Concerto.Server.Data.Entities;

namespace Concerto.Server.Extensions
{
    public static class DtoConversions
    {
        public static IEnumerable<Dto.User> ToDto(this ICollection<UserContact>? userContacts)
        {
            if (userContacts == null)
                return Enumerable.Empty<Dto.User>();
            return userContacts.Select(uc => new Dto.User
            {
                UserId = uc.Contact.UserId,
                Username = uc.Contact.Username,
                FirstName = uc.Contact.FirstName,
                LastName = uc.Contact.LastName
            });
        }

        public static Dto.User ToDto(this User user)
        {
            return new Dto.User
            {
                UserId = user.UserId,
                Username = user.Username,
                FirstName = user.FirstName,
                LastName = user.LastName
            };
        }
    }
}
