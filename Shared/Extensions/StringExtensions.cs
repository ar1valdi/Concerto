namespace Concerto.Shared.Extensions;
public static class StringExtensions
{
    public static Guid ToGuid(this string str)
    {
        return Guid.Parse(str);
    }

    public static long ToUserId(this string str)
    {
        return long.Parse(str);
    }
}
