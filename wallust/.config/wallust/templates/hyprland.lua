-- Generado por wallust (templates/hyprland.lua). NO editar: se
-- sobrescribe al cambiar de fondo. Lo carga appearance.lua, y
-- wallpaper.sh lo aplica en caliente con `hyprctl eval`.

hl.config({
    general = {
        col = {
            active_border   = { colors = { "rgba({{color4 | strip}}ee)", "rgba({{color5 | strip}}ee)" }, angle = 45 },
            inactive_border = "rgba({{background | lighten(0.18) | strip}}aa)",
        },
    },

    decoration = {
        shadow = {
            color = "rgba({{background | darken(0.3) | strip}}cc)",
        },
    },

    group = {
        groupbar = {
            col = {
                active   = { colors = { "rgba({{color4 | strip}}ee)", "rgba({{color5 | strip}}ee)" }, angle = 90 },
                inactive = "rgba({{background | lighten(0.08) | strip}}dd)",
            },
        },
    },
})
