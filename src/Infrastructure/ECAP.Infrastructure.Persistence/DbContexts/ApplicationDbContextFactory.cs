using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace ECAP.Infrastructure.Persistence.DbContexts;

/// <summary>
/// Design-time factory for creating ApplicationDbContext instances during migrations.
/// </summary>
public class ApplicationDbContextFactory : IDesignTimeDbContextFactory<ApplicationDbContext>
{
    public ApplicationDbContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();

        // Use a default connection string for migrations
        // This will be replaced at runtime with the actual connection string
        optionsBuilder.UseSqlServer("Server=(localdb)\\mssqllocaldb;Database=ECAP;Trusted_Connection=True;MultipleActiveResultSets=true");

        return new ApplicationDbContext(optionsBuilder.Options);
    }
}
