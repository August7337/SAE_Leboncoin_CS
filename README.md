<div align="center">

# SAE Leboncoin CS

![.NET 8](https://img.shields.io/badge/.NET%208-512BD4.svg?style=for-the-badge&logo=dotnet&logoColor=white)
![Vue 3](https://img.shields.io/badge/Vue%203-4FC08D.svg?style=for-the-badge&logo=vuedotjs&logoColor=white)
![Vite](https://img.shields.io/badge/Vite-646CFF.svg?style=for-the-badge&logo=vite&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind%20CSS-06B6D4.svg?style=for-the-badge&logo=tailwindcss&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1.svg?style=for-the-badge&logo=postgresql&logoColor=white)

Full-stack school project inspired by Leboncoin: listings, users, bookings, messaging, and incident management, with a .NET 8 API and a Vue 3 client.

</div>

## Table of Contents

1. [Overview](#overview)
2. [Tech Stack](#tech-stack)
3. [Project Structure](#project-structure)
4. [Prerequisites](#prerequisites)
5. [Installation](#installation)
6. [Environment Variables Configuration](#environment-variables-configuration)
7. [Running the Project](#running-the-project)
8. [Migrations Entity Framework](#migrations-entity-framework)
9. [Useful Commands](#useful-commands)

## Overview

This repository contains a full rental marketplace application:

- Backend: REST API in ASP.NET Core (.NET 8) with Entity Framework Core
- Frontend: SPA Vue 3 avec Vite et Tailwind CSS
- Database: PostgreSQL

## Tech Stack

- Backend: ASP.NET Core, Entity Framework Core, Swagger
- Frontend: Vue 3, Vue Router, Vite, Tailwind CSS
- Data: PostgreSQL
- Tooling: dotnet-ef, npm

## Project Structure

```text
SAE_Leboncoin_CS/
|- LeboncoinAPI/
|  |- LeboncoinAPI.sln
|  |- LeboncoinAPI/
|     |- Controllers/
|     |- Models/
|     |- Migrations/
|     |- Program.cs
|
|- LeboncoinClient/
	|- src/
	|- tests/
	|- vite.config.js
```

## Prerequisites

- .NET SDK 8
- Node.js 18+ et npm
- PostgreSQL
- (optional) global dotnet-ef tool

## Installation

### 1. Clone the project

```bash
git clone <repository-url>
cd SAE_Leboncoin_CS
```

### 2. Install frontend dependencies

```bash
cd LeboncoinClient
npm install
```

### 3. Restore backend dependencies

```bash
cd ../LeboncoinAPI/LeboncoinAPI
dotnet restore
```

## Environment Variables Configuration

The backend reads database configuration from a `.env` file in `LeboncoinAPI/LeboncoinAPI/`.

Example:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=leboncoin
DB_USER=postgres
DB_PASS=postgres
```

The frontend can use `VITE_API_BASE_URL` via `.env` or `.env.local` in `LeboncoinClient/`.

Example:

```env
VITE_API_BASE_URL=http://localhost:5150
```

## Running the Project

Open 2 terminals:

### Terminal 1 - API

```bash
cd LeboncoinAPI/LeboncoinAPI
dotnet run --launch-profile "https"
```

API available by default at:

- `https://localhost:7057`
- `http://localhost:5150`

Swagger (dev mode):

- `https://localhost:7057/swagger`

### Terminal 2 - Frontend

```bash
cd LeboncoinClient
npm run dev
```

Frontend available by default at:

- `http://localhost:5173`

## Migrations Entity Framework

Install the tool (if needed):

```bash
dotnet tool install --global dotnet-ef --version 8.0.23
```

From the `LeboncoinAPI/LeboncoinAPI` folder:

```bash
# Add a migration
dotnet ef migrations add <NomMigration> --project "LeboncoinAPI"

# Apply migrations
dotnet ef database update --project "LeboncoinAPI"

# Generate SQL script
dotnet ef migrations script --project "LeboncoinAPI"

# Remove the last migration (not applied)
dotnet ef migrations remove --project "LeboncoinAPI"
```

## Useful Commands

### Backend

```bash
cd LeboncoinAPI/LeboncoinAPI
dotnet build
dotnet test ../LeboncoinAPITests
```

### Frontend

```bash
cd LeboncoinClient
npm run dev
npm run build
npm run format
```
