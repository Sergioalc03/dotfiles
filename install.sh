#!/usr/bin/env bash
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# INSTALADOR DE LOS DOTFILES (Fedora 44 + Hyprland)
#
# Deja el escritorio listo en una instalación limpia:
#   1. COPRs y paquetes de dnf
#   2. Servicios (bluetooth, perfiles de energía)
#   3. Fuente JetBrainsMono Nerd Font y wallust (colores del fondo)
#   4. Enlaces con GNU Stow (respalda lo que estorbe) y paleta inicial
#   5. Ajustes de usuario: carpetas en español, Thunar por defecto
#   6. greetd + tuigreet como pantalla de inicio de sesión (pregunta)
#   7. Modo conservación de la batería con udev (pregunta)
#
# Se puede ejecutar varias veces: lo que ya está hecho se salta.
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
set -euo pipefail

DOTFILES="$(cd "$(dirname "$(realpath "$0")")" && pwd)"
BACKUP="$HOME/.dotfiles-respaldo/$(date +%Y%m%d-%H%M%S)"

STOW_PKGS=(hyprland waybar swaync wlogout rofi kitty btop bash git starship tmux gtk qt swayosd thunar wallust)

COPRS=(
    ashbuk/Hyprland-Fedora   # hyprland 0.56 (config Lua), hyprlock, hypridle, portal
    atim/starship
    erikreider/swayosd
    scottames/awww           # fondo de pantalla con transiciones (antes swww)
)

PACKAGES=(
    # Compositor y escritorio
    hyprland hyprlock hypridle xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
    waybar SwayNotificationCenter wlogout rofi awww swayosd mate-polkit
    greetd tuigreet dbus-tools glycin-loaders
    # Aplicaciones
    kitty btop Thunar thunar-volman thunar-archive-plugin gvfs pavucontrol
    # Iconos en el escritorio (scripts/desktop.sh)
    pcmanfm-qt
    # Audio, red, energía, hardware (alsa-sof-firmware: sin él los
    # portátiles Intel recientes no tienen tarjeta de sonido)
    pipewire wireplumber alsa-sof-firmware NetworkManager power-profiles-daemon
    # Wifi: sin NetworkManager-wifi la tarjeta sale «sin gestión»;
    # nm-connection-editor para eduroam, VPN, IP fija (menú de red de Waybar)
    NetworkManager-wifi nm-connection-editor
    brightnessctl playerctl blueman udiskie
    # Capturas y portapapeles
    grim slurp swappy wl-clipboard cliphist
    # Utilidades usadas por los scripts
    jq libnotify curl
    # djxl: wallust no lee .jxl (los fondos de Fedora), wallpaper.sh los convierte
    libjxl-utils
    # Tema (los fondos de Fedora: programs.lua usa uno por defecto)
    "f$(rpm -E %fedora)-backgrounds-base"
    adw-gtk3-theme papirus-icon-theme breeze-cursor-theme qt6ct
    fontawesome-6-free-fonts fontawesome-6-brands-fonts
    # Terminal
    starship tmux fzf zoxide eza bat
    # Este instalador
    stow git
)

NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.tar.xz"

# wallust no está en Fedora ni en un COPR al día: binario estático oficial
WALLUST_VERSION="3.5.2"
WALLUST_URL="https://codeberg.org/explosion-mental/wallust/releases/download/$WALLUST_VERSION/wallust-$WALLUST_VERSION-x86_64-unknown-linux-musl.tar.gz"

# -- Opciones ------------------------------------------------
SI=0          # responder "sí" a todo
SISTEMA=1     # pasos con sudo
SIMULAR=0     # solo mostrar lo que haría

