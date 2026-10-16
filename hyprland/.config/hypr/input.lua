-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- INPUT                                                  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

hl.config({
    input = {
        kb_layout  = "es",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = true, -- dos dedos arriba = bajar página
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Config por dispositivo (ratón concreto, etc.):
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
-- Nombres disponibles con: hyprctl devices
