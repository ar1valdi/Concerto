$env:DB_STRING="Host=localhost;Port=5432;Database=ConcertoDb;username=admin;Password=admin"
dotnet ef database update 0
rm -R ./Migrations
dotnet ef migrations add Initial
dotnet ef database update