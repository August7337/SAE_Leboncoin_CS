# Usage

## Github conf

```
git config --global user.email "you@example.com"
```

```
git config --global user.name "Your Name"
```

## Git dans Visual Studio

Vérifier si on est à jour
```
git status
```

## Dotnet ef

### 0. Installation
```
dotnet tool install --global dotnet-ef --version 8.0.23
```

### 1. Supprime la migration précédente (celle qui a généré le mauvais script) :
```
dotnet ef migrations remove --project "LeboncoinAPI"
```
Si la suppression échoue car la migration a déjà été appliquée (partiellement), supprimer la base de données manuellement dans PgAdmin ou faire 
```
dotnet ef database update 0 --project "LeboncoinAPI"
```

### 2. Créer/Recréer la migration :
```
dotnet ef migrations add migration-v1.0.0 --project "LeboncoinAPI"
```

### 3. Vérifie le script de création :
```
dotnet ef migrations script --project "LeboncoinAPI"
```

### 4. Applique à la base :
```
dotnet ef database update --project "LeboncoinAPI"
```
