#!/bin/bash

# Script pour lancer Flutter sur le web (localhost:4001)

# Vérifie si Flutter est installé
if ! command -v flutter &> /dev/null
then
    echo "Flutter n'est pas installé ou n'est pas dans le PATH."
    exit 1
fi

# Nettoyage optionnel (décommente si besoin)
# flutter clean

# Lancer Flutter sur le web avec le port 4001
flutter run -d web-server --web-port=4001 --web-hostname=localhost

