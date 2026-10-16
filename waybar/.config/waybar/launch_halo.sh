#!/bin/bash

   CONFIG_PATH="$HOME/.steam/steam/steamapps/compatdata/1240440/pfx/drive_c/users/steamuser/AppData/Local/HaloInfinite/Settings/SpecOps/SpecOpsSettings.json"
   BACKUP_DIR="$HOME/.steam/steam/steamapps/compatdata/halo_config_backup"

   # 1. Si existe tu configuración, guardarla en un lugar seguro fuera del prefijo
   if [ -f "$CONFIG_PATH" ]; then
       mkdir -p "$BACKUP_DIR"
       cp "$CONFIG_PATH" "$BACKUP_DIR/SpecOpsSettings.json"
   fi

   # 2. Limpieza forzada
   pkill -9 -f HaloInfinite
   rm -rf "$HOME/.steam/steam/steamapps/compatdata/1240440"

   # 3. Lanzar el juego mediante Steam
   steam steam://run/1240440 &

   # 4. Esperar en segundo plano a que Steam cree la nueva estructura de carpetas
   TARGET_DIR="$HOME/.steam/steam/steamapps/compatdata/1240440/pfx/drive_c/users/steamuser/AppData/Local/HaloInfinite/Settings/SpecOps"
   
   while [ ! -d "$TARGET_DIR" ]; do
       sleep 0.5
   done

   # 5. Reinyectar tus configuraciones antes de que el juego llegue a la pantalla de carga
   if [ -f "$BACKUP_DIR/SpecOpsSettings.json" ]; then
       cp "$BACKUP_DIR/SpecOpsSettings.json" "$TARGET_DIR/"
   fi
