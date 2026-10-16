-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- MIS PROGRAMAS                                          --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- Se importa desde hyprland.lua con: require("programs")
-- Devuelve una tabla porque Lua no comparte variables `local`
-- entre archivos distintos.

return {
    terminal = "kitty",
    fileManager = "thunar",

    -- NOTA: en el original ponía "hyprlauncher"; al tener rofi
    -- instalado para usarlo lo cambie por:
    -- menu = "rofi -show drun"
    menu = "rofi -show drun",

    -- Fondo de pantalla (lo pinta swaybg desde autostart.lua).
    -- Los .jxl se cargan vía glycin-loaders (viene con Fedora 44).
    wallpaper = "/usr/share/backgrounds/f44/default/f44-01-night.jxl",
}
