-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- LOOK AND FEEL                                          --
-- https://wiki.hypr.land/Configuring/Basics/Variables/    --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            -- Tokyo Night por si falta colores.lua (ver el final del archivo)
            active_border   = { colors = {"rgba(7aa2f7ee)", "rgba(bb9af7ee)"}, angle = 45 },
            inactive_border = "rgba(414868aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 3,
            vibrancy = 0.10,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})

-- Colores de borde sacados del fondo de pantalla. Los genera wallust
-- (wallust/templates/hyprland.lua) y scripts/wallpaper.sh los aplica
-- en caliente. pcall: si aún no existe, se quedan los de arriba.
pcall(dofile, os.getenv("HOME") .. "/.config/hypr/colores.lua")
