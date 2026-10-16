-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- HYPRLAND CONFIG - PUNTO DE ENTRADA                     --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--
-- Este archivo NO tiene lógica propia: solo importa el
-- resto de archivos .lua de esta misma carpeta. Cada uno
-- se encarga de una parte concreta de la config.
--
-- Orden importante: 'programs' debe cargarse antes que
-- 'autostart' y 'keybindings', porque ambos hacen
-- require("programs") para usar terminal/menu/fileManager.

require("monitors")     -- salida(s) de pantalla
require("programs")     -- terminal, file manager, launcher
require("environment")  -- env vars (incluye las de Wayland/XWayland)
require("appearance")   -- general, decoration, misc
require("animations")   -- curvas y animaciones
require("layouts")      -- dwindle, master, scrolling
require("input")        -- teclado, touchpad, gestos
require("autostart")    -- qué se lanza al iniciar sesión
require("keybindings")  -- atajos de teclado
require("window_rules") -- reglas de ventana/capa

-- Descomenta cuando quieras endurecer permisos (lee el archivo primero)
-- require("permissions")
