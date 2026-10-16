# dotfiles

Configuración de mi escritorio **Hyprland** (config en Lua, 0.56+) sobre **Fedora 44**, gestionada con [GNU Stow](https://www.gnu.org/software/stow/).

## Contenido

Todo usa la paleta **Tokyo Night** (`#1a1b26` fondo, `#c0caf5` texto, `#7aa2f7` azul, `#bb9af7` violeta…): kitty, Waybar, rofi (`tokyonight.rasi`), swaync, wlogout, swayosd, hyprlock y los bordes de ventana.

| Paquete    | Destino                    | Qué es                                   |
|------------|----------------------------|------------------------------------------|
| `hyprland` | `~/.config/hypr`           | Compositor (módulos Lua)                 |
| `waybar`   | `~/.config/waybar`         | Barra, módulos y scripts (menú de red)   |
| `swaync`   | `~/.config/swaync`         | Centro de notificaciones                 |
| `wlogout`  | `~/.config/wlogout`        | Menú de apagado                          |
| `rofi`     | `~/.config/rofi`           | Lanzador de aplicaciones                 |
| `kitty`    | `~/.config/kitty`          | Terminal                                 |
| `btop`     | `~/.config/btop`           | Monitor del sistema                      |
| `bash`     | `~/.bashrc`, `~/.bash_profile`, `~/.bashrc.d/` | Shell, alias, fzf/zoxide/starship |
| `starship` | `~/.config/starship.toml`  | Prompt de la terminal                    |
| `tmux`     | `~/.config/tmux`           | Multiplexor (prefijo `CTRL + a`)         |
| `gtk`      | `~/.config/gtk-3.0`, `gtk-4.0` | Tema oscuro GTK, iconos y cursor     |
| `qt`       | `~/.config/qt6ct`          | Tema de las apps Qt6                     |
| `git`      | `~/.gitconfig`             | Identidad y opciones de Git              |
| `swayosd`  | `~/.config/swayosd`        | Estilo del OSD de volumen/brillo         |

## Instalación

### 1. Paquetes (Fedora)

```sh
sudo dnf install hyprland waybar SwayNotificationCenter wlogout rofi kitty btop \
    hyprlock hypridle swaybg mate-polkit \
    thunar thunar-volman thunar-archive-plugin gvfs \
    xdg-desktop-portal-hyprland pipewire wireplumber pavucontrol \
    NetworkManager brightnessctl playerctl grim slurp wl-clipboard \
    swappy cliphist jq libnotify blueman udiskie \
    fontawesome-6-free-fonts fontawesome-6-brands-fonts \
    greetd tuigreet stow git \
    adw-gtk3-theme papirus-icon-theme breeze-cursor-theme qt6ct \
    tmux fzf zoxide eza bat power-profiles-daemon

# Prompt (no está en los repos oficiales)
sudo dnf copr enable atim/starship
sudo dnf install starship

# OSD de volumen/brillo (no está en los repos oficiales)
sudo dnf copr enable erikreider/swayosd
sudo dnf install swayosd
```

### 2. Fuente JetBrainsMono Nerd Font

No está en los repos de Fedora; se instala en el usuario:

```sh
curl -fsSL -o /tmp/JBM.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.tar.xz
mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
tar -xJf /tmp/JBM.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd --wildcards '*.ttf'
fc-cache -f ~/.local/share/fonts
```

### 3. Enlazar las configs

```sh
git clone git@github.com:Sergioalc03/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow hyprland waybar swaync wlogout rofi kitty btop bash git starship tmux gtk qt swayosd
```

Si ya existen archivos en el destino (por ejemplo el `.bashrc` por defecto de Fedora), Stow se negará a sobrescribirlos: muévelos o bórralos antes, o usa `stow --adopt` y revisa el `git diff`.

### 4. Cerrar sesión y volver a entrar

El agente polkit, swaybg, Waybar, swaync, hypridle, cliphist, swayosd, blueman, udiskie y `scripts/battery.sh` se lanzan desde `hyprland/.config/hypr/autostart.lua`.

## Atajos principales

| Atajo | Acción |
|---|---|
| `SUPER + L` | Bloquear pantalla (hyprlock) |
| `SUPER + SHIFT + V` | Historial del portapapeles |
| `Impr` | Captura de un área |
| `SHIFT + Impr` | Captura de toda la pantalla |
| `CTRL + Impr` | Captura de la ventana activa |
| `SUPER + Impr` | Captura de un área y editarla (swappy) |
| `SUPER + flechas` | Mover el foco |
| `SUPER + SHIFT + flechas` | Mover la ventana |
| `SUPER + ALT + flechas` | Redimensionar la ventana |
| `SUPER + F` / `SUPER + SHIFT + F` | Pantalla completa / maximizar |
| `SUPER + V` / `SUPER + SHIFT + C` | Flotante / centrar |
| `SUPER + SHIFT + P` | Fijar ventana flotante en todos los workspaces |
| `ALT + Tab` | Siguiente ventana del workspace |
| `SUPER + U` | Ir a la ventana urgente (o la anterior) |
| `SUPER + 1..0` / `SUPER + SHIFT + 1..0` | Ir a workspace / mover ventana allí |
| `SUPER + CTRL + ←/→` | Workspace anterior / siguiente |
| `SUPER + Tab` | Volver al último workspace |
| `SUPER + º` | Terminal desplegable |
| `SUPER + S` / `SUPER + SHIFT + S` | Scratchpad / mandar ventana al scratchpad |

Las capturas se guardan en `~/Imágenes/Capturas` y se copian al portapapeles. Inactividad (`hypridle.conf`): 2,5 min baja el brillo, 5 min bloquea, 5,5 min apaga la pantalla, 15 min suspende con batería / 30 min enchufado.

Batería (`scripts/battery.sh`): al desenchufar pasa al perfil `power-saver` y al enchufar a `balanced`; avisa al 20 % y al 10 %, y al 5 % suspende tras 60 s. Clic en el icono de perfil de Waybar (despliega al pasar por la batería) para cambiarlo a mano.

Reglas de ventana (`window_rules.lua`): diálogos de abrir/guardar y herramientas pequeñas flotan centradas, el modo imagen en imagen de Firefox queda fijado en una esquina, Firefox abre en el workspace 2 y no se suspende mientras haya algo a pantalla completa.

## Personalizar

- Programas por defecto (terminal, gestor de archivos, lanzador) y ruta del **fondo de pantalla**: `hyprland/.config/hypr/programs.lua`.
- Atajos de teclado: `hyprland/.config/hypr/keybindings.lua`.
