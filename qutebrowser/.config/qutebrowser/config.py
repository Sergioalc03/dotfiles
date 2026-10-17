# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# QUTEBROWSER: navegador manejado con el teclado (estilo Vim)
# https://qutebrowser.org/doc/help/settings.html
# Lo básico: o = abrir URL, O = en pestaña nueva, f = seguir enlace
# (teclea las letras que aparecen), j/k = bajar/subir, H/L = atrás/
# adelante, J/K = pestaña siguiente/anterior, d = cerrar pestaña,
# u = reabrirla, : = comandos, ? = ayuda (:help).
# Recargar esta config sin cerrar: :config-source
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# Solo esta config: lo que cambies con :set no se guarda
config.load_autoconfig(False)

# Colores del fondo de pantalla (los genera wallust en colores.py;
# wallpaper.sh recarga qutebrowser al cambiar de fondo)
try:
    config.source("colores.py")
except Exception:
    pass

# Webs en modo oscuro si lo soportan (las que no, se ven normales;
# para forzarlo en todas: c.colors.webpage.darkmode.enabled = True)
c.colors.webpage.preferred_color_scheme = "dark"

# Idioma y fuente
c.content.headers.accept_language = "es-ES,es;q=0.9,en;q=0.8"
c.fonts.default_family = "JetBrainsMono Nerd Font"
c.fonts.default_size = "11pt"

# Página de inicio y buscadores: «o yt gatos» busca en YouTube
c.url.start_pages = ["https://duckduckgo.com"]
c.url.default_page = "https://duckduckgo.com"
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "g": "https://www.google.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "w": "https://es.wikipedia.org/w/index.php?search={}",
    "gh": "https://github.com/search?q={}",
    "fed": "https://packages.fedoraproject.org/search?query={}",
}

# Bloqueo de anuncios con listas de dominios (actualizar: :adblock-update)
c.content.blocking.enabled = True
c.content.blocking.method = "auto"

# Descargas y pestañas
c.downloads.location.directory = "~/Descargas"
c.downloads.location.prompt = False
c.downloads.remove_finished = 10000  # quitar de la barra a los 10 s
c.tabs.last_close = "default-page"   # cerrar la última no cierra la ventana
c.tabs.show = "multiple"             # barra de pestañas solo si hay más de una

# Editar campos de texto con CTRL+E en un editor de verdad
c.editor.command = ["kitty", "-e", "nano", "{file}"]

# Vídeos con mpv (necesita yt-dlp): «,m» la página actual, «,M» un enlace
config.bind(",m", "spawn --detach mpv {url}")
config.bind(",M", "hint links spawn --detach mpv {hint-url}")
