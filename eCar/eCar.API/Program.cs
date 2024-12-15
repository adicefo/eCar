using eCar.Services.Database;
using System.Data.Entity;
using Microsoft.EntityFrameworkCore;
using eCar.Services.Interfaces;
using eCar.Services.Services;
using Mapster;
using FluentAssertions.Common;
using Newtonsoft.Json;

internal class Program
{
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.
        builder.Services.AddTransient<IRouteService, RouteService>();
        builder.Services.AddTransient<IUserService, UserService>();
        builder.Services.AddTransient<IVehicleService, VehicleService>();

        builder.Services.AddControllers();
        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();


        //we use sqlServer as DBMS
        var connectionString = builder.Configuration.GetConnectionString("eCarConnection");
        builder.Services.AddDbContext<ECarDbContext>(options =>
        options.UseSqlServer(connectionString));

        //for Mapster
        builder.Services.AddMapster();
        TypeAdapterConfig.GlobalSettings.Default.MapToConstructor(true);

        builder.Services.AddControllers().AddNewtonsoftJson();
        builder.Services.AddControllers()
        .AddNewtonsoftJson(options =>
                         options.SerializerSettings.ReferenceLoopHandling =
                         Newtonsoft.Json.ReferenceLoopHandling.Ignore);

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        if (app.Environment.IsDevelopment())
        {
            app.UseSwagger();
            app.UseSwaggerUI();
        }

        app.UseHttpsRedirection();

        app.UseAuthorization();

        app.MapControllers();

        app.Run();
    }
}