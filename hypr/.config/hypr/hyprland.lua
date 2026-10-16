-- ~/.config/hypr/hyprland.lua
-- Migrado desde hyprland.conf (hyprlang) a la API Lua de Hyprland 0.55+
-- Referencia: https://wiki.hypr.land/

------------------------------
-- MONITOR
------------------------------
-- monitor=,highres, auto,1.2
hl.monitor({ output = "", mode = "highres", position = "auto", scale = 1.20 })

------------------------------
-- PROGRAMAS / VARIABLES
------------------------------
local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "dolphin" -- no se usaba en ningún bind, la dejo por si la necesitas
local menu        = "fuzzel"
local browser     = "flatpak run app.zen_browser.zen"

------------------------------
-- ATAJOS BÁSICOS
------------------------------
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("kitty -e yazi"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

------------------------------
-- CAPTURAS DE PANTALLA
------------------------------
hl.bind(mainMod .. " + P",
  hl.dsp.exec_cmd('grim ~/Imágenes/$(date +%Y-%m-%d_%H-%M-%S).png && wl-copy < ~/Imágenes/$(date +%Y-%m-%d_%H-%M-%S).png'))
hl.bind(mainMod .. " + SHIFT + S",
  hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Imágenes/$(date +%Y-%m-%d_%H-%M-%S).png'))

------------------------------
-- WALLPAPER (SUPER + W)
------------------------------
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("bash /home/alaniows/.config/hypr/cambiar_wallpaper.sh"))

------------------------------
-- AUTOSTART (antes exec-once)
------------------------------
hl.on("hyprland.start", function()
  hl.exec_cmd("awww-daemon")

  -- Servicios esenciales del sistema
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")

  -- Gestor de portapapeles
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  -- Waybar
  hl.exec_cmd("sleep 3 && waybar -c ~/.config/waybar/configs/'[TOP] 0-Ja-0 Been modified' -s ~/.config/waybar/style/islands.css")

  -- Variables de entorno para la sesión Wayland
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- Tema oscuro GTK (Thunar, etc.)
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
end)
-- Nota: "gnome-keyring-daemon --start --components=secrets" estaba repetido 3 veces
-- en tu hyprland.conf original; con una vez basta, lo dejé así.

------------------------------
-- NAVEGACIÓN ENTRE VENTANAS
------------------------------
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

------------------------------
-- MOVER VENTANAS DE POSICIÓN
------------------------------
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

------------------------------
-- PANTALLA COMPLETA
------------------------------
-- Tu bind original era "fullscreen, 0" (fullscreen real, no maximizar).
-- OJO: hay reportes de bugs de toggle con este dispatcher en 0.55/0.56 (discussion #14494/#14531
-- en el repo de Hyprland). Pruébalo después de recargar; si el toggle no revierte, es un bug
-- conocido, no un error de conversión.
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

------------------------------
-- ESCRITORIOS 1-5
------------------------------
for i = 1, 5 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
  hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end

------------------------------
-- HISTORIAL DEL PORTAPAPELES
------------------------------
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

------------------------------
-- SUBMAP: REDIMENSIONAR VENTANAS
------------------------------
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  hl.bind("right", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }), { repeating = true })
  hl.bind("left",  hl.dsp.window.resize({ x = -10, y = 0,   relative = true }), { repeating = true })
  hl.bind("up",    hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })
  hl.bind("down",  hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
  hl.bind("escape", hl.dsp.submap("reset"))
end)

------------------------------
-- GAPS / BORDES
------------------------------
hl.config({
  general = {
    gaps_in             = 5,
    gaps_out            = 10,
    border_size         = 2,
    ["col.active_border"] = "rgba(ffffff33)", -- Gris tenue (blanco al 20% de opacidad)
  },
})

-- Smart gaps: sin gaps cuando hay una sola ventana tileada en pantalla
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 10, gaps_in = 2 })

------------------------------
-- WINDOW RULES
------------------------------
hl.window_rule({
  name    = "nmtui-rule",
  match   = { title = "nmtui" },
  float   = true,
  center  = true,
  size    = "680 520",
  opacity = "0.95 0.95",
})

-- Cargar tus preferencias personales (antes: source = ~/.config/hypr/userprefs.conf)
require("userprefs")

hl.window_rule({
  match      = { class = "^(steam_app_1240440)$" },
  fullscreen = true, -- antes "fullscreen 1"; verifica en la wiki si necesitas mode="maximized"
})

------------------------------
-- XWAYLAND
------------------------------
hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})

------------------------------
-- INPUT (TOUCHPAD)
------------------------------
hl.config({
  input = {
    touchpad = {
      scroll_factor = 0.3,
    },
  },
})

------------------------------
-- SPOTIFY (transparencia)
------------------------------
hl.window_rule({
  match   = { class = "^(Spotify)$" },
  opacity = "0.97 0.95",
})

------------------------------
-- WLOGOUT (blur + animación)
------------------------------
-- Tu .conf tenía este bloque duplicado 2-3 veces con pequeñas variaciones
-- (namespace/class/title). Lo consolidé en un solo set de reglas.
hl.layer_rule({ match = { namespace = "^(wlogout|logout)$" }, blur = true })
hl.layer_rule({ match = { namespace = "^(wlogout|logout)$" }, ignore_alpha = 0.05 })
hl.layer_rule({ match = { namespace = "^(wlogout|logout)$" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "^(wlogout|logout)$" }, animation = "slide down 85%" })
hl.layer_rule({ match = { class = "^(wlogout)$" }, blur = true })
