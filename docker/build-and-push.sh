#!/bin/bash
# =============================================================================
# build-and-push.sh — Build l'image API et pousse sur Docker Hub
# Usage : ./build-and-push.sh [TAG]
#   TAG par défaut : latest
#   Exemple : ./build-and-push.sh v1.0.0
# =============================================================================
set -euo pipefail

IMAGE_NAME="gregory73/leboncoin_api"
TAG="${1:-latest}"
FULL_IMAGE="${IMAGE_NAME}:${TAG}"

# Se placer à la racine du workspace (un niveau au-dessus de docker/)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_ROOT="$(dirname "$SCRIPT_DIR")"

echo ""
echo "===== LeboncoinAPI — Build & Push ====="
echo "  Image  : ${FULL_IMAGE}"
echo "  Contexte : ${WORKSPACE_ROOT}"
echo "======================================="
echo ""

# ─── 1. Build depuis la racine du workspace ───────────────────────────────────
echo "[1/3] Build de l'image Docker..."
docker build \
    --file  "${SCRIPT_DIR}/Dockerfile.api" \
    --tag   "${FULL_IMAGE}" \
    --tag   "${IMAGE_NAME}:latest" \
    "${WORKSPACE_ROOT}"

echo ""
echo "[2/3] Image buildée avec succès : ${FULL_IMAGE}"

# ─── 2. Push vers Docker Hub ──────────────────────────────────────────────────
echo ""
echo "[3/3] Push vers Docker Hub..."
docker push "${FULL_IMAGE}"

# Si le tag n'est pas 'latest', pousser aussi le tag latest
if [ "${TAG}" != "latest" ]; then
    docker push "${IMAGE_NAME}:latest"
fi

echo ""
echo "===== DONE ====="
echo "  Image disponible : https://hub.docker.com/r/gregory73/leboncoin_api"
echo ""
echo "  Ton collègue peut maintenant déployer avec :"
echo "    cd deploy/"
echo "    cp .env.example .env && nano .env"
echo "    docker compose up -d"
echo ""
