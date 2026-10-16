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
| `thunar`   | `~/.config/Thunar/uca.xml` | Acciones del clic derecho de Thunar      |

`plantillas/` no es un paquete de Stow: `install.sh` **copia** su contenido a `~/Plantillas` (Thunar → clic derecho → *Crear documento*). Se copia para que un documento nuevo nunca pueda editar el archivo del repo.

## Instalación

### Rápida: `install.sh`

```sh
sudo dnf install git stow
git clone https://github.com/Sergioalc03/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh            # pregunta antes de tocar greetd y la batería
```

Opciones: `-y` (no preguntar), `--sin-sistema` (sin sudo: solo fuente, stow y ajustes de usuario), `-n`/`--simular` (muestra lo que haría). Se puede repetir sin problema: lo que ya está hecho se salta.

Qué hace:

1. Activa los COPR `ashbuk/Hyprland-Fedora` (Hyprland 0.56 con config Lua, hyprlock, hypridle, portal), `atim/starship` y `erikreider/swayosd`, e instala con dnf los paquetes que falten (lista en `PACKAGES` dentro del script).
2. Habilita `bluetooth` y `power-profiles-daemon`.
3. Instala **JetBrainsMono Nerd Font** en `~/.local/share/fonts` (no está en los repos de Fedora).
4. Enlaza todos los paquetes con Stow. Los archivos reales que estorben (como el `.bashrc` que trae Fedora) se mueven antes a `~/.dotfiles-respaldo/<fecha>/`.
5. Carpetas de usuario en español (`~/.config/user-dirs.dirs`, incluida `~/Imágenes/Capturas`). Quita las carpetas en inglés solo si están vacías. Pone Thunar como gestor de archivos por defecto.
6. *(Pregunta)* greetd + tuigreet como pantalla de inicio de sesión (`/etc/greetd/config.toml`, sustituye a GDM/SDDM).
7. *(Pregunta, si el portátil lo admite)* Modo conservación de la batería: regla udev `/etc/udev/rules.d/90-bateria.rules` con `charge_types=Long_Life`.

Al terminar, cierra sesión y vuelve a entrar. El agente polkit, swaybg, Waybar, swaync, hypridle, cliphist, swayosd, blueman, udiskie y `scripts/battery.sh` se lanzan desde `hyprland/.config/hypr/autostart.lua`.

### Manual

Solo los enlaces: `stow -t ~ hyprland waybar swaync wlogout rofi kitty btop bash git starship tmux gtk qt swayosd thunar`. Si ya existen archivos en el destino, Stow se negará a sobrescribirlos: muévelos antes, o usa `stow --adopt` y revisa el `git diff`.

## Atajos principales

| Atajo | Acción |
|---|---|
| `SUPER + L` | Bloquear pantalla (hyprlock) |
| `SUPER + SHIFT + V` | Historial del portapapeles |
| `SUPER + W` | Elegir fondo de pantalla |
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

- Programas por defecto (terminal, gestor de archivos, lanzador) y **fondo por defecto**: `hyprland/.config/hypr/programs.lua`.
- **Fondo de pantalla**: `SUPER + W` muestra miniaturas de las imágenes de `~/Imágenes/Fondos` y `/usr/share/backgrounds`. También vale clic derecho en una imagen en Thunar → *Poner como fondo*. La elección se recuerda en `~/.local/state/fondo`. Si la imagen ya no existe, se pinta el color de fondo de Tokyo Night.
- **Clic derecho en Thunar**: *Crear carpeta*, *Crear documento* (archivo vacío o una plantilla de `~/Plantillas`), *Abrir terminal aquí* (kitty). Para añadir plantillas, deja cualquier archivo en `~/Plantillas`.
- Atajos de teclado: `hyprland/.config/hypr/keybindings.lua`.
