#!/bin/bash
# Espera a que exista cualquier socket de Hyprland
sleep 3
pkill waybar 2>/dev/null
waybar -c ~/.config/waybar/configs/'[TOP] 0-Ja-0 Been modified' -s ~/.config/waybar/style/islands.css &
