using ECAP.Domain.Entities.Products;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ECAP.Infrastructure.Persistence.Configurations;

/// <summary>
/// EF Core configuration for Category entity
/// </summary>
public sealed class CategoryConfiguration : IEntityTypeConfiguration<Category>
{
    public void Configure(EntityTypeBuilder<Category> builder)
    {
        builder.ToTable("Categories");

        builder.HasKey(c => c.Id);

        builder.Property(c => c.Id)
            .ValueGeneratedNever();

        builder.Property(c => c.Name)
            .HasMaxLength(100)
            .IsRequired();

        builder.Property(c => c.Description)
            .HasMaxLength(500);

        builder.Property(c => c.ParentCategoryId);

        builder.Property(c => c.DisplayOrder)
            .HasDefaultValue(0);

        builder.Property(c => c.IsActive)
            .IsRequired()
            .HasDefaultValue(true);

        // Audit Fields
        builder.Property(c => c.CreatedDate)
            .IsRequired();

        builder.Property(c => c.CreatedBy)
            .HasMaxLength(100);

        builder.Property(c => c.UpdatedDate);

        builder.Property(c => c.UpdatedBy)
            .HasMaxLength(100);

        builder.Property(c => c.IsDeleted)
            .IsRequired()
            .HasDefaultValue(false);

        // Self-referencing relationship
        builder.HasOne<Category>()
            .WithMany()
            .HasForeignKey(c => c.ParentCategoryId)
            .OnDelete(DeleteBehavior.Restrict);

        // Query Filter for soft delete
        builder.HasQueryFilter(c => !c.IsDeleted);

        // Indexes
        builder.HasIndex(c => c.Name);
        builder.HasIndex(c => c.ParentCategoryId);
        builder.HasIndex(c => c.DisplayOrder);
        builder.HasIndex(c => c.IsActive);
    }
}