uso() {
    cat <<EOF
Uso: ./install.sh [opciones]

  -y, --si          No preguntar (acepta greetd y la regla de batería)
  --sin-sistema     Saltar los pasos con sudo (paquetes, servicios,
                    greetd, udev): solo fuente, stow y ajustes de usuario
  -n, --simular     Mostrar lo que se haría sin cambiar nada
  -h, --ayuda       Esta ayuda
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--si)       SI=1 ;;
        --sin-sistema) SISTEMA=0 ;;
        -n|--simular)  SIMULAR=1 ;;
        -h|--ayuda)    uso; exit 0 ;;
        *) echo "Opción desconocida: $1" >&2; uso >&2; exit 1 ;;
    esac
    shift
done

# -- Utilidades ----------------------------------------------
azul=$'\e[34m'; verde=$'\e[32m'; amarillo=$'\e[33m'; rojo=$'\e[31m'; normal=$'\e[0m'

paso()  { printf '\n%s==> %s%s\n' "$azul" "$*" "$normal"; }
ok()    { printf '  %s✓%s %s\n' "$verde" "$normal" "$*"; }
aviso() { printf '  %s!%s %s\n' "$amarillo" "$normal" "$*"; }
error() { printf '%sError:%s %s\n' "$rojo" "$normal" "$*" >&2; exit 1; }

# Ejecuta un comando, o solo lo muestra con --simular.
run() {
    if (( SIMULAR )); then
        printf '  [simular] %s\n' "$*"
    else
        "$@"
    fi
}

# Escribe la entrada estándar en un archivo (con sudo si se pide),
# respaldando el anterior si existía y era distinto.
escribir() {
    local destino="$1" sudo="${2:-}" contenido
    contenido="$(cat)"
    if [[ -f "$destino" ]] && [[ "$(cat "$destino")" == "$contenido" ]]; then
        ok "$destino ya está al día"
        return
    fi
    if (( SIMULAR )); then
        printf '  [simular] escribir %s\n' "$destino"
        return
    fi
    if [[ -e "$destino" ]]; then
        $sudo cp -a "$destino" "$destino.bak-$(date +%Y%m%d-%H%M%S)"
        aviso "respaldado $destino (.bak-*)"
    fi
    printf '%s\n' "$contenido" | $sudo tee "$destino" >/dev/null
    ok "escrito $destino"
}

preguntar() {
    (( SI )) && return 0
    local r
    read -rp "  $1 [s/N] " r
    [[ "$r" =~ ^[sSyY] ]]
}

# -- Comprobaciones ------------------------------------------
[[ $EUID -ne 0 ]] || error "ejecútalo como tu usuario, no como root (pedirá sudo cuando haga falta)"
grep -q '^ID=fedora' /etc/os-release || aviso "esto está pensado para Fedora; puede fallar en otra distro"
(( SIMULAR )) && aviso "modo simulación: no se cambia nada"

