# Docker — LeboncoinAPI

Configuration Docker complète pour l'API backend (.NET 8) et PostgreSQL.

## Structure des fichiers

```
docker/
├── docker-compose.yml   # Orchestration des services
├── Dockerfile.api       # Image multi-stage .NET 8
├── entrypoint.sh        # Migrations EF Core + démarrage API
├── .env.example         # Template des variables d'environnement
└── README.md            # Ce fichier

.dockerignore            # À la racine du workspace (exclut bin/, obj/, tests…)
```

---

## Pré-requis

- Docker Engine ≥ 24.x
- Docker Compose plugin v2 (`docker compose` — pas `docker-compose`)
- Sur le serveur Linux : `curl`, accès internet pour puller les images

---

## Démarrage rapide

### 1. Se placer dans le dossier docker

```bash
cd docker/
```

### 2. Créer le fichier .env

```bash
cp .env.example .env
```

Éditer `.env` avec des valeurs réelles :

```bash
nano .env   # ou vim .env
```

Les variables **obligatoires** :
| Variable | Description |
|---|---|
| `DB_NAME` | Nom de la base de données |
| `DB_USER` | Utilisateur PostgreSQL |
| `DB_PASS` | Mot de passe PostgreSQL (fort !) |
| `JWT_SECRET_KEY` | Clé secrète JWT (≥ 32 caractères) |

### 3. Builder les images

```bash
docker compose build
```

Forcer un rebuild complet (sans cache) :

```bash
docker compose build --no-cache
```

### 4. Lancer les conteneurs

```bash
docker compose up -d
```

L'API démarre **après** que PostgreSQL passe le healthcheck.  
Les migrations EF Core sont appliquées automatiquement au premier démarrage.

### 5. Vérifier les logs

```bash
# Tous les services
docker compose logs -f

# API seulement
docker compose logs -f api

# PostgreSQL seulement
docker compose logs -f db
```

### 6. Tester l'API

```bash
curl http://localhost:8080/swagger/index.html
# ou
curl http://<IP_SERVEUR>:8080/swagger/index.html
```

---

## Commandes utiles

```bash
# Statut des conteneurs
docker compose ps

# Arrêter sans supprimer les données
docker compose stop

# Arrêter et supprimer les conteneurs (données préservées dans le volume)
docker compose down

# Arrêter et SUPPRIMER les données (volume inclus) — DANGER
docker compose down -v

# Redémarrer uniquement l'API
docker compose restart api

# Ouvrir un shell dans le conteneur API
docker compose exec api bash

# Ouvrir psql dans le conteneur DB
docker compose exec db psql -U ${DB_USER} -d ${DB_NAME}

# Voir les ressources consommées en temps réel
docker stats leboncoin_api leboncoin_db
```

---

## Tests de charge / performance

### Configuration des ressources

Dans `docker-compose.yml`, section `deploy.resources` de chaque service :

```yaml
# API — exemple pour simuler un serveur 2 vCPU / 512 MB RAM
deploy:
  resources:
    limits:
      cpus:   '2.0'
      memory: 512M

# DB — exemple pour donner plus de buffer PostgreSQL
deploy:
  resources:
    limits:
      cpus:   '2.0'
      memory: 1G
```

Ajuster `shared_buffers` dans la commande `postgres` en conséquence :
- Règle générale : `shared_buffers` = 25% de la RAM allouée à PostgreSQL

### Surveiller les performances en temps réel

```bash
# CPU / RAM / réseau en temps réel
docker stats

# Logs de requêtes lentes (> 500ms, configuré dans docker-compose.yml)
docker compose logs -f db | grep "duration"

# Métriques syscall (nécessite perf sur l'hôte)
docker compose exec api top
```

### Outil de charge recommandé : k6

```bash
# Installer k6 sur le serveur de test
sudo apt install k6

# Exemple de script de charge basique (créer load_test.js)
cat > load_test.js << 'EOF'
import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 50,           // 50 utilisateurs virtuels
  duration: '2m',    // pendant 2 minutes
};

export default function () {
  http.get('http://localhost:8080/api/annonces');
  sleep(0.5);
}
EOF

k6 run load_test.js
```

### Optimisations PostgreSQL déjà actives

| Paramètre | Valeur | Effet |
|---|---|---|
| `max_connections` | 300 | Supporte plus de connexions simultanées |
| `shared_buffers` | 256MB | Cache en mémoire partagée |
| `work_mem` | 4MB | Mémoire par opération de tri |
| `effective_cache_size` | 1GB | Hint au planner pour l'utilisation du cache OS |
| `log_min_duration_statement` | 500ms | Log uniquement les requêtes lentes |

---

## Variables d'environnement complètes

| Variable | Obligatoire | Défaut | Description |
|---|---|---|---|
| `DB_NAME` | Oui | — | Nom de la base |
| `DB_USER` | Oui | — | Utilisateur PostgreSQL |
| `DB_PASS` | Oui | — | Mot de passe |
| `API_PORT` | Non | `8080` | Port exposé sur l'hôte |
| `JWT_SECRET_KEY` | Oui | — | Clé de signature JWT |
| `JWT_ISSUER` | Non | `LeboncoinAPI` | Issuer JWT |
| `JWT_AUDIENCE` | Non | `LeboncoinVueApp` | Audience JWT |
| `ASPNETCORE_ENVIRONMENT` | Non | `Production` | Environnement ASP.NET |
| `CLOUDINARY_CLOUD_NAME` | Non | — | Upload d'images |
| `CLOUDINARY_API_KEY` | Non | — | Upload d'images |
| `CLOUDINARY_API_SECRET` | Non | — | Upload d'images |
| `STRIPE_SECRET_KEY` | Non | — | Paiements Stripe |

---

## Architecture réseau

```
Hôte Linux
    │
    │ :8080 (exposé)
    ▼
┌─────────────────────────────────┐
│   Réseau Docker: leboncoin_net  │
│                                 │
│   [leboncoin_api] :8080         │
│          │                      │
│          │ :5432 (interne)      │
│          ▼                      │
│   [leboncoin_db]                │
│          │                      │
│          ▼                      │
│   Volume: postgres_data         │
└─────────────────────────────────┘
```

Le port PostgreSQL (5432) **n'est pas exposé à l'hôte** — uniquement accessible via le réseau interne Docker.

---

## Troubleshooting

### L'API ne démarre pas — erreur DB

```bash
docker compose logs api | grep -E "MIGRATE|ERROR|FATAL"
# Vérifier que les variables DB_* sont correctes dans .env
```

### Les migrations échouent

```bash
# Tester manuellement la connexion
docker compose exec api bash
./efbundle --connection "Server=db;Port=5432;Database=${DB_NAME};User Id=${DB_USER};Password=${DB_PASS};"
```

### Réinitialiser complètement la base

```bash
docker compose down -v      # Supprime le volume postgres_data
docker compose up -d        # Recrée la base et rejoue les migrations
```
