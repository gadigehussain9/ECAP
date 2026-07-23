using ECAP.Domain.Entities.Products;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ECAP.Infrastructure.Persistence.Configurations;

/// <summary>
/// EF Core configuration for Brand entity
/// </summary>
public sealed class BrandConfiguration : IEntityTypeConfiguration<Brand>
{
    public void Configure(EntityTypeBuilder<Brand> builder)
    {
        builder.ToTable("Brands");

        builder.HasKey(b => b.Id);

        builder.Property(b => b.Id)
            .ValueGeneratedNever();

        builder.Property(b => b.Name)
            .HasMaxLength(100)
            .IsRequired();

        builder.Property(b => b.Description)
            .HasMaxLength(500);

        builder.Property(b => b.LogoUrl)
            .HasMaxLength(500);

        builder.Property(b => b.IsActive)
            .IsRequired()
            .HasDefaultValue(true);

        // Audit Fields
        builder.Property(b => b.CreatedDate)
            .IsRequired();

        builder.Property(b => b.CreatedBy)
            .HasMaxLength(100);

        builder.Property(b => b.UpdatedDate);

        builder.Property(b => b.UpdatedBy)
            .HasMaxLength(100);

        builder.Property(b => b.IsDeleted)
            .IsRequired()
            .HasDefaultValue(false);

        // Query Filter for soft delete
        builder.HasQueryFilter(b => !b.IsDeleted);

        // Indexes
        builder.HasIndex(b => b.Name)
            .IsUnique();
        builder.HasIndex(b => b.IsActive);
    }
}
