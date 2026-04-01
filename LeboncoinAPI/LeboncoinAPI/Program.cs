using LeboncoinAPI.Models.DataManager;
using LeboncoinAPI.Models.EntityFramework;
using LeboncoinAPI.Models.Repository;
using LeboncoinAPI.Services;
using Microsoft.EntityFrameworkCore;
using DotNetEnv;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

void LogBoot(string step)
{
    var managedMemoryMb = GC.GetTotalMemory(forceFullCollection: false) / (1024d * 1024d);
    var workingSetMb = Environment.WorkingSet / (1024d * 1024d);
    Console.WriteLine($"[BOOT {DateTime.Now:HH:mm:ss.fff}] {step} | Managed={managedMemoryMb:F1} MB | WorkingSet={workingSetMb:F1} MB");
}

AppDomain.CurrentDomain.UnhandledException += (_, eventArgs) =>
{
    Console.WriteLine($"[FATAL] Unhandled exception: {eventArgs.ExceptionObject}");
};

TaskScheduler.UnobservedTaskException += (_, eventArgs) =>
{
    Console.WriteLine($"[FATAL] Unobserved task exception: {eventArgs.Exception}");
};

LogBoot("CreateBuilder:start");
var builder = WebApplication.CreateBuilder(args);
LogBoot("CreateBuilder:done");

// Azure App Service Linux expose le port via la variable PORT (généralement 8080).
// On force Kestrel à écouter dessus pour éviter le timeout de 45s.
var listenPort = Environment.GetEnvironmentVariable("PORT") ?? "8080";
Console.WriteLine($"[BOOT] Kestrel will listen on http://+:{listenPort}");
builder.WebHost.UseUrls($"http://+:{listenPort}");

LogBoot("Env.Load:start");
if (System.IO.File.Exists(".env"))
{
    DotNetEnv.Env.Load();
}
LogBoot("Env.Load:done");

builder.Configuration["CloudinarySettings:CloudName"] = Environment.GetEnvironmentVariable("CLOUDINARY_CLOUD_NAME");
builder.Configuration["CloudinarySettings:ApiKey"] = Environment.GetEnvironmentVariable("CLOUDINARY_API_KEY");
builder.Configuration["CloudinarySettings:ApiSecret"] = Environment.GetEnvironmentVariable("CLOUDINARY_API_SECRET");
builder.Configuration["Stripe:SecretKey"] = Environment.GetEnvironmentVariable("STRIPE_SECRET_KEY");
var jwtSecret = Environment.GetEnvironmentVariable("JWT_SECRET_KEY");
if (string.IsNullOrEmpty(jwtSecret))
{
    Console.WriteLine("[WARNING] JWT_SECRET_KEY is not set. Using an insecure fallback. Set this variable in Azure App Settings.");
    jwtSecret = "FALLBACK_INSECURE_KEY_CHANGE_ME_32CHARS";
}
builder.Configuration["JwtSettings:SecretKey"] = jwtSecret;
builder.Configuration["JwtSettings:Issuer"] = Environment.GetEnvironmentVariable("JWT_ISSUER") ?? "LeboncoinAPI";
builder.Configuration["JwtSettings:Audience"] = Environment.GetEnvironmentVariable("JWT_AUDIENCE") ?? "LeboncoinVueApp";

var dbHost = Environment.GetEnvironmentVariable("DB_HOST") ?? "localhost";
var dbPort = Environment.GetEnvironmentVariable("DB_PORT") ?? "5432";
var dbName = Environment.GetEnvironmentVariable("DB_NAME") ?? "LeboncoinDB";
var dbUser = Environment.GetEnvironmentVariable("DB_USER") ?? "postgres";
var dbPass = Environment.GetEnvironmentVariable("DB_PASS") ?? "postgres";

var connectionString = $"Server={dbHost};Port={dbPort};Database={dbName};User Id={dbUser};Password={dbPass};";

Console.WriteLine($"[DEBUG] Current Dir: {Environment.CurrentDirectory}");
Console.WriteLine($"[DEBUG] Environment: {builder.Environment.EnvironmentName}");
Console.WriteLine($"[DB] Connexion vers : {dbHost}:{dbPort}/{dbName} avec user={dbUser}");

LogBoot("Services.AddDbContext:start");
builder.Services.AddDbContext<LeboncoinDBContext>(options =>
    options.UseNpgsql(connectionString, npgsql =>
        npgsql.UseQuerySplittingBehavior(QuerySplittingBehavior.SplitQuery)));
LogBoot("Services.AddDbContext:done");

LogBoot("Services.RegisterRepositories:start");
builder.Services.AddScoped<ICommoditeRepository, CommoditeManager>();
builder.Services.AddScoped<IDataUtilisateurRepository<Utilisateur>, UtilisateurManager>();
builder.Services.AddScoped<IAnnonceRepository, AnnonceManager>();
builder.Services.AddScoped<IReservationRepository, ReservationManager>();
builder.Services.AddScoped<IMessageRepository, MessageManager>();
builder.Services.AddScoped<IIncidentRepository, IncidentManager>();
builder.Services.AddScoped<IncidentWorkflowService>();

builder.Services.AddScoped<IEmailService, EmailService>();
// Particulier creation is handled through UtilisateurManager (full registration)
// Removed explicit ParticulierManager registration to prefer using UtilisateurManager flows
LogBoot("Services.RegisterRepositories:done");

LogBoot("Services.AddAuthentication:start");
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = builder.Configuration["JwtSettings:Issuer"],
        ValidAudience = builder.Configuration["JwtSettings:Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["JwtSettings:SecretKey"]!))
    };
});
LogBoot("Services.AddAuthentication:done");

LogBoot("Services.AddCors:start");
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
LogBoot("Services.AddCors:done");

LogBoot("Services.AddControllers:start");
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler =
        System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
    });
LogBoot("Services.AddControllers:done");

LogBoot("Services.AddSwagger:start");
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
LogBoot("Services.AddSwagger:done");

LogBoot("App.Build:start");
var app = builder.Build();
LogBoot("App.Build:done");

app.Lifetime.ApplicationStarted.Register(() => LogBoot("ApplicationStarted"));
app.Lifetime.ApplicationStopping.Register(() => LogBoot("ApplicationStopping"));
app.Lifetime.ApplicationStopped.Register(() => LogBoot("ApplicationStopped"));


LogBoot("Middleware.UseSwagger:start");
app.UseSwagger();
app.UseSwaggerUI();
LogBoot("Middleware.UseSwagger:done");



LogBoot("MiddlewarePipeline:start");
app.UseCors("AllowAll");

// app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
LogBoot("MiddlewarePipeline:done");
Console.WriteLine($"[BOOT] URLs: {string.Join(", ", app.Urls.DefaultIfEmpty("<configured by host>"))}");
LogBoot("App.Run:start");
app.Run();