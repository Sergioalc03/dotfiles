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

    -- Fondo de pantalla POR DEFECTO (paquete f44-backgrounds-base).
    -- Para cambiarlo sin tocar esto: SUPER + W, o clic derecho en una
    -- imagen en Thunar -> «Poner como fondo» (se recuerda en
    -- ~/.local/state/fondo). Los .jxl se cargan vía glycin-loaders.
    wallpaper = "/usr/share/backgrounds/f44/default/f44-01-night.jxl",
}
