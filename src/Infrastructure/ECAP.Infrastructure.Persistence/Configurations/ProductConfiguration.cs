using ECAP.Domain.Entities.Products;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ECAP.Infrastructure.Persistence.Configurations;

/// <summary>
/// EF Core configuration for Product entity
/// </summary>
public sealed class ProductConfiguration : IEntityTypeConfiguration<Product>
{
    public void Configure(EntityTypeBuilder<Product> builder)
    {
        builder.ToTable("Products");

        builder.HasKey(p => p.Id);

        builder.Property(p => p.Id)
            .ValueGeneratedNever();

        // SKU Value Object
        builder.OwnsOne(p => p.Sku, sku =>
        {
            sku.Property(s => s.Value)
                .HasColumnName("Sku")
                .HasMaxLength(50)
                .IsRequired();

            sku.HasIndex(s => s.Value)
                .IsUnique();
        });

        builder.Property(p => p.Name)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(p => p.Description)
            .HasMaxLength(2000)
            .IsRequired();

        builder.Property(p => p.ShortDescription)
            .HasMaxLength(500);

        builder.Property(p => p.Price)
            .HasColumnType("decimal(18,2)")
            .IsRequired();

        builder.Property(p => p.Currency)
            .HasMaxLength(3)
            .IsRequired();

        builder.Property(p => p.Status)
            .HasConversion<string>()
            .HasMaxLength(20)
            .IsRequired();

        // Weight Value Object
        builder.OwnsOne(p => p.Weight, weight =>
        {
            weight.Property(w => w.Value)
                .HasColumnName("Weight")
                .HasColumnType("decimal(18,2)");

            weight.Property(w => w.Unit)
                .HasColumnName("WeightUnit")
                .HasMaxLength(10);
        });

        // Dimensions Value Object
        builder.OwnsOne(p => p.Dimensions, dimensions =>
        {
            dimensions.Property(d => d.Length)
                .HasColumnName("Length")
                .HasColumnType("decimal(18,2)");

            dimensions.Property(d => d.Width)
                .HasColumnName("Width")
                .HasColumnType("decimal(18,2)");

            dimensions.Property(d => d.Height)
                .HasColumnName("Height")
                .HasColumnType("decimal(18,2)");

            dimensions.Property(d => d.Unit)
                .HasColumnName("DimensionUnit")
                .HasMaxLength(10);
        });

        // SEO Fields
        builder.Property(p => p.MetaTitle)
            .HasMaxLength(100);

        builder.Property(p => p.MetaDescription)
            .HasMaxLength(300);

        builder.Property(p => p.MetaKeywords)
            .HasMaxLength(200);

        // Inventory Summary
        builder.Property(p => p.AvailableQuantity)
            .HasDefaultValue(0);

        builder.Property(p => p.ReservedQuantity)
            .HasDefaultValue(0);

        builder.Property(p => p.LowStockThreshold)
            .HasDefaultValue(10);

        // Audit Fields
        builder.Property(p => p.CreatedDate)
            .IsRequired();

        builder.Property(p => p.CreatedBy)
            .HasMaxLength(100);

        builder.Property(p => p.UpdatedDate);

        builder.Property(p => p.UpdatedBy)
            .HasMaxLength(100);

        builder.Property(p => p.IsDeleted)
            .IsRequired()
            .HasDefaultValue(false);

        // Relationships
        builder.HasOne(p => p.Brand)
            .WithMany()
            .HasForeignKey(p => p.BrandId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(p => p.Category)
            .WithMany()
            .HasForeignKey(p => p.CategoryId)
            .OnDelete(DeleteBehavior.Restrict);

        // Owned collection for Product Images
        builder.OwnsMany(p => p.Images, images =>
        {
            images.ToTable("ProductImages");

            images.WithOwner()
                .HasForeignKey("ProductId");

            images.HasKey("Id");

            // Ignore DomainEvents property from base Entity class
            images.Ignore(i => i.DomainEvents);

            images.Property(i => i.Url)
                .HasMaxLength(500)
                .IsRequired();

            images.Property(i => i.AltText)
                .HasMaxLength(200);

            images.Property(i => i.DisplayOrder)
                .HasDefaultValue(0);

            images.Property(i => i.IsMain)
                .HasDefaultValue(false);
        });

        // Query Filter for soft delete
        builder.HasQueryFilter(p => !p.IsDeleted);

        // Indexes
        builder.HasIndex(p => p.Name);
        builder.HasIndex(p => p.BrandId);
        builder.HasIndex(p => p.CategoryId);
        builder.HasIndex(p => p.Status);
        builder.HasIndex(p => p.CreatedDate);
    }
}
