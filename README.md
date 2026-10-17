# dotfiles

Configuración de mi escritorio **Hyprland** (config en Lua, 0.56+) sobre **Fedora 44**, gestionada con [GNU Stow](https://www.gnu.org/software/stow/).

## Contenido

Los colores **salen del fondo de pantalla** con [wallust](https://codeberg.org/explosion-mental/wallust): al elegir fondo (`SUPER + W`) se genera una paleta y se aplica a los bordes de ventana, Waybar, rofi, swaync, wlogout, swayosd, hyprlock, kitty y btop. Con color liso (sin imagen) se usa **Tokyo Night**. Más detalles en [Colores](#colores).

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
| `wallust`  | `~/.config/wallust`        | Paleta desde el fondo y sus plantillas   |
| `systemd`  | `~/.config/systemd/user`   | `hyprland-session.target` (activa la sesión gráfica para los portales) |

`systemd` se enlaza con `stow --no-folding` para que `~/.config/systemd` siga siendo una carpeta real (si no, `systemctl --user enable` escribiría dentro del repo).

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

1. Activa los COPR `ashbuk/Hyprland-Fedora` (Hyprland 0.56 con config Lua, hyprlock, hypridle, portal), `atim/starship`, `erikreider/swayosd` y `scottames/awww`, e instala con dnf los paquetes que falten (lista en `PACKAGES` dentro del script).
2. Habilita `bluetooth` y `power-profiles-daemon`.
3. Instala **JetBrainsMono Nerd Font** en `~/.local/share/fonts` y **wallust** (binario oficial) en `~/.local/bin`; ninguno está en los repos de Fedora.
4. Enlaza todos los paquetes con Stow. Los archivos reales que estorben (como el `.bashrc` que trae Fedora) se mueven antes a `~/.dotfiles-respaldo/<fecha>/`. Después genera la paleta inicial (Tokyo Night).
5. Carpetas de usuario en español (`~/.config/user-dirs.dirs`, incluida `~/Imágenes/Capturas`). Quita las carpetas en inglés solo si están vacías. Pone Thunar como gestor de archivos por defecto.
6. *(Pregunta)* greetd + tuigreet como pantalla de inicio de sesión (`/etc/greetd/config.toml`, sustituye a GDM/SDDM).
7. *(Pregunta, si el portátil lo admite)* Modo conservación de la batería: regla udev `/etc/udev/rules.d/90-bateria.rules` con `charge_types=Long_Life`.

Al terminar, cierra sesión y vuelve a entrar. El agente polkit, el fondo (awww), Waybar, swaync, hypridle, cliphist, swayosd, blueman, udiskie y `scripts/battery.sh` se lanzan desde `hyprland/.config/hypr/autostart.lua`.

### Manual

Solo los enlaces: `stow -t ~ hyprland waybar swaync wlogout rofi kitty btop bash git starship tmux gtk qt swayosd thunar wallust` y `stow -t ~ --no-folding systemd`, y luego `wallust theme Tokyo-Night -s` para crear los archivos de colores (sin ellos Waybar sale sin estilo). Si ya existen archivos en el destino, Stow se negará a sobrescribirlos: muévelos antes, o usa `stow --adopt` y revisa el `git diff`.

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

Waybar (al estilo Nebulix: barra flotante con bloques, colores del fondo):

- **Izquierda**: lanzador de aplicaciones, accesos directos (Firefox, Thunar, kitty, Obsidian; se cambian en `modules/left/quicklinks.jsonc`) y bandeja.
- **Centro**: workspaces como puntos y lo que esté sonando (cualquier reproductor MPRIS: clic pausa, clic derecho o rueda cambia de canción).
- **Derecha**: volumen y micrófono (rueda para subir/bajar, clic derecho silencia), CPU (al pasar el ratón despliega RAM, disco y temperatura; clic abre btop), red, bluetooth, batería, evitar suspensión, reloj, notificaciones y apagado.

Batería (`scripts/battery.sh`): al desenchufar pasa al perfil `power-saver` y al enchufar a `balanced`; avisa al 20 % y al 10 %, y al 5 % suspende tras 60 s. Clic en el icono de perfil de Waybar (despliega al pasar por la batería) para cambiarlo a mano.

Reglas de ventana (`window_rules.lua`): diálogos de abrir/guardar y herramientas pequeñas flotan centradas, el modo imagen en imagen de Firefox queda fijado en una esquina, Firefox abre en el workspace 2 y no se suspende mientras haya algo a pantalla completa.

## Personalizar

- Programas por defecto (terminal, gestor de archivos, lanzador) y **fondo por defecto**: `hyprland/.config/hypr/programs.lua`.
- **Fondo de pantalla**: `SUPER + W` muestra miniaturas de las imágenes de `~/Imágenes/Fondos` y `/usr/share/backgrounds`. También vale clic derecho en una imagen en Thunar → *Poner como fondo*. La elección se recuerda en `~/.local/state/fondo`. Si la imagen ya no existe, se pinta el color de fondo de Tokyo Night. Cada cambio regenera los colores (ver abajo). El fondo lo pinta **awww** con una transición en barrido (`TRANSICION` al principio de `scripts/wallpaper.sh`; tipos en `awww img --help`); al iniciar sesión aparece sin transición. Los `.jxl` se convierten a PNG en `~/.cache/fondo` porque ni awww ni wallust los leen.
- **Clic derecho en Thunar**: *Crear carpeta*, *Crear documento* (archivo vacío o una plantilla de `~/Plantillas`), *Abrir terminal aquí* (kitty). Para añadir plantillas, deja cualquier archivo en `~/Plantillas`.
- Atajos de teclado: `hyprland/.config/hypr/keybindings.lua`.
- Aspecto de las ventanas (huecos 10/20, borde de 4 px, sombra amplia, desenfoque, puntero que se oculta a los 3 s): `appearance.lua`. Animaciones: `animations.lua`, con dos estilos: `ESTILO = "ja"` (el de Nebulix, deslizando con rebote) o `"suave"` (el original).

## Colores

`hypr/scripts/wallpaper.sh` llama a `wallust run <imagen>` al cambiar de fondo. wallust rellena las plantillas de `wallust/.config/wallust/templates/` y escribe un archivo `colores.*` en la carpeta de cada programa:

| Plantilla | Archivo generado | Lo usa |
| --- | --- | --- |
| `hyprland.lua` | `~/.config/hypr/colores.lua` | `appearance.lua` (bordes, sombra, grupos) |
| `hyprlock.conf` | `~/.config/hypr/hyprlock-colores.conf` | `hyprlock.conf` |
| `gtk.css` | `~/.config/{waybar,wlogout,swayosd}/colores.css` | sus `style.css` |
| `swaync.css` | `~/.config/swaync/colores.css` | `swaync/style.css` |
| `rofi.rasi` | `~/.config/rofi/colores.rasi` | `rofi/tema.rasi` |
| `kitty.conf` | `~/.config/kitty/colores.conf` | `kitty.conf` |
| `btop.theme` | `~/.config/btop/themes/wallust.theme` | `btop.conf` |

Los archivos generados están en `.gitignore`: para cambiar un color se edita la **plantilla**, no el `colores.*`. Hyprland, Waybar, swaync, kitty y swayosd se recargan solos; rofi, wlogout, hyprlock y btop leen la paleta al abrirse.

- Nombres en CSS/rofi: `@bg`, `@surface`, `@overlay`, `@fg`, `@fg-dim`, `@acento` (= `color4`), `@acento2` (= `color5`), `@c1`…`@c6`. `@red` y `@orange` son fijos para que los avisos (batería crítica, apagar) sigan siendo rojos.
- Volver a Tokyo Night sin cambiar el fondo: `wallust theme Tokyo-Night -s` (o cualquier otro de `wallust theme list`).
- Otra paleta para la misma imagen: `palette` en `wallust.toml` (p. ej. `harddark`, `softdark`) o a mano `wallust run -p harddark <imagen>`.

