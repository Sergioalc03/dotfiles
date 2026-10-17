#!/usr/bin/env bash
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# FONDO DE PANTALLA (SUPER + W)
# Uso: wallpaper.sh                        -> elegir con rofi (miniaturas)
#      wallpaper.sh <imagen>               -> ponerla de fondo (Thunar: «Poner como fondo»)
#      wallpaper.sh restaurar <por-defecto> -> al iniciar (autostart.lua): el último
#                                             elegido, o el de programs.lua
# Busca imágenes en ~/Imágenes/Fondos y /usr/share/backgrounds.
# El fondo lo pinta awww con una transición (al iniciar sesión, sin ella).
# Si la imagen no existe pinta un color liso en vez de dejar basura.
#
# Además saca la paleta del fondo con wallust y recarga Hyprland,
# Waybar, swaync, kitty, tmux y swayosd (rofi, wlogout, hyprlock y btop
# la leen al abrirse; starship usa los colores de kitty). Con color
# liso se usa el tema Tokyo Night.
# Requiere: awww (COPR scottames/awww), rofi, libnotify, wallust,
#           libjxl-utils (djxl, .jxl)
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# wallust está en ~/.local/bin, que no está en el PATH de Hyprland
PATH="$HOME/.local/bin:$PATH"

ESTADO="${XDG_STATE_HOME:-$HOME/.local/state}/fondo"
CARPETAS=("$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Imágenes")/Fondos" /usr/share/backgrounds)
COLOR="1a1b26" # Tokyo Night (awww clear lo quiere sin #)
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/fondo"

# Transición al elegir fondo (awww img --help para ver más tipos:
# grow, outer, wave, fade, random...)
TRANSICION=(--transition-type wipe --transition-angle 30
            --transition-fps 60 --transition-duration 1)

# Ni awww ni wallust leen .jxl (los fondos de Fedora): se pasan a PNG
# una vez y se usa esa copia. Devuelve la ruta que sí pueden leer.
legible() {
    local img="$1"
    if [[ "$img" == *.[jJ][xX][lL] ]] && command -v djxl >/dev/null; then
        local png="$CACHE/$(basename "${img%.*}").png"
        mkdir -p "$CACHE"
        [[ -f "$png" ]] || djxl "$img" "$png" >/dev/null 2>&1
        img="$png"
    fi
    printf '%s\n' "$img"
}

# Paleta nueva con wallust -> plantillas en ~/.config/*/colores.*
colores() {
    local img
    img="$(legible "$1")"
    # -s: sin secuencias de escape a las terminales (kitty se recarga abajo)
    if [[ ! -f "$img" ]] || ! wallust run -s -q "$img"; then
        wallust theme Tokyo-Night -s -q
    fi
}

# Aplicar la paleta a lo que ya está abierto
recargar() {
    hyprctl eval 'dofile(os.getenv("HOME") .. "/.config/hypr/colores.lua")' >/dev/null
    pkill -USR2 -x waybar
    swaync-client --reload-css >/dev/null 2>&1
    pkill -USR1 -x kitty
    tmux source-file -q ~/.config/tmux/colores.conf 2>/dev/null
    if pkill -x swayosd-server; then
        swayosd-server >/dev/null 2>&1 &
        disown
    fi
}

# poner <imagen> [sin-transicion]
poner() {
    local img
    img="$(legible "$1")"
    if ! awww query >/dev/null 2>&1; then
        awww-daemon >/dev/null 2>&1 &
        disown
        for _ in {1..50}; do
            awww query >/dev/null 2>&1 && break
            sleep 0.1
        done
    fi
    # Quedaba de antes de awww: si sigue vivo tapa o parpadea
    pkill -x swaybg
    if [[ ! -f "$img" ]]; then
        awww clear "$COLOR"
    elif [[ -n "${2:-}" ]]; then
        awww img "$img" --transition-type none
    else
        awww img "$img" "${TRANSICION[@]}"
    fi
}

case "${1:-}" in
    restaurar)
        img="$(cat "$ESTADO" 2>/dev/null)"
        [[ -f "$img" ]] || img="${2:-}"
        poner "$img" sin-transicion
        # Al iniciar sesión la paleta ya está de la vez anterior; solo
        # generarla si falta (primer arranque tras install.sh).
        if [[ ! -f "$HOME/.config/waybar/colores.css" ]]; then
            colores "$img"
            recargar
        fi
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
        colores "${imgs[$i]}"
        recargar
        ;;
    *)
        img="$(realpath "$1")"
        [[ -f "$img" ]] || { notify-send -a "Fondo" "No existe: $1"; exit 1; }
        mkdir -p "$(dirname "$ESTADO")"
        printf '%s\n' "$img" > "$ESTADO"
        poner "$img"
        colores "$img"
        recargar
        ;;
esac
