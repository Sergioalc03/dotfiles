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
| `bash`     | `~/.bashrc`, `~/.bash_profile` | Shell                                |
| `git`      | `~/.gitconfig`             | Identidad y opciones de Git              |

## Instalación

### 1. Paquetes (Fedora)

```sh
sudo dnf install hyprland waybar SwayNotificationCenter wlogout rofi kitty btop \
    hyprlock hypridle swaybg jxl-pixbuf-loader mate-polkit \
    thunar thunar-volman thunar-archive-plugin gvfs \
    xdg-desktop-portal-hyprland pipewire wireplumber pavucontrol \
    NetworkManager brightnessctl playerctl grim slurp wl-clipboard \
    fontawesome-6-free-fonts fontawesome-6-brands-fonts \
    greetd tuigreet stow git
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
stow hyprland waybar swaync wlogout rofi kitty btop bash git
```

Si ya existen archivos en el destino (por ejemplo el `.bashrc` por defecto de Fedora), Stow se negará a sobrescribirlos: muévelos o bórralos antes, o usa `stow --adopt` y revisa el `git diff`.

### 4. Cerrar sesión y volver a entrar

El agente polkit, swaybg, Waybar y swaync se lanzan desde `hyprland/.config/hypr/autostart.lua`.

## Personalizar

- Programas por defecto (terminal, gestor de archivos, lanzador) y ruta del **fondo de pantalla**: `hyprland/.config/hypr/programs.lua`.
- Atajos de teclado: `hyprland/.config/hypr/keybindings.lua`.
