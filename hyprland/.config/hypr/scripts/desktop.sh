#!/usr/bin/env bash
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# ESCRITORIO CON ICONOS (autostart.lua)
# Muestra el contenido de ~/Escritorio (más Carpeta personal y
# Papelera) sobre el fondo, con clic derecho para crear carpetas,
# pegar, etc. Las carpetas se abren con el gestor por defecto (Thunar).
#
# Lo hace pcmanfm-qt en modo escritorio (capa «desktop» de Hyprland).
# Pinta su propio fondo encima del de awww, así que wallpaper.sh le
# pasa la misma imagen (y la transición de awww no se ve).
# Ajustes: clic derecho en el escritorio -> Preferencias del escritorio
# (se guardan en ~/.config/pcmanfm-qt/hyprland, fuera del repo porque
# pcmanfm-qt reescribe ese archivo).
# Uso: desktop.sh <fondo-por-defecto>   (el mismo que wallpaper.sh restaurar)
# Requiere: pcmanfm-qt
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

command -v pcmanfm-qt >/dev/null || exit 0

PERFIL="hyprland"
CONF="${XDG_CONFIG_HOME:-$HOME/.config}/pcmanfm-qt/$PERFIL/settings.conf"

# Primera vez: ajustes de partida (pcmanfm-qt completa el resto)
if [[ ! -f "$CONF" ]]; then
    mkdir -p "$(dirname "$CONF")"
    cat > "$CONF" <<'EOF'
[Behavior]
SingleClick=false
QuickExec=false

[Desktop]
OpenWithDefaultFileManager=true
DesktopShortcuts=Home, Trash
DesktopIconSize=48
BgColor=#1a1b26
FgColor=#ffffff
ShadowColor=#000000
WallpaperMode=zoom
SortFolderFirst=true
# izquierda, arriba, derecha, abajo: arriba deja sitio a Waybar
WorkAreaMargins=12, 52, 12, 12
EOF
fi

pcmanfm-qt --profile "$PERFIL" --desktop >/dev/null 2>&1 &
disown

# wallpaper.sh restaurar (autostart) puede llegar antes de que exista el
# escritorio: esperar a su capa y volver a pasarle el fondo actual.
for _ in {1..50}; do
    hyprctl layers | grep -q 'namespace: desktop' && break
    sleep 0.1
done
exec "$(dirname "$0")/wallpaper.sh" restaurar "${1:-}"
