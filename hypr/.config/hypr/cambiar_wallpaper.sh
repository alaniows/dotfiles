#!/bin/zsh

# Variables de entorno
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export WAYLAND_DISPLAY="wayland-1"

# === RUTA DE TUS WALLPAPERS ===
WALLPAPER_DIR="/home/alaniows/Imágenes/wpv21"

# Seleccionar wallpaper aleatorio
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.JPG" -o -name "*.PNG" \) | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
    echo "❌ No se encontraron imágenes en: $WALLPAPER_DIR"
    exit 1
fi

echo "✅ Wallpaper seleccionado: $WALLPAPER"

# Cambiar wallpaper (sintaxis correcta actual de awww)
awww img "$WALLPAPER" \
    --transition-type random \
    --transition-step 90 \
    --transition-fps 60

# Aplicar colores con pywal
wal -i "$WALLPAPER" -n -q

# Recargar componentes visuales
killall -SIGUSR2 waybar 2>/dev/null
swaync-client -R 2>/dev/null || killall -SIGUSR1 swaync 2>/dev/null

echo "🎨 Wallpaper y colores actualizados correctamente: $WALLPAPER"
