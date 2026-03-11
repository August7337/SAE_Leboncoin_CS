# ==============================================================================
# SCRIPT DE MIGRATION ET DE PEUPLEMENT (SEED) POUR ENTITY FRAMEWORK CORE
# ==============================================================================

# --- CONFIGURATION DES CHEMINS ---
$ProjectName = ".\LeboncoinAPI" # Chemin vers le projet contenant le DbContext
$MigrationsDir = "$ProjectName\Migrations"
$DatabaseDir = "$ProjectName\Database"
$InsertsFile = "$DatabaseDir\inserts-v1.sql"
$SchemaFile = "$DatabaseDir\schema.sql"

# --- CHARGEMENT DU FICHIER .ENV ---
$EnvFilePath = ".env" # On pointe vers le .env qui est dans le projet API

if (Test-Path $EnvFilePath) {
    # Lecture du fichier .env et assignation des variables d'environnement pour cette session
    Get-Content $EnvFilePath | Where-Object { $_ -match '^([^#=]+)=(.*)$' } | ForEach-Object {
        $name = $matches[1].Trim()
        $value = $matches[2].Trim()
        [Environment]::SetEnvironmentVariable($name, $value, 'Process')
    }
    Write-Host "[OK] Fichier .env chargé avec succès." -ForegroundColor Green
} else {
    Write-Warning "Fichier .env non trouvé à l'emplacement : $EnvFilePath"
    Write-Host "Assure-toi que le fichier existe bien à la racine du projet API." -ForegroundColor Yellow
}

# --- IDENTIFIANTS DE BASE DE DONNÉES (récupérés depuis le .env) ---
$DbHost = $env:DB_HOST
$DbPort = $env:DB_PORT
$DbName = $env:DB_NAME
$DbUser = $env:DB_USER
$DbPass = $env:DB_PASS

# Valeurs par défaut de sécurité au cas où le .env serait mal formaté
if ([string]::IsNullOrEmpty($DbHost)) { $DbHost = "localhost" }
if ([string]::IsNullOrEmpty($DbPort)) { $DbPort = "5432" }

Write-Host "`n======================================================" -ForegroundColor Cyan
Write-Host " DEBUT DU PROCESSUS DE MIGRATION ET SEEDING EF CORE" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

# ------------------------------------------------------------------------------
# 1. DETERMINER LA PROCHAINE VERSION DE MIGRATION
# ------------------------------------------------------------------------------
$NextVersion = "1.0.0"

if (Test-Path $MigrationsDir) {
    # On cherche les fichiers qui correspondent au pattern de migration
    $files = Get-ChildItem -Path $MigrationsDir -Filter "*_migration-v*.cs"
    
    if ($files.Count -gt 0) {
        # Prendre le fichier le plus récent alphabétiquement (qui contient la version la plus haute)
        $latestFile = $files | Sort-Object Name -Descending | Select-Object -First 1
        
        # Extraire les numéros avec une expression régulière
        if ($latestFile.Name -match "migration-v(\d+)\.(\d+)\.(\d+)") {
            $major = [int]$matches[1]
            $minor = [int]$matches[2]
            $patch = [int]$matches[3]
            
            # Incrémenter la version "patch" (le dernier chiffre)
            $patch++
            $NextVersion = "$major.$minor.$patch"
        }
    }
}

$MigrationName = "migration-v$NextVersion"
Write-Host "`n[1/4] Prochaine version détectée : $MigrationName" -ForegroundColor Yellow
Write-Host "      Création de la migration..."

# Exécution de la commande EF Core
dotnet ef migrations add $MigrationName --project $ProjectName
if ($LASTEXITCODE -ne 0) { Write-Error "Échec de la création de la migration."; exit }

# ------------------------------------------------------------------------------
# 2. GENERER LE SCRIPT DE CREATION DE LA BASE DE DONNEES
# ------------------------------------------------------------------------------
Write-Host "`n[2/4] Génération du script SQL de la base de données..." -ForegroundColor Yellow

if (-not (Test-Path $DatabaseDir)) { New-Item -ItemType Directory -Path $DatabaseDir | Out-Null }

dotnet ef migrations script --project $ProjectName --output $SchemaFile
if ($LASTEXITCODE -ne 0) { Write-Error "Échec de la génération du script."; exit }

Write-Host "      Script généré avec succès dans : $SchemaFile" -ForegroundColor Green

# ------------------------------------------------------------------------------
# 3. APPLIQUER LA MIGRATION A LA BASE DE DONNEES
# ------------------------------------------------------------------------------
Write-Host "`n[3/4] Application des changements à la base de données (Update)..." -ForegroundColor Yellow

dotnet ef database update --project $ProjectName
if ($LASTEXITCODE -ne 0) { Write-Error "Échec de la mise à jour de la base de données."; exit }

# ------------------------------------------------------------------------------
# 4. INSERER LES DONNEES (SEED)
# ------------------------------------------------------------------------------
Write-Host "`n[4/4] Exécution du script d'insertions SQL ($InsertsFile)..." -ForegroundColor Yellow

$psqlPath = "C:\Program Files\PostgreSQL\17\bin\psql.exe"

if (Test-Path $InsertsFile) {
    if (Test-Path $psqlPath) {
        $connectionString = "host=$DbHost port=$DbPort dbname=$DbName user=$DbUser password=$DbPass"
        
        & $psqlPath $connectionString -f $InsertsFile
        
        if ($LASTEXITCODE -ne 0) { 
            Write-Host "      Des erreurs se sont produites durant l'insertion." -ForegroundColor Red
        } else {
            Write-Host "      Données insérées avec succès !" -ForegroundColor Green
        }
    } else {
        Write-Error "psql.exe introuvable dans $psqlPath. Vérifie l'installation de Postgres 17."
    }
} else {
    Write-Host "      Fichier $InsertsFile introuvable." -ForegroundColor Red
}

Write-Host "`n======================================================" -ForegroundColor Cyan
Write-Host " PROCESSUS TERMINE AVEC SUCCES ! " -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan