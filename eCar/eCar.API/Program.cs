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
using Microsoft.AspNetCore.Authentication;
using eCar.API;
using Microsoft.OpenApi.Models;
using ServiceStack;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using eCar.Services.Helpers;

internal class Program
{
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);
   

        // Add services to the container.
        builder.Services.AddTransient<IUserService, UserService>();
        builder.Services.AddTransient<IAdminService, AdminService>();
        builder.Services.AddTransient<IClientService, ClientService>();
        builder.Services.AddTransient<IDriverService, DriverService>();
        builder.Services.AddTransient<IRouteService, RouteService>();
        builder.Services.AddTransient<IRentService,RentService>();
        builder.Services.AddTransient<IVehicleService, VehicleService>();
        builder.Services.AddTransient<BaseRouteState>();
        builder.Services.AddTransient<InitialRouteState>();
        builder.Services.AddTransient<WaitRouteState>();
        builder.Services.AddTransient<FinishedRouteState>();
        builder.Services.AddTransient<BaseRentState>();
        builder.Services.AddTransient<InitialRentState>();
        builder.Services.AddTransient<WaitRentState>();
        builder.Services.AddTransient<FinishedRentState>();

        builder.Services.AddSingleton<IConfiguration>(builder.Configuration);

        //jwt authentication
        // builder.Services.AddAuthentication(
        //    JwtBearerDefaults.AuthenticationScheme
        // ).AddJwtBearer(options =>
        // {
        // options.TokenValidationParameters = new TokenValidationParameters
        // {
        //     ValidateIssuerSigningKey = true,
        //     IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration.GetSection("AppSettings:Token").Value)),
        //     ValidateIssuer = false,
        //     ValidateAudience = false,
        //     ClockSkew = TimeSpan.FromSeconds(300)
        // };
        // });

        builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).
            AddJwtBearer(options =>
            {
                options.RequireHttpsMetadata= false;
                options.TokenValidationParameters= new TokenValidationParameters()
                { 
                    IssuerSigningKey=new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Secret"])),
                    ValidIssuer = builder.Configuration["Jwt:Issuer"],
                    ValidAudience = builder.Configuration["Jwt:Audience"],
                    ClockSkew=TimeSpan.Zero
                };
            });


        builder.Services.AddControllers(x =>
        {
            x.Filters.Add<ExceptionFilter>();
        });
  

        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen(c =>
        {
            c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
            {
                In = ParameterLocation.Header,
                Name = "Authorization",
                Type = SecuritySchemeType.Http,
                Scheme = "Bearer"
            });
            c.AddSecurityRequirement(new OpenApiSecurityRequirement()
      {
        {
          new OpenApiSecurityScheme
          {
            Reference = new OpenApiReference
              {
                Type = ReferenceType.SecurityScheme,
                Id = "Bearer"
              },
              Scheme = "oauth2",
              Name = "Bearer",
              In = ParameterLocation.Header,

            },
            new List<string>()
          }
        });
        });


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
        TokenGenerate.Context = app.Services.CreateScope().ServiceProvider.GetRequiredService<ECarDbContext>();
        TokenGenerate.Configuration = app.Services.GetRequiredService<IConfiguration>();

        app.UseHttpsRedirection();

        app.UseAuthentication();
        app.UseAuthorization();

        app.MapControllers();

        app.Run();
    }
}