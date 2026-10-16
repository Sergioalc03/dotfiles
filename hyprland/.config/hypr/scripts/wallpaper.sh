#!/usr/bin/env bash
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# FONDO DE PANTALLA (SUPER + W)
# Uso: wallpaper.sh                        -> elegir con rofi (miniaturas)
#      wallpaper.sh <imagen>               -> ponerla de fondo (Thunar: «Poner como fondo»)
#      wallpaper.sh restaurar <por-defecto> -> al iniciar (autostart.lua): el último
#                                             elegido, o el de programs.lua
# Busca imágenes en ~/Imágenes/Fondos y /usr/share/backgrounds.
# Si la imagen no existe pinta un color liso en vez de dejar basura.
# Requiere: swaybg, rofi, libnotify
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

ESTADO="${XDG_STATE_HOME:-$HOME/.local/state}/fondo"
CARPETAS=("$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Imágenes")/Fondos" /usr/share/backgrounds)
COLOR="#1a1b26" # Tokyo Night

poner() {
    local img="$1" viejos
    viejos="$(pgrep -x swaybg)"
    if [[ -f "$img" ]]; then
        swaybg -m fill -i "$img" >/dev/null 2>&1 &
    else
        swaybg -c "$COLOR" >/dev/null 2>&1 &
    fi
    disown
    # Matar el anterior después de arrancar el nuevo evita un parpadeo.
    if [[ -n "$viejos" ]]; then
        sleep 0.3
        kill $viejos 2>/dev/null
    fi
}

case "${1:-}" in
    restaurar)
        img="$(cat "$ESTADO" 2>/dev/null)"
        [[ -f "$img" ]] || img="${2:-}"
        poner "$img"
        ;;
    "")
        mapfile -t imgs < <(find "${CARPETAS[@]}" -maxdepth 3 -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.jxl' \) \
            2>/dev/null | sort)
        if (( ${#imgs[@]} == 0 )); then
            notify-send -a "Fondo" "No hay imágenes" "Copia alguna a ${CARPETAS[0]}"
            exit 1
        fi
        i="$(for img in "${imgs[@]}"; do
                printf '%s\0icon\x1f%s\n' "$(basename "${img%.*}")" "$img"
             done | rofi -dmenu -i -p "Fondo" -format i -show-icons \
                -theme-str 'window { width: 60%; } listview { columns: 3; lines: 3; }
                            element { orientation: vertical; } element-icon { size: 9em; }
                            element-text { horizontal-align: 0.5; }')"
        [[ -n "$i" ]] || exit 0
        mkdir -p "$(dirname "$ESTADO")"
        printf '%s\n' "${imgs[$i]}" > "$ESTADO"
        poner "${imgs[$i]}"
        ;;
    *)
        img="$(realpath "$1")"
        [[ -f "$img" ]] || { notify-send -a "Fondo" "No existe: $1"; exit 1; }
        mkdir -p "$(dirname "$ESTADO")"
        printf '%s\n' "$img" > "$ESTADO"
        poner "$img"
        ;;
esac
