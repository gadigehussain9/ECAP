using ECAP.Infrastructure.Persistence;
using ECAP.Infrastructure.Identity;
using ECAP.Infrastructure.ExternalServices;
using ECAP.Infrastructure.Messaging;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();

// Add OpenAPI/Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add Infrastructure layers
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
    ?? "Server=(localdb)\\mssqllocaldb;Database=ECAP;Trusted_Connection=True;";

builder.Services.AddPersistence(connectionString);
builder.Services.AddIdentity();
builder.Services.AddExternalServices();
builder.Services.AddMessaging();

// Add MediatR (uncomment when ready)
// builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Program).Assembly));

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();

