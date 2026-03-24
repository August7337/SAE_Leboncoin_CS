using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;
using DotNetEnv;

var builder = WebApplication.CreateBuilder(args);


Env.TraversePath().Load();

builder.Configuration["CloudinarySettings:CloudName"] = Environment.GetEnvironmentVariable("CLOUDINARY_CLOUD_NAME");
builder.Configuration["CloudinarySettings:ApiKey"] = Environment.GetEnvironmentVariable("CLOUDINARY_API_KEY");
builder.Configuration["CloudinarySettings:ApiSecret"] = Environment.GetEnvironmentVariable("CLOUDINARY_API_SECRET");

var dbHost = Environment.GetEnvironmentVariable("DB_HOST") ?? "localhost";
var dbPort = Environment.GetEnvironmentVariable("DB_PORT") ?? "5432";
var dbName = Environment.GetEnvironmentVariable("DB_NAME") ?? "LeboncoinDB";
var dbUser = Environment.GetEnvironmentVariable("DB_USER") ?? "postgres";
var dbPass = Environment.GetEnvironmentVariable("DB_PASS") ?? "postgres";

var connectionString = $"Server={dbHost};Port={dbPort};Database={dbName};User Id={dbUser};Password={dbPass};";

Console.WriteLine($"[DEBUG] Current Dir: {Environment.CurrentDirectory}");
Console.WriteLine($"[DB] Connexion vers : {dbHost}:{dbPort}/{dbName} avec user={dbUser}");

builder.Services.AddDbContext<LeboncoinDBContext>(options =>
    options.UseNpgsql(connectionString));

builder.Services.AddScoped<IDataUtilisateurRepository<Utilisateur>, UtilisateurManager>();
builder.Services.AddScoped<IAnnonceRepository, AnnonceManager>();
builder.Services.AddScoped<IReservationRepository, ReservationManager>();
// Particulier creation is handled through UtilisateurManager (full registration)
// Removed explicit ParticulierManager registration to prefer using UtilisateurManager flows

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy =>
        {
            policy.AllowAnyOrigin()
                  .AllowAnyHeader()
                  .AllowAnyMethod();
        });
});

builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler =
        System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
    });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}


app.UseCors("AllowAll");

// app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();