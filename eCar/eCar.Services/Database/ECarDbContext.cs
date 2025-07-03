using System;
using System.Collections.Generic;
using Azure;
using eCar.Services.Database.Seed;
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
    public virtual DbSet<Transakcija250602025> Transakcija250602025e { get; set; }
    public virtual DbSet<KategorijaTransakcije250602025> KategorijaTransakcije250602025e { get; set; }
    public virtual DbSet<FinansijskiLimit250602025> FinansijskiLimit250602025e { get; set; }
    public virtual DbSet<TranskacijaLog25062025> TranskacijaLog25062025s { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Name=ConnectionStrings:eCarConnection", x => x.UseNetTopologySuite());

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Admin>(entity =>
        {
            entity.ToTable("Admin");

            entity.HasOne(d => d.User).WithMany(p => p.Admins)
                .HasForeignKey(d => d.UserID)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Admin_User");
        });

        modelBuilder.Entity<Client>(entity =>
        {
            entity.ToTable("Client");

            entity.Property(e => e.Image).HasColumnType("image");

            entity.HasOne(d => d.User).WithMany(p => p.Clients)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_Client_User");
        });

        modelBuilder.Entity<ClientNotification>(entity =>
        {
            entity.ToTable("ClientNotification");

            entity.HasOne(d => d.Client).WithMany(p => p.ClientNotifications)
                .HasForeignKey(d => d.ClientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ClientNotification_Client");

            entity.HasOne(d => d.Notification).WithMany(p => p.ClientNotifications)
                .HasForeignKey(d => d.NotificationId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ClientNotification_Notification");
        });

        modelBuilder.Entity<CompanyDetail>(entity =>
        {
            entity.Property(e => e.CompanyName).HasMaxLength(30);

            entity.HasOne(d => d.CompanyPrices).WithMany(p => p.CompanyDetails)
                .HasForeignKey(d => d.CompanyPricesId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CompanyDetails_CompanyPrices");
        });

        modelBuilder.Entity<CompanyPrice>(entity =>
        {
            entity.Property(e => e.PricePerKilometar).HasColumnType("money");
            entity.Property(e => e.AddingDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<Driver>(entity =>
        {
            entity.ToTable("Driver");

            entity.HasOne(d => d.User).WithMany(p => p.Drivers)
                .HasForeignKey(d => d.UserID)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_Driver_User");
        });

        modelBuilder.Entity<DriverNotification>(entity =>
        {
            entity.ToTable("DriverNotification");

            entity.HasOne(d => d.Driver).WithMany(p => p.DriverNotifications)
                .HasForeignKey(d => d.DriverId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DriverNotification_Driver");

            entity.HasOne(d => d.Notifiaction).WithMany(p => p.DriverNotifications)
                .HasForeignKey(d => d.NotifiactionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DriverNotification_Notification");
        });

        modelBuilder.Entity<DriverVehicle>(entity =>
        {
            entity.ToTable("DriverVehicle");

            entity.Property(e => e.DatePickUp).HasColumnType("datetime");
            entity.Property(e => e.DateDropOff).HasColumnType("datetime");

            entity.HasOne(d => d.Driver).WithMany(p => p.DriverVehicles)
                .HasForeignKey(d => d.DriverId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DriverVehicle_Driver");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.DriverVehicles)
                .HasForeignKey(d => d.VehicleId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_DriverVehicle_Vehicle");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.ToTable("Notification");

            entity.Property(e => e.AddingDate).HasColumnType("datetime");
            entity.Property(e => e.Content_).HasMaxLength(500);
            entity.Property(e => e.Heading).HasMaxLength(50);
            entity.Property(e => e.Image).HasColumnType("image");
            entity.Property(e => e.Status).HasMaxLength(15);
        });

        modelBuilder.Entity<Rent>(entity =>
        {
            entity.ToTable("Rent");

            entity.Property(e => e.EndingDate).HasColumnType("datetime");
            entity.Property(e => e.FullPrice).HasColumnType("money");
            entity.Property(e => e.Paid).HasColumnType("bit");
            entity.Property(e => e.RentingDate).HasColumnType("datetime");
            entity.Property(e => e.Status).HasMaxLength(15);

            entity.HasOne(d => d.Client).WithMany(p => p.Rents)
                .HasForeignKey(d => d.ClientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Rent_Client");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.Rents)
                .HasForeignKey(d => d.VehicleId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_Rent_Vehicle");
        });

        modelBuilder.Entity<Request>(entity =>
        {
            entity.ToTable("Request");

            entity.HasOne(d => d.Driver).WithMany(p => p.Requests)
                .HasForeignKey(d => d.DriverId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Request_Driver");

            entity.HasOne(d => d.Route).WithMany(p => p.Requests)
                .HasForeignKey(d => d.RouteId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_Request_Route");
        });

        modelBuilder.Entity<Review>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK_Recension");

            entity.ToTable("Review");

            entity.Property(e => e.Description).HasMaxLength(100);
            entity.Property(e => e.AddedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Reviewed).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.ReviewedId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Recension_Driver");

            entity.HasOne(d => d.Reviews).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.ReviewsId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Recension_Client");

            entity.HasOne(d => d.Route).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.RouteId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_Recension_Route");
        });

        modelBuilder.Entity<Route>(entity =>
        {
            entity.ToTable("Route");

            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.FullPrice).HasColumnType("money");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.Status).HasMaxLength(10);
            entity.Property(e => e.Paid).HasColumnType("bit");

            entity.HasOne(d => d.Client).WithMany(p => p.Routes)
                .HasForeignKey(d => d.ClientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Route_Client");

            entity.HasOne(d => d.CompanyPrices).WithMany(p => p.Routes)
                .HasForeignKey(d => d.CompanyPricesID)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_Route_CompanyPrices");

            entity.HasOne(d => d.Driver).WithMany(p => p.Routes)
                .HasForeignKey(d => d.DriverID)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Route_Driver");
        });

        modelBuilder.Entity<Statistic>(entity =>
        {
            entity.Property(e => e.BeginningOfWork).HasColumnType("datetime");
            entity.Property(e => e.EndOfWork).HasColumnType("datetime");
            entity.Property(e => e.PriceAmount).HasColumnType("money");

            entity.HasOne(d => d.Driver).WithMany(p => p.Statistics)
                .HasForeignKey(d => d.DriverId)
                .OnDelete(DeleteBehavior.Cascade)
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
            entity.Property(e => e.PasswordHash).HasMaxLength(1000);
            entity.Property(e => e.PasswordSalt).HasMaxLength(1000);
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
            entity.Property(e => e.Price).HasColumnType("money");
        });
        modelBuilder.Entity<User>().SeedData();
        modelBuilder.Entity<Admin>().SeedData();
        modelBuilder.Entity<Client>().SeedData();
        modelBuilder.Entity<Driver>().SeedData();
        modelBuilder.Entity<CompanyPrice>().SeedData();
        modelBuilder.Entity<Vehicle>().SeedData();
        modelBuilder.Entity<Route>().SeedData();
        modelBuilder.Entity<Rent>().SeedData();
        modelBuilder.Entity<Notification>().SeedData();
        modelBuilder.Entity<Review>().SeedData();
        modelBuilder.Entity<Statistic>().SeedData();
        modelBuilder.Entity<DriverVehicle>().SeedData();
        modelBuilder.Entity<FinansijskiLimit250602025>().SeedData();
        modelBuilder.Entity<KategorijaTransakcije250602025>().SeedData();


        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
