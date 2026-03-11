using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using Microsoft.EntityFrameworkCore;
using DotNetEnv; 

var builder = WebApplication.CreateBuilder(args);

// charge le fichier .env présent à la racine
Env.TraversePath().Load();

// récupère les identifiants depuis le .env (avec des valeurs par défaut si non trouvé)
var dbHost = Environment.GetEnvironmentVariable("DB_HOST") ?? "localhost";
var dbPort = Environment.GetEnvironmentVariable("DB_PORT") ?? "5432";
var dbName = Environment.GetEnvironmentVariable("DB_NAME") ?? "LeboncoinDB";
var dbUser = Environment.GetEnvironmentVariable("DB_USER") ?? "postgres";
var dbPass = Environment.GetEnvironmentVariable("DB_PASS") ?? "postgres";

var connectionString = $"Server={dbHost};Port={dbPort};Database={dbName};User Id={dbUser};Password={dbPass};";

builder.Services.AddDbContext<LeboncoinDBContext>(options =>
    options.UseNpgsql(connectionString));

builder.Services.AddScoped<IDataUtilisateurRepository<Utilisateur>, UtilisateurManager>();
builder.Services.AddScoped<IDataRepository<Annonce>, AnnonceManager>();
builder.Services.AddScoped<IDataRepository<Reservation>, ReservationManager>();

builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
    });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();