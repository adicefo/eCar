using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace eCar.Services.Database;

public partial class ECarDbContext : DbContext
{
    public ECarDbContext()
    {
    }

    public ECarDbContext(DbContextOptions<ECarDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Admin> Admins { get; set; }

    public virtual DbSet<Client> Clients { get; set; }

    public virtual DbSet<ClientNotification> ClientNotifications { get; set; }

    public virtual DbSet<CompanyDetail> CompanyDetails { get; set; }

    public virtual DbSet<CompanyPrice> CompanyPrices { get; set; }

    public virtual DbSet<Driver> Drivers { get; set; }

    public virtual DbSet<DriverNotification> DriverNotifications { get; set; }

    public virtual DbSet<DriverVehicle> DriverVehicles { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<Rent> Rents { get; set; }

    public virtual DbSet<Request> Requests { get; set; }

    public virtual DbSet<Review> Reviews { get; set; }

    public virtual DbSet<Route> Routes { get; set; }

    public virtual DbSet<Statistic> Statistics { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<Vehicle> Vehicles { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=localhost; Initial Catalog=eCarDB; TrustServerCertificate=True; Trusted_Connection=True; MultipleActiveResultSets=true");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Admin>(entity =>
        {
            entity.ToTable("Admin");

            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.User).WithMany(p => p.Admins)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Admin_User");
        });

        modelBuilder.Entity<Client>(entity =>
        {
            entity.ToTable("Client");

            entity.Property(e => e.Image).HasColumnType("image");

            entity.HasOne(d => d.User).WithMany(p => p.Clients)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Client_User");
        });

        modelBuilder.Entity<ClientNotification>(entity =>
        {
            entity.ToTable("ClientNotification");

            entity.Property(e => e.Id).ValueGeneratedOnAdd();

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.ClientNotification)
                .HasForeignKey<ClientNotification>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ClientNotification_Client");

            entity.HasOne(d => d.Id1).WithOne(p => p.ClientNotification)
                .HasForeignKey<ClientNotification>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ClientNotification_Notification");
        });

        modelBuilder.Entity<CompanyDetail>(entity =>
        {
            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.CompanyName).HasMaxLength(30);

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.CompanyDetail)
                .HasForeignKey<CompanyDetail>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CompanyDetails_CompanyPrices");
        });

        modelBuilder.Entity<CompanyPrice>(entity =>
        {
            entity.Property(e => e.PricePerKilometar).HasColumnType("decimal(18, 0)");
        });

        modelBuilder.Entity<Driver>(entity =>
        {
            entity.ToTable("Driver");

            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.UserId).HasColumnName("UserID");

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.Driver)
                .HasForeignKey<Driver>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Driver_User");
        });

        modelBuilder.Entity<DriverNotification>(entity =>
        {
            entity.ToTable("DriverNotification");

            entity.Property(e => e.Id).ValueGeneratedOnAdd();

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.DriverNotification)
                .HasForeignKey<DriverNotification>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DriverNotification_Driver");

            entity.HasOne(d => d.Id1).WithOne(p => p.DriverNotification)
                .HasForeignKey<DriverNotification>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DriverNotification_Notification");
        });

        modelBuilder.Entity<DriverVehicle>(entity =>
        {
            entity.ToTable("DriverVehicle");

            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.VehicleId)
                .HasMaxLength(10)
                .IsFixedLength();

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.DriverVehicle)
                .HasForeignKey<DriverVehicle>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DriverVehicle_Driver");

            entity.HasOne(d => d.Id1).WithOne(p => p.DriverVehicle)
                .HasForeignKey<DriverVehicle>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DriverVehicle_Vehicle");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.ToTable("Notification");

            entity.Property(e => e.AddingDate).HasColumnType("datetime");
            entity.Property(e => e.Content)
                .HasMaxLength(500)
                .HasColumnName("Content_");
            entity.Property(e => e.Heading).HasMaxLength(50);
            entity.Property(e => e.Image).HasColumnType("image");
            entity.Property(e => e.Status).HasMaxLength(15);
        });

        modelBuilder.Entity<Rent>(entity =>
        {
            entity.ToTable("Rent");

            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.EndingDate).HasColumnType("datetime");
            entity.Property(e => e.FullPrice).HasColumnType("decimal(18, 0)");
            entity.Property(e => e.RentingDate).HasColumnType("datetime");
            entity.Property(e => e.Status).HasMaxLength(15);

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.Rent)
                .HasForeignKey<Rent>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Rent_Client");

            entity.HasOne(d => d.Id1).WithOne(p => p.Rent)
                .HasForeignKey<Rent>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Rent_Vehicle");
        });

        modelBuilder.Entity<Request>(entity =>
        {
            entity.ToTable("Request");

            entity.Property(e => e.Id).ValueGeneratedOnAdd();

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.Request)
                .HasForeignKey<Request>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Request_Driver");

            entity.HasOne(d => d.Id1).WithOne(p => p.Request)
                .HasForeignKey<Request>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Request_Route");
        });

        modelBuilder.Entity<Review>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK_Recension");

            entity.ToTable("Review");

            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.Description).HasMaxLength(100);

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.Review)
                .HasForeignKey<Review>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Recension_Client");

            entity.HasOne(d => d.Id1).WithOne(p => p.Review)
                .HasForeignKey<Review>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Recension_Driver");

            entity.HasOne(d => d.Id2).WithOne(p => p.Review)
                .HasForeignKey<Review>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Recension_Route");
        });

        modelBuilder.Entity<Route>(entity =>
        {
            entity.ToTable("Route");

            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.CompanyPricesId).HasColumnName("CompanyPricesID");
            entity.Property(e => e.DriverId).HasColumnName("DriverID");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.FullPrice).HasColumnType("decimal(18, 0)");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.Status).HasMaxLength(10);

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.Route)
                .HasForeignKey<Route>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Route_Client");

            entity.HasOne(d => d.Id1).WithOne(p => p.Route)
                .HasForeignKey<Route>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Route_CompanyPrices");

            entity.HasOne(d => d.Id2).WithOne(p => p.Route)
                .HasForeignKey<Route>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Route_Driver");
        });

        modelBuilder.Entity<Statistic>(entity =>
        {
            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.BeginningOfWork).HasColumnType("datetime");
            entity.Property(e => e.EndOfWork).HasColumnType("datetime");
            entity.Property(e => e.PriceAmount).HasColumnType("money");

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.Statistic)
                .HasForeignKey<Statistic>(d => d.Id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Statistics_Driver");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.ToTable("User");

            entity.Property(e => e.Email).HasMaxLength(50);
            entity.Property(e => e.Gender)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.Name).HasMaxLength(15);
            entity.Property(e => e.Password).HasMaxLength(30);
            entity.Property(e => e.RegistrationDate).HasColumnType("datetime");
            entity.Property(e => e.Surname).HasMaxLength(20);
            entity.Property(e => e.TelephoneNumber).HasMaxLength(30);
            entity.Property(e => e.UserName).HasMaxLength(20);
        });

        modelBuilder.Entity<Vehicle>(entity =>
        {
            entity.ToTable("Vehicle");

            entity.Property(e => e.Image).HasColumnType("image");
            entity.Property(e => e.Name).HasMaxLength(30);
            entity.Property(e => e.Price).HasColumnType("decimal(18, 0)");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
