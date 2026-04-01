#!/bin/bash
# =============================================================================
# entrypoint.sh — Script de démarrage du conteneur API
# 1. Applique les migrations EF Core
# 2. Lance l'API ASP.NET Core
# =============================================================================
set -euo pipefail

# ─── Couleurs pour les logs ───────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log_info()    { echo -e "${CYAN}[ENTRYPOINT $(date +%H:%M:%S)]${NC} $1"; }
log_success() { echo -e "${GREEN}[ENTRYPOINT $(date +%H:%M:%S)]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[ENTRYPOINT $(date +%H:%M:%S)]${NC} $1"; }
log_error()   { echo -e "${RED}[ENTRYPOINT $(date +%H:%M:%S)]${NC} $1"; }

# ─── Vérification des variables obligatoires ─────────────────────────────────
REQUIRED_VARS=("DB_HOST" "DB_PORT" "DB_NAME" "DB_USER" "DB_PASS")
for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var:-}" ]; then
        log_error "Variable d'environnement manquante : $var"
        exit 1
    fi
done

log_info "===== LeboncoinAPI Container démarrage ====="
log_info "DB_HOST=${DB_HOST} | DB_PORT=${DB_PORT} | DB_NAME=${DB_NAME} | DB_USER=${DB_USER}"
log_info "ASPNETCORE_ENVIRONMENT=${ASPNETCORE_ENVIRONMENT:-Production}"

# ─── Attendre que PostgreSQL soit disponible (filet de sécurité supplémentaire)
MAX_RETRIES=30
RETRY_INTERVAL=2
CONNECTION_STRING="Server=${DB_HOST};Port=${DB_PORT};Database=${DB_NAME};User Id=${DB_USER};Password=${DB_PASS};"

log_info "Vérification de la disponibilité de PostgreSQL..."
for i in $(seq 1 $MAX_RETRIES); do
    if pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -q 2>/dev/null; then
        log_success "PostgreSQL est disponible (tentative $i/$MAX_RETRIES)"
        break
    fi
    if [ "$i" = "$MAX_RETRIES" ]; then
        log_warn "pg_isready non disponible ou DB inaccessible après ${MAX_RETRIES} tentatives — on continue quand même"
    fi
    log_info "Attente PostgreSQL... ($i/$MAX_RETRIES)"
    sleep $RETRY_INTERVAL
done

# ─── Application des migrations EF Core ──────────────────────────────────────
log_info "Application des migrations EF Core..."
if ./efbundle --connection "${CONNECTION_STRING}"; then
    log_success "Migrations appliquées avec succès."
else
    log_error "Échec de l'application des migrations ! Vérifiez la connexion DB."
    exit 1
fi

# ─── Lancement de l'API ───────────────────────────────────────────────────────
log_info "Lancement de l'API sur le port ${PORT:-8080}..."
exec dotnet LeboncoinAPI.dll