# -- 1. Paquetes ---------------------------------------------
if (( SISTEMA )); then
    paso "Repositorios COPR y paquetes"
    rpm -q dnf5-plugins >/dev/null 2>&1 || run sudo dnf install -y dnf5-plugins
    habilitados="$(dnf copr list 2>/dev/null || true)"
    for copr in "${COPRS[@]}"; do
        if grep -q "/$copr\$" <<<"$habilitados"; then
            ok "COPR $copr ya habilitado"
        else
            run sudo dnf copr enable -y "$copr"
        fi
    done

    faltan=()
    for p in "${PACKAGES[@]}"; do
        rpm -q "$p" >/dev/null 2>&1 || faltan+=("$p")
    done
    if (( ${#faltan[@]} )); then
        run sudo dnf install -y "${faltan[@]}"
    else
        ok "todos los paquetes instalados"
    fi

    # -- 2. Servicios ----------------------------------------
    paso "Servicios"
    for s in bluetooth power-profiles-daemon; do
        if systemctl is-enabled -q "$s" 2>/dev/null; then
            ok "$s habilitado"
        else
            run sudo systemctl enable --now "$s"
        fi
    done
fi

# -- 3. Fuente -----------------------------------------------
paso "JetBrainsMono Nerd Font"
# Sin -q: con pipefail, grep -q cerraría la tubería y fc-list fallaría.
if fc-list : family | grep -i 'JetBrainsMono Nerd' >/dev/null; then
    ok "ya instalada"
else
    fuentes="$HOME/.local/share/fonts/JetBrainsMonoNerd"
    if (( SIMULAR )); then
        printf '  [simular] descargar %s en %s\n' "$NERD_FONT_URL" "$fuentes"
    else
        tmp="$(mktemp -d)"
        trap 'rm -rf "$tmp"' EXIT
        curl -fsSL -o "$tmp/JBM.tar.xz" "$NERD_FONT_URL"
        mkdir -p "$fuentes"
        tar -xJf "$tmp/JBM.tar.xz" -C "$fuentes" --wildcards '*.ttf'
        fc-cache -f "$HOME/.local/share/fonts"
        ok "instalada en $fuentes"
    fi
fi

paso "wallust $WALLUST_VERSION (colores sacados del fondo)"
if [[ "$("$HOME/.local/bin/wallust" --version 2>/dev/null)" == "wallust $WALLUST_VERSION "* ]]; then
    ok "ya instalado"
elif (( SIMULAR )); then
    printf '  [simular] descargar %s en ~/.local/bin\n' "$WALLUST_URL"
else
    mkdir -p "$HOME/.local/bin"
    curl -fsSL "$WALLUST_URL" | tar -xzf - -C "$HOME/.local/bin" wallust
    ok "instalado en ~/.local/bin/wallust"
fi

# -- 4. Stow -------------------------------------------------
paso "Enlazando configuraciones con Stow"
command -v stow >/dev/null || error "stow no está instalado (quita --sin-sistema o: sudo dnf install stow)"

# Mueve a $BACKUP los archivos reales que impedirían a Stow crear
# sus enlaces (p. ej. el .bashrc que trae Fedora).
respaldados=0
for pkg in "${STOW_PKGS[@]}" systemd; do
    while IFS= read -r rel; do
        destino="$HOME/$rel"
        fuente="$DOTFILES/$pkg/$rel"
        [[ -e "$destino" || -L "$destino" ]] || continue
        # Ya apunta a este repo (enlace directo o carpeta enlazada).
        [[ "$(realpath -m "$destino")" == "$(realpath -m "$fuente")" ]] && continue
        run mkdir -p "$BACKUP/$(dirname "$rel")"
        run mv "$destino" "$BACKUP/$rel"
        respaldados=$((respaldados + 1))
    done < <(cd "$DOTFILES/$pkg" && find . -mindepth 1 \( -type f -o -type l \) -printf '%P\n')
done
(( respaldados )) && aviso "$respaldados archivo(s) movidos a $BACKUP"

run stow -d "$DOTFILES" -t "$HOME" -R "${STOW_PKGS[@]}"
# systemd sin plegar: ~/.config/systemd debe ser una carpeta real, o
# `systemctl --user enable` escribiría sus enlaces dentro del repo.
run stow -d "$DOTFILES" -t "$HOME" -R --no-folding systemd
run systemctl --user daemon-reload
ok "paquetes enlazados: ${STOW_PKGS[*]} systemd"

# Los colores.* que importan Waybar, rofi, kitty... no están en el repo
# (los genera wallust). Sin ellos Waybar arrancaría sin estilo.
paso "Paleta de colores inicial (Tokyo Night)"
if [[ -f "$HOME/.config/waybar/colores.css" ]]; then
    ok "ya generada (cambia con el fondo: SUPER + W)"
else
    run "$HOME/.local/bin/wallust" theme Tokyo-Night -s -q
    ok "generada; al elegir fondo con SUPER + W se saca de la imagen"
fi

# -- 5. Ajustes de usuario -----------------------------------
paso "Carpetas de usuario en español"
escribir "$HOME/.config/user-dirs.dirs" <<'EOF'
# Carpetas de usuario (las usan Firefox, GTK, portales...)
XDG_DESKTOP_DIR="$HOME/Escritorio"
XDG_DOWNLOAD_DIR="$HOME/Descargas"
XDG_DOCUMENTS_DIR="$HOME/Documentos"
XDG_MUSIC_DIR="$HOME/Música"
XDG_PICTURES_DIR="$HOME/Imágenes"
XDG_VIDEOS_DIR="$HOME/Vídeos"
XDG_TEMPLATES_DIR="$HOME/Plantillas"
XDG_PUBLICSHARE_DIR="$HOME/Público"
EOF
for d in Escritorio Descargas Documentos Música Imágenes/Capturas Imágenes/Fondos Vídeos Plantillas Público; do
    [[ -d "$HOME/$d" ]] || run mkdir -p "$HOME/$d"
done
# Las carpetas en inglés solo se quitan si están vacías.
for d in Desktop Downloads Documents Music Pictures Videos Templates Public; do
    if [[ -d "$HOME/$d" ]]; then
        if rmdir "$HOME/$d" 2>/dev/null; then ok "quitada ~/$d (vacía)"
        else aviso "~/$d no está vacía; muévela tú a su carpeta en español"; fi
    fi
done

paso "Plantillas del clic derecho (Thunar > Crear documento)"
# Se copian en vez de enlazarse: así un documento creado desde una
# plantilla nunca puede acabar editando el archivo del repo.
for f in "$DOTFILES"/plantillas/Plantillas/*; do
    if [[ -e "$HOME/Plantillas/$(basename "$f")" ]]; then
        ok "$(basename "$f") ya existe"
    else
        run cp -p "$f" "$HOME/Plantillas/"
    fi
done

paso "Thunar como gestor de archivos por defecto"
if [[ "$(xdg-mime query default inode/directory 2>/dev/null)" == "thunar.desktop" ]]; then
    ok "ya lo es"
else
    run xdg-mime default thunar.desktop inode/directory
fi

# -- 6. greetd -----------------------------------------------
if (( SISTEMA )); then
    paso "Pantalla de inicio de sesión (greetd + tuigreet)"
    if preguntar "¿Usar greetd/tuigreet para iniciar Hyprland? (sustituye a GDM/SDDM)"; then
        if grep -q '^command = "tuigreet .*start-hyprland"' /etc/greetd/config.toml 2>/dev/null; then
            ok "/etc/greetd/config.toml ya lanza Hyprland"
        else
            escribir /etc/greetd/config.toml sudo <<'EOF'
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --cmd start-hyprland"
user = "greetd"
EOF
        fi
        if [[ "$(readlink -f /etc/systemd/system/display-manager.service 2>/dev/null)" == */greetd.service ]]; then
            ok "greetd ya es el gestor de sesión"
        else
            # --force sustituye el enlace display-manager.service anterior.
            run sudo systemctl enable --force greetd
        fi
        [[ "$(systemctl get-default)" == graphical.target ]] || run sudo systemctl set-default graphical.target
    else
        aviso "saltado"
    fi

    # -- 7. Batería ------------------------------------------
    paso "Modo conservación de la batería"
    bat=""
    for b in /sys/class/power_supply/BAT*; do
        [[ -f "$b/charge_types" ]] && grep -q 'Long_Life' "$b/charge_types" && bat="$(basename "$b")" && break
    done
    if [[ -z "$bat" ]]; then
        ok "este equipo no lo admite (no hay charge_types con Long_Life)"
    elif preguntar "¿Limitar la carga de $bat (Long_Life, alarga la vida de la batería)?"; then
        escribir /etc/udev/rules.d/90-bateria.rules sudo <<EOF
SUBSYSTEM=="power_supply", KERNEL=="$bat", ATTR{charge_types}="Long_Life"
EOF
        if grep -q '\[Long_Life\]' "/sys/class/power_supply/$bat/charge_types"; then
            ok "ya activo"
        else
            run sudo udevadm control --reload
            run sudo udevadm trigger --subsystem-match=power_supply
        fi
    else
        aviso "saltado"
    fi
fi

# -- Fin -----------------------------------------------------
paso "Listo"
echo "  Cierra sesión y vuelve a entrar (o reinicia) para arrancar Hyprland con todo."
