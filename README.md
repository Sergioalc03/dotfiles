# dotfiles

Configuración de mi escritorio **Hyprland** (config en Lua, 0.56+) sobre **Fedora 44**, gestionada con [GNU Stow](https://www.gnu.org/software/stow/).

## Contenido

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
    tmux fzf zoxide eza bat

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
stow hyprland waybar swaync wlogout rofi kitty btop bash git starship tmux gtk qt
```

Si ya existen archivos en el destino (por ejemplo el `.bashrc` por defecto de Fedora), Stow se negará a sobrescribirlos: muévelos o bórralos antes, o usa `stow --adopt` y revisa el `git diff`.

### 4. Cerrar sesión y volver a entrar

El agente polkit, swaybg, Waybar, swaync, hypridle, cliphist, swayosd, blueman y udiskie se lanzan desde `hyprland/.config/hypr/autostart.lua`.

## Atajos principales

| Atajo | Acción |
|---|---|
| `SUPER + L` | Bloquear pantalla (hyprlock) |
| `SUPER + SHIFT + V` | Historial del portapapeles |
| `Impr` | Captura de un área |
| `SHIFT + Impr` | Captura de toda la pantalla |
| `CTRL + Impr` | Captura de la ventana activa |
| `SUPER + Impr` | Captura de un área y editarla (swappy) |

Las capturas se guardan en `~/Imágenes/Capturas` y se copian al portapapeles. Inactividad (`hypridle.conf`): 2,5 min baja el brillo, 5 min bloquea, 5,5 min apaga la pantalla, 30 min suspende.

## Personalizar

- Programas por defecto (terminal, gestor de archivos, lanzador) y ruta del **fondo de pantalla**: `hyprland/.config/hypr/programs.lua`.
- Atajos de teclado: `hyprland/.config/hypr/keybindings.lua`.
