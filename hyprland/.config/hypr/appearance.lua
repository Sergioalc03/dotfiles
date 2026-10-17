-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- LOOK AND FEEL                                          --
-- https://wiki.hypr.land/Configuring/Basics/Variables/    --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

hl.config({
    general = {
        -- Valores de Nebulix (Samtroulcode/dotfiles): más aire y bordes
        -- gruesos para que se luzca el degradado de colores.lua
        gaps_in  = 10,
        gaps_out = 20,

        border_size = 4,

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

        -- Sombra amplia y difusa (Nebulix). El color lo cambia colores.lua.
        shadow = {
            enabled      = true,
            range        = 60,
            render_power = 30,
            color        = "rgba(181825cc)",
            scale        = 0.97,
            offset       = { 1, 2 },
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

    -- Esconder el puntero tras 3 s sin moverlo
    cursor = {
        inactive_timeout = 3,
    },

    -- Pestañas de los grupos de ventanas; colores.lua los cambia
    group = {
        groupbar = {
            col = {
                active   = { colors = {"rgba(7aa2f7ee)", "rgba(bb9af7ee)"}, angle = 90 },
                inactive = "rgba(24283bdd)",
            },
        },
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
