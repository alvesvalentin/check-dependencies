# Check Dependencies

Un script bash pour vérifier la présence de packages npm spécifiques dans l'arbre de dépendances d'un projet.

## Description

Ce script permet de vérifier si une liste de packages npm est présente dans les dépendances (directes ou transitives) d'un projet Node.js. Il génère un rapport coloré dans le terminal ainsi qu'un fichier texte détaillé.

## Prérequis

- Bash
- Node.js et npm installés
- Un projet Node.js avec un `package.json` et des `node_modules` installés

## Installation

```bash
# Cloner ou télécharger le script
chmod +x check-dependencies.sh
```

## Utilisation

```bash
./check-dependencies.sh <chemin/vers/package.json> [fichier_packages.txt]
```

### Arguments

- `<chemin/vers/package.json>` : Chemin vers le fichier package.json du projet à analyser (obligatoire)
- `[fichier_packages.txt]` : Chemin vers le fichier contenant la liste des packages à vérifier (optionnel, par défaut: `packages.txt`)

### Fichier de packages

Créez un fichier texte (par défaut `packages.txt`) avec un nom de package par ligne :

```
react
lodash
express
moment
axios
```

Vous pouvez également ajouter des commentaires avec `#` :

```
# Frameworks
react
vue

# Utilitaires
lodash
moment
```

## Exemples d'exécution

### Exemple 1 : Vérification basique

```bash
./check-dependencies.sh ./package.json
```

**Sortie :**
```
🚀 Vérification des dépendances npm

📦 Package.json: ./package.json
🔍 Lecture de la liste des packages...

📦 5 package(s) à vérifier

📊 Analyse de l'arbre de dépendances...

✅ react - TROUVÉ
✅ lodash - TROUVÉ
❌ express - NON TROUVÉ
✅ moment - TROUVÉ
✅ axios - TROUVÉ

==================================================
📋 RÉSUMÉ
==================================================
✅ Trouvés: 4
❌ Non trouvés: 1
📊 Total: 5

💾 Rapport sauvegardé dans "dependencies-report.txt"
```

### Exemple 2 : Avec un fichier de packages personnalisé

```bash
./check-dependencies.sh /chemin/vers/mon/projet/package.json my-packages.txt
```

### Exemple 3 : Vérification d'un autre projet

```bash
./check-dependencies.sh ~/projects/my-app/package.json packages.txt
```

## Fichier de rapport

Le script génère automatiquement un fichier `dependencies-report.txt` avec le résultat détaillé :

```
RAPPORT DE VÉRIFICATION DES DÉPENDANCES
Généré le: Mar 26 nov 2025 14:30:15 CET

PACKAGES TROUVÉS:
=================
  - react
  - lodash
  - moment
  - axios

PACKAGES NON TROUVÉS:
=====================
  - express

RÉSUMÉ:
=======
Trouvés: 4
Non trouvés: 1
Total: 5
```

## Fonctionnalités

- ✅ Vérification des dépendances directes et transitives
- ✅ Affichage coloré dans le terminal
- ✅ Génération d'un rapport texte
- ✅ Support des commentaires dans le fichier de packages
- ✅ Compteur de packages trouvés/non trouvés
- ✅ Gestion des erreurs (fichiers manquants, etc.)

## Cas d'utilisation

- Vérifier si des packages spécifiques sont installés dans un projet
- Auditer les dépendances d'un projet
- Vérifier la présence de packages problématiques ou obsolètes
- Documenter les dépendances utilisées dans un projet

## Erreurs courantes

### Fichier package.json non trouvé
```
❌ Fichier package.json non trouvé: ./package.json
```
**Solution** : Vérifiez le chemin vers votre package.json

### Fichier packages.txt non trouvé
```
❌ Fichier "packages.txt" non trouvé
```
**Solution** : Créez un fichier packages.txt avec la liste des packages à vérifier

### node_modules non installés
```
❌ Erreur lors de la récupération des dépendances
```
**Solution** : Exécutez `npm install` dans le répertoire du projet

## Licence

MIT
