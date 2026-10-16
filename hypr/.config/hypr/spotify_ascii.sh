#!/bin/bash

# Detectar automáticamente el primer reproductor activo disponible
PLAYER=$(playerctl -l | head -n 1)

if [ -z "$PLAYER" ]; then
    echo "No hay ningún reproductor de música abierto."
    exit 1
fi

# Obtener la URL de la carátula
COVER_URL=$(playerctl -p "$PLAYER" metadata mpris:artUrl)

if [ -z "$COVER_URL" ]; then
    echo "No se pudo obtener la carátula de la canción actual."
    exit 1
fi

# Descargar la imagen temporalmente
wget -q -O /tmp/spotify_cover.png "$COVER_URL"

# Limpiar pantalla e imprimir info
clear
echo -e "\n   === ESCUCHANDO AHORA ==="
playerctl -p "$PLAYER" metadata --format "   Artistas: {{ artist }} \n   Canción: {{ title }}"
echo ""

# Renderizar en ASCII con Chafa
chafa --size=30x15 /tmp/spotify_cover.png
