#!/usr/bin/env bash
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# CAPTURAS DE PANTALLA
# Uso: screenshot.sh area|ventana|pantalla|editar
#   - Guarda en ~/Imágenes/Capturas y copia al portapapeles.
#   - "editar" abre la captura de un área en swappy.
# Requiere: grim, slurp, wl-clipboard, jq, swappy, libnotify
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

set -euo pipefail

dir="$HOME/Imágenes/Capturas"
mkdir -p "$dir"
file="$dir/captura_$(date +%Y-%m-%d_%H-%M-%S).png"

case "${1:-area}" in
    area|editar)
        # slurp devuelve error si cancelas con ESC: salimos sin más
        geom=$(slurp) || exit 0
        ;;
    ventana)
        geom=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        ;;
    pantalla)
        geom=""
        ;;
    *)
        echo "Uso: $0 area|ventana|pantalla|editar" >&2
        exit 1
        ;;
esac

if [[ "$1" == "editar" ]]; then
    grim -g "$geom" - | swappy -f - -o "$file"
    [[ -f "$file" ]] || exit 0
else
    grim ${geom:+-g "$geom"} "$file"
fi

wl-copy --type image/png < "$file"
notify-send -a "Captura" -i "$file" "Captura guardada" "$(basename "$file")"
