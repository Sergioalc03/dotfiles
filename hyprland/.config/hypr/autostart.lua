-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- AUTOSTART                                              --
-- https://wiki.hypr.land/Configuring/Basics/Autostart/    --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local programs = require("programs")

hl.on("hyprland.start", function()
    -- 1) IMPORTANTE: debe ir lo primero. Sin esto, dbus no sabe
    --    que estás en sesión Wayland/Hyprland y los
    --    xdg-desktop-portal fallan.
    --    Requiere: xdg-desktop-portal, xdg-desktop-portal-hyprland
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- 2) Agente de autenticación polkit.
    --    Requiere: mate-polkit (polkit-gnome ya no existe en Fedora 44)
    hl.exec_cmd("/usr/libexec/polkit-mate-authentication-agent-1")

    -- 3) Fondo de pantalla. Requiere: swaybg
    hl.exec_cmd("swaybg -m fill -i " .. programs.wallpaper)

    -- 4) Resto de la sesión
    hl.exec_cmd(programs.terminal)
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
end)
