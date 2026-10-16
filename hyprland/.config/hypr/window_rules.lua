-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- WINDOW / LAYER RULES                                   --
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/ --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- 
hl.window_rule({
    name  = "btop-floating",
    match = { class = "^btop-float$" },

    float  = true,
    size   = "800 600",       -- ancho alto, en píxeles
    center = true,             -- lo centra en pantalla
    workspace = 1,          -- se abre siempre en el workspace 1
    -- silence = true, Para que no te mueva a ese workspace al abrirse.
})

hl.window_rule({
    name  = "volctl-floating",
    match = { class = "^pavucontrol$" },

    float  = true,
    size   = "400 300",
    move = "100%-820 20",
})

hl.window_rule({
    name  = "blueman-floating",
    match = { class = "^blueman-manager$" },

    float  = true,
    size   = "700 500",
    center = true,
})

hl.window_rule({
    name  = "swappy-floating",
    match = { class = "^swappy$" },

    float  = true,
    center = true,
})
