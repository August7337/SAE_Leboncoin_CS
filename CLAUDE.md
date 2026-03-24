# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Full-stack application resembling Leboncoin (rental listings platform) with:
- **Backend**: .NET 8 Web API with Entity Framework Core and PostgreSQL
- **Frontend**: Vue 3 + Vite + Tailwind CSS 4

## Common Commands

### Backend (.NET API)

```bash
# Build
cd LeboncoinAPI/LeboncoinAPI
dotnet build

# Run development server (HTTPS)
dotnet run --launch-profile "https"
# Default URLs: https://localhost:7057, http://localhost:5150

# Entity Framework Migrations
dotnet ef migrations add <name> --project "LeboncoinAPI"
dotnet ef database update --project "LeboncoinAPI"
dotnet ef migrations remove --project "LeboncoinAPI"
```

### Frontend (Vue.js)

```bash
cd LeboncoinClient

# Install dependencies
npm install

# Development server (with API proxy)
npm run dev
# Default URL: http://localhost:5173

# Build for production
npm run build

# Format code
npm run format
```

## Architecture

### Backend (.NET)

**Repository Pattern**: Controllers depend on repository interfaces injected via DI.
- `Models/Repository/` - Repository interfaces (e.g., `IDataRepository<T>`, `IAnnonceRepository`)
- `Models/DataManager/` - Repository implementations (e.g., `AnnonceManager`, `UtilisateurManager`)
- `Controllers/` - API controllers using repository pattern
- `Models/EntityFramework/` - EF entities and DbContext
- `Models/DTOs/` - Data Transfer Objects

**Key Configuration**:
- Database connection via environment variables (DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASS) loaded from `.env` file using DotNetEnv
- CORS policy allows all origins in development
- Swagger available at `/swagger` in development mode

### Frontend (Vue 3)

**Structure**:
- `src/views/` - Page components organized by feature (auth/, annonces/, account/, profile/)
- `src/components/` - Reusable components (Header.vue, Footer.vue, AnnonceList.vue, etc.)
- `src/services/` - API service layer (api.js, annoncesService.js, reservationsService.js, utilisateursService.js)
- `src/router/index.js` - Vue Router configuration with auth guards (`requiresAuth` meta property)
- `src/auth.js` - Authentication state management

**API Communication**:
- Base URL configured via `VITE_API_BASE_URL` environment variable (default: http://localhost:5150)
- Vite dev server proxies `/api` requests to backend
- Services in `src/services/` wrap API calls for each domain

## Important Files

- `LeboncoinAPI/LeboncoinAPI/Models/EntityFramework/LeboncoinDBContext.cs` - Database context with all entity configurations
- `LeboncoinAPI/LeboncoinAPI/Program.cs` - Service registration, middleware pipeline, CORS setup
- `LeboncoinClient/vite.config.js` - Vite configuration with API proxy and Tailwind CSS
- `LeboncoinClient/src/services/api.js` - HTTP helpers (GET, POST, PUT, DELETE)

## Database

PostgreSQL with EF Core code-first migrations. All foreign key relationships use `DeleteBehavior.Restrict`.

Key entities: Utilisateur, Annonce, Reservation, Particulier, Professionnel, Commodite, TypeHebergement, Photo, Message, Adresse, Ville.

## Environment Setup

Backend requires a `.env` file in `LeboncoinAPI/LeboncoinAPI/` with database credentials.
Frontend uses `.env` or `.env.local` for `VITE_API_BASE_URL`.
