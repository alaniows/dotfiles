-- ~/.config/hypr/userprefs.lua
-- Migrado desde userprefs.conf (antes cargado con `source =` en hyprlang,
-- ahora con `require("userprefs")` desde hyprland.lua)

------------------------------
-- DECORACIÓN Y BLUR
------------------------------
hl.config({
  decoration = {
    rounding = 10,
    blur = {
      enabled           = true,
      size              = 8,   -- bajado de 12 → más suave para terminal y ventanas
      passes            = 3,   -- menos agresivo
      new_optimizations = true,
      xray              = false,
      special           = true,
    },
  },
})

------------------------------
-- SWAYNC (blur fuerte + contenido)
------------------------------
hl.layer_rule({ match = { namespace = "swaync-control-center" },      blur = true })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true })

hl.layer_rule({ match = { namespace = "swaync-control-center" },      ignore_alpha = 0.35 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, ignore_alpha = 0.35 })

hl.layer_rule({ match = { namespace = "swaync-control-center" },      animation = "slide right 90%" })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, animation = "slide right 90%" })

------------------------------
-- WAYBAR (sin blur, mantener sólida)
------------------------------
hl.layer_rule({ match = { namespace = "waybar" }, ignore_alpha = 1 })

return true
