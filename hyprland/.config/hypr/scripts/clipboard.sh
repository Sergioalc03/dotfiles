#!/usr/bin/env bash
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# HISTORIAL DEL PORTAPAPELES (SUPER + SHIFT + V)
# El historial lo va guardando cliphist (ver autostart.lua).
# Uso: clipboard.sh        -> elegir y copiar
#      clipboard.sh borrar -> vaciar el historial
# Requiere: cliphist, wl-clipboard, rofi
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

if [[ "${1:-}" == "borrar" ]]; then
    cliphist wipe && notify-send -a "Portapapeles" "Historial vaciado"
    exit 0
fi

cliphist list \
    | rofi -dmenu -i -p "Portapapeles" -display-columns 2 \
    | cliphist decode \
    | wl-copy
