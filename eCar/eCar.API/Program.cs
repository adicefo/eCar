using eCar.Services.Database;
using System.Data.Entity;
using Microsoft.EntityFrameworkCore;
using eCar.Services.Interfaces;
using eCar.Services.Services;
using Mapster;
using FluentAssertions.Common;
using Newtonsoft.Json;
using Microsoft.AspNetCore.SignalR;
using eCar.Services.StateMachine.RouteStateMachine;
using eCar.Services.StateMachine.RentStateMachine;
using eCar.API.Filters;

internal class Program
{
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.
        builder.Services.AddTransient<IRouteService, RouteService>();
        builder.Services.AddTransient<IUserService, UserService>();
        builder.Services.AddTransient<IVehicleService, VehicleService>();
        builder.Services.AddTransient<IRentService,RentService>();
        builder.Services.AddTransient<BaseRouteState>();
        builder.Services.AddTransient<InitialRouteState>();
        builder.Services.AddTransient<WaitRouteState>();
        builder.Services.AddTransient<FinishedRouteState>();
        builder.Services.AddTransient<BaseRentState>();
        builder.Services.AddTransient<InitialRentState>();
        builder.Services.AddTransient<WaitRentState>();
        builder.Services.AddTransient<FinishedRentState>();

        builder.Services.AddControllers(x =>
        {
            x.Filters.Add<ExceptionFilter>();
        });


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
        MapsterConfig.Configure();


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