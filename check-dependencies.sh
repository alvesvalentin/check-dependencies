#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Vérifier les arguments
if [ "$#" -lt 1 ]; then
    echo -e "${RED}Usage: $0 <chemin/vers/package.json> [fichier_packages.txt]${NC}"
    echo ""
    echo "Exemples:"
    echo "  $0 ./package.json"
    echo "  $0 /chemin/vers/mon/projet/package.json packages.txt"
    exit 1
fi

# Chemin vers le package.json
PACKAGE_JSON_PATH="$1"

# Fichier contenant la liste des packages (par défaut packages.txt)
PACKAGES_FILE="${2:-packages.txt}"
REPORT_FILE="dependencies-report.txt"

# Vérifier si le package.json existe
if [ ! -f "$PACKAGE_JSON_PATH" ]; then
    echo -e "${RED}❌ Fichier package.json non trouvé: $PACKAGE_JSON_PATH${NC}"
    exit 1
fi

# Obtenir le répertoire du package.json
PACKAGE_DIR=$(dirname "$PACKAGE_JSON_PATH")

# Vérifier si le fichier packages.txt existe
if [ ! -f "$PACKAGES_FILE" ]; then
    echo -e "${RED}❌ Fichier \"$PACKAGES_FILE\" non trouvé${NC}"
    echo ""
    echo "Créez un fichier \"$PACKAGES_FILE\" avec un nom de package par ligne."
    exit 1
fi

echo -e "${BLUE}🚀 Vérification des dépendances npm${NC}"
echo ""
echo -e "${BLUE}📦 Package.json: $PACKAGE_JSON_PATH${NC}"
echo -e "${BLUE}🔍 Lecture de la liste des packages...${NC}"
echo ""

# Compter le nombre de packages (en ignorant les lignes vides et commentaires)
TOTAL_PACKAGES=$(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$' | wc -l)

if [ "$TOTAL_PACKAGES" -eq 0 ]; then
    echo -e "${RED}❌ Aucun package trouvé dans le fichier${NC}"
    exit 1
fi

echo -e "${BLUE}📦 $TOTAL_PACKAGES package(s) à vérifier${NC}"
echo ""
echo -e "${BLUE}📊 Analyse de l'arbre de dépendances...${NC}"
echo ""

# Se déplacer dans le répertoire du package.json et obtenir l'arbre complet des dépendances
cd "$PACKAGE_DIR" || exit 1
DEPS_JSON=$(npm ls --all --json 2>/dev/null)

if [ $? -ne 0 ] && [ -z "$DEPS_JSON" ]; then
    echo -e "${RED}❌ Erreur lors de la récupération des dépendances${NC}"
    exit 1
fi

# Initialiser les compteurs
FOUND=0
NOT_FOUND=0

# Créer/vider le fichier de rapport
echo "RAPPORT DE VÉRIFICATION DES DÉPENDANCES" > "$REPORT_FILE"
echo "Généré le: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "PACKAGES TROUVÉS:" >> "$REPORT_FILE"
echo "=================" >> "$REPORT_FILE"

FOUND_LIST=""
NOT_FOUND_LIST=""

# Lire le fichier ligne par ligne
while IFS= read -r package_name || [ -n "$package_name" ]; do
    # Ignorer les lignes vides et les commentaires
    if [[ -z "$package_name" ]] || [[ "$package_name" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    # Enlever les espaces en début et fin
    package_name=$(echo "$package_name" | xargs)
    
    # Vérifier si le package existe dans l'arbre de dépendances
    # On cherche "nom_package": dans le JSON
    if echo "$DEPS_JSON" | grep -q "\"$package_name\""; then
        echo -e "${GREEN}✅ $package_name - TROUVÉ${NC}"
        FOUND=$((FOUND + 1))
        FOUND_LIST="${FOUND_LIST}${package_name}\n"
        echo "  - $package_name" >> "$REPORT_FILE"
    else
        echo -e "${RED}❌ $package_name - NON TROUVÉ${NC}"
        NOT_FOUND=$((NOT_FOUND + 1))
        NOT_FOUND_LIST="${NOT_FOUND_LIST}${package_name}\n"
    fi
done < "$PACKAGES_FILE"

# Ajouter les packages non trouvés au rapport
echo "" >> "$REPORT_FILE"
echo "PACKAGES NON TROUVÉS:" >> "$REPORT_FILE"
echo "=====================" >> "$REPORT_FILE"
if [ "$NOT_FOUND" -eq 0 ]; then
    echo "  Aucun" >> "$REPORT_FILE"
else
    echo -e "$NOT_FOUND_LIST" | while IFS= read -r pkg; do
        if [ -n "$pkg" ]; then
            echo "  - $pkg" >> "$REPORT_FILE"
        fi
    done
fi

# Afficher le résumé
echo ""
echo "=================================================="
echo -e "${BLUE}📋 RÉSUMÉ${NC}"
echo "=================================================="
echo -e "${GREEN}✅ Trouvés: $FOUND${NC}"
echo -e "${RED}❌ Non trouvés: $NOT_FOUND${NC}"
echo -e "${BLUE}📊 Total: $TOTAL_PACKAGES${NC}"

# Ajouter le résumé au rapport
echo "" >> "$REPORT_FILE"
echo "RÉSUMÉ:" >> "$REPORT_FILE"
echo "=======" >> "$REPORT_FILE"
echo "Trouvés: $FOUND" >> "$REPORT_FILE"
echo "Non trouvés: $NOT_FOUND" >> "$REPORT_FILE"
echo "Total: $TOTAL_PACKAGES" >> "$REPORT_FILE"

echo ""
echo -e "${GREEN}💾 Rapport sauvegardé dans \"$REPORT_FILE\"${NC}"