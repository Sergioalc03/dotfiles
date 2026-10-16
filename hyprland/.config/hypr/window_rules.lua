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

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- FASE 6: diálogos flotantes, apps en workspaces fijos,
-- terminal desplegable
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Diálogos de abrir/guardar, progreso de copias, etc.
hl.window_rule({
    name  = "dialogos-flotantes",
    match = { title = "^(Abrir|Guardar|Seleccionar|Open|Save|Choose|Select).*" },

    float  = true,
    center = true,
})
hl.window_rule({
    name  = "thunar-progreso",
    match = { class = "^thunar$", title = "^(Progreso|Operación|File Operation).*" },

    float = true,
})

-- Herramientas pequeñas de configuración
hl.window_rule({
    name  = "herramientas-flotantes",
    match = { class = "^(nm-connection-editor|qt6ct|org\\.gnome\\.Calculator|xdg-desktop-portal-gtk|polkit-mate-authentication-agent-1)$" },

    float  = true,
    center = true,
})

-- Firefox: imagen en imagen siempre encima y en todos los workspaces
hl.window_rule({
    name  = "firefox-pip",
    match = { class = "^firefox$", title = "^(Picture-in-Picture|Imagen en imagen)$" },

    float = true,
    pin   = true,
    size  = "480 270",
    move  = "monitor_w-500 monitor_h-290",
})

-- No suspender/bloquear mientras haya algo a pantalla completa (vídeos)
hl.window_rule({
    name  = "idle-pantalla-completa",
    match = { class = ".*" },

    idle_inhibit = "fullscreen",
})

-- Apps en workspaces fijos. Añade/cambia a tu gusto
-- (la clase de una ventana: `hyprctl clients | grep class`)
hl.window_rule({
    name  = "firefox-ws2",
    match = { class = "^firefox$" },

    workspace = 2,
})

-- Terminal desplegable (SUPER + º): al abrir el workspace
-- especial "terminal" vacío, lanza un kitty con clase propia
hl.workspace_rule({
    workspace        = "special:terminal",
    on_created_empty = "kitty --class kitty-scratch",
})
hl.window_rule({
    name  = "kitty-scratch",
    match = { class = "^kitty-scratch$" },

    float  = true,
    size   = "monitor_w*0.7 monitor_h*0.6",
    center = true,
})
