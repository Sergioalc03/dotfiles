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

    -- 5) Bloqueo por inactividad (config en hypridle.conf)
    hl.exec_cmd("hypridle")

    -- 6) Historial del portapapeles (texto e imágenes). Requiere: cliphist
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- 7) OSD de volumen/brillo. Requiere: swayosd (COPR erikreider/swayosd)
    hl.exec_cmd("swayosd-server")

    -- 8) Icono de bluetooth en la bandeja. Requiere: blueman
    hl.exec_cmd("blueman-applet")

    -- 9) Montar USB automáticamente + icono en la bandeja. Requiere: udiskie
    hl.exec_cmd("udiskie --smart-tray")
end)
