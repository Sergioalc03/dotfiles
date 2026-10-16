-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- KEYBINDINGS                                            --
-- https://wiki.hypr.land/Configuring/Basics/Binds/        --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local programs = require("programs")

local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(programs.terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(programs.menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Bloquear pantalla (config en hyprlock.conf)
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))

-- Historial del portapapeles (scripts/clipboard.sh)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard.sh"))

-- Elegir fondo de pantalla (scripts/wallpaper.sh)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper.sh"))

-- Capturas de pantalla (scripts/screenshot.sh) -> ~/Imágenes/Capturas + portapapeles
hl.bind("Print",                   hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh area"))
hl.bind("SHIFT + Print",           hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh pantalla"))
hl.bind("CTRL + Print",            hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh ventana"))
hl.bind(mainMod .. " + Print",     hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh editar"))

-- -- Ventanas -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- SUPER + flechas          -> mover el foco
-- SUPER + SHIFT + flechas  -> mover la ventana
-- SUPER + ALT + flechas    -> redimensionar (mantener para repetir)
local paso = 40 -- píxeles por pulsación al redimensionar
local direcciones = {
    left  = { x = -paso, y = 0 },
    right = { x =  paso, y = 0 },
    up    = { x = 0, y = -paso },
    down  = { x = 0, y =  paso },
}
for dir, delta in pairs(direcciones) do
    hl.bind(mainMod .. " + " .. dir,            hl.dsp.focus({ direction = dir }))
    hl.bind(mainMod .. " + SHIFT + " .. dir,    hl.dsp.window.move({ direction = dir }))
    hl.bind(mainMod .. " + ALT + " .. dir,      hl.dsp.window.resize({ x = delta.x, y = delta.y, relative = true }), { repeating = true })
end

hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" })) -- deja ver la barra
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pin())  -- flotante visible en todos los workspaces
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.center())

-- ALT + Tab: siguiente ventana del workspace (y traerla delante si flota)
hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
-- SUPER + U: saltar a la ventana que pide atención (o a la anterior)
hl.bind(mainMod .. " + U", hl.dsp.focus({ urgent_or_last = true }))

-- -- Workspaces -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- SUPER + 1..0        -> ir (pulsar el actual vuelve al anterior)
-- SUPER + SHIFT + 1..0 -> mover la ventana allí
-- SUPER + CTRL + izq/der -> workspace anterior/siguiente
-- SUPER + Tab         -> volver al último workspace

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + CTRL + left",  hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + Tab",          hl.dsp.focus({ workspace = "previous" }))

-- Scratchpads (workspaces especiales que aparecen encima):
-- SUPER + S / SUPER + SHIFT + S -> "magic": guarda ventanas a mano
-- SUPER + º                     -> terminal desplegable (se crea solo,
--                                  ver window_rules.lua)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + masculine", hl.dsp.workspace.toggle_special("terminal"))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volumen y brillo con OSD en pantalla (swayosd-server, ver autostart.lua)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume +5"),         { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume -5"),         { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),  { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness +5"),            { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -5"),            { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
