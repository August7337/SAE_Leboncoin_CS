# ==============================================================================
# SCRIPT DE MIGRATION ET DE PEUPLEMENT (SEED) POUR ENTITY FRAMEWORK CORE
# ==============================================================================

# --- CONFIGURATION DES CHEMINS ---
$ProjectName = ".\LeboncoinAPI"
$MigrationsDir = "$ProjectName\Migrations"
$DatabaseDir = "$ProjectName\Database"
$InsertsFile = "$DatabaseDir\inserts.sql"
$SchemaFile = "$DatabaseDir\schema.sql"
$DropTableFile = "$DatabaseDir\drop-table.sql"
$psqlPath = "C:\Program Files\PostgreSQL\17\bin\psql.exe"

# --- CHARGEMENT DU FICHIER .ENV ---
$EnvFilePath = ".env"

if (Test-Path $EnvFilePath) {

    Get-Content $EnvFilePath | ForEach-Object {
        if ($_ -match '^\s*([^#=]+?)\s*=\s*(.*)\s*$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()

            # enlever guillemets
            $value = $value.Trim('"').Trim("'")

            # enlever caractères invisibles (CRLF)
            $value = $value -replace "`r", ""
            $value = $value -replace "`n", ""

            [Environment]::SetEnvironmentVariable($name, $value, 'Process')
        }
    }

    Write-Host "[OK] Fichier .env charge correctement." -ForegroundColor Green

} else {
    Write-Warning "Fichier .env non trouve a l'emplacement : $EnvFilePath"
}

# --- IDENTIFIANTS DE BASE DE DONNEES (recuperes depuis le .env) ---
$DbHost = $env:DB_HOST
$DbPort = $env:DB_PORT
$DbName = $env:DB_NAME
$DbUser = $env:DB_USER
$DbPass = $env:DB_PASS

if ([string]::IsNullOrEmpty($DbHost)) { $DbHost = "localhost" }
if ([string]::IsNullOrEmpty($DbPort)) { $DbPort = "5432" }

Write-Host "`n======================================================" -ForegroundColor Cyan
Write-Host " DEBUT DU PROCESSUS DE MIGRATION ET SEEDING EF CORE" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

# ------------------------------------------------------------------------------
# 1. RESET DES MIGRATIONS
# ------------------------------------------------------------------------------
Write-Host "`n[1/5] Reset des migrations..." -ForegroundColor Yellow
Write-Host "      Voulez-vous supprimer les migrations ET les tables ? (y/N) > " -ForegroundColor Red -NoNewline
$confirmation = Read-Host

$dropTableExecuted = $false

if ($confirmation -eq "y") {
    if (Test-Path $MigrationsDir) {
        Remove-Item -Recurse -Force $MigrationsDir
        Write-Host "      Dossier Migrations supprime." -ForegroundColor Green
    } else {
        Write-Host "      Aucun dossier Migrations trouve, on continue." -ForegroundColor Gray
    }

    # ------------------------------------------------------------------------------
    # DROP DES TABLES (uniquement si confirmation = y)
    # ------------------------------------------------------------------------------
    Write-Host "`n      Suppression des tables via drop-table.sql..." -ForegroundColor Yellow

    if (Test-Path $DropTableFile) {
        if (Test-Path $psqlPath) {
            $connectionString = "host=$DbHost port=$DbPort dbname=$DbName user=$DbUser password=$DbPass"
            $dropOutput = & $psqlPath $connectionString -q -v ON_ERROR_STOP=0 -f $DropTableFile 2>&1
            foreach ($line in $dropOutput) {
                Write-Host "      $line" -ForegroundColor Gray
            }
            Write-Host "      Tables supprimees avec succes." -ForegroundColor Green
            $dropTableExecuted = $true
        } else {
            Write-Error "psql.exe introuvable dans $psqlPath. Verifie l'installation de Postgres 17."
            exit
        }
    } else {
        Write-Host "      Fichier $DropTableFile introuvable, suppression des tables ignoree." -ForegroundColor Gray
    }
} else {
    Write-Host "      Suppression ignoree, on passe a la suite." -ForegroundColor Gray
    Write-Host "      Le script inserts.sql ne sera pas execute (drop-table non lance)." -ForegroundColor Gray
}

# ------------------------------------------------------------------------------
# 2. DETERMINER LA PROCHAINE VERSION DE MIGRATION
# ------------------------------------------------------------------------------
$NextVersion = "1.0.0"

if (Test-Path $MigrationsDir) {
    $files = Get-ChildItem -Path $MigrationsDir -Filter "*_migration-v*.cs"
    
    if ($files.Count -gt 0) {
        $latestFile = $files | Sort-Object Name -Descending | Select-Object -First 1
        
        if ($latestFile.Name -match "migration-v(\d+)\.(\d+)\.(\d+)") {
            $major = [int]$matches[1]
            $minor = [int]$matches[2]
            $patch = [int]$matches[3]
            
            $patch++
            $NextVersion = "$major.$minor.$patch"
        }
    }
}

$MigrationName = "migration-v$NextVersion"
Write-Host "`n[2/5] Prochaine version detectee : $MigrationName" -ForegroundColor Yellow
Write-Host "      Creation de la migration..."

dotnet ef migrations add $MigrationName --project $ProjectName
if ($LASTEXITCODE -ne 0) { Write-Error "Echec de la creation de la migration."; exit }

# ------------------------------------------------------------------------------
# 3. GENERER LE SCRIPT DE CREATION DE LA BASE DE DONNEES
# ------------------------------------------------------------------------------
Write-Host "`n[3/5] Generation du script SQL de la base de donnees..." -ForegroundColor Yellow

if (-not (Test-Path $DatabaseDir)) { New-Item -ItemType Directory -Path $DatabaseDir | Out-Null }

dotnet ef migrations script --project $ProjectName --output $SchemaFile
if ($LASTEXITCODE -ne 0) { Write-Error "Echec de la generation du script."; exit }

Write-Host "      Script genere avec succes dans : $SchemaFile" -ForegroundColor Green

# ------------------------------------------------------------------------------
# 4. APPLIQUER LA MIGRATION A LA BASE DE DONNEES
# ------------------------------------------------------------------------------
Write-Host "`n[4/5] Application des changements a la base de donnees (Update)..." -ForegroundColor Yellow

dotnet ef database update --project $ProjectName
if ($LASTEXITCODE -ne 0) { Write-Error "Echec de la mise a jour de la base de donnees."; exit }

Write-Host "`n======================================================" -ForegroundColor Cyan
Write-Host " PROCESSUS TERMINE AVEC SUCCES !" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan