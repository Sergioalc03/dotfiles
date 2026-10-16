-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- VARIABLES DE ENTORNO                                   --
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/   --
-- Environment-variables/                                  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Cursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "breeze_cursors") -- Requiere: breeze-cursor-theme

-- Identidad de sesión: sin esto, dbus/systemd no saben que es
-- una sesión Wayland con Hyprland, y los xdg-desktop-portal
-- (screen-share, file pickers nativos, etc.) no arrancan bien.
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Forzar a los toolkits a usar Wayland nativo, con fallback a
-- XWayland (";xcb" y ",x11") si una app concreta no lo soporta.
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Apps Qt6 con el tema de qt6ct (qt/.config/qt6ct/qt6ct.conf)
-- Requiere: qt6ct
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
