# Generado por wallust (templates/qutebrowser.py). NO editar: se
# sobrescribe al cambiar de fondo. Lo carga config.py.
# type: ignore  (config y c los define qutebrowser)

bg      = "{{background}}"
surface = "{{background | lighten(0.12)}}"
fg      = "{{foreground}}"
dim     = "{{foreground | blend(background)}}"
acento  = "{{color4}}"
acento2 = "{{color5}}"
ok      = "{{color2}}"
aviso   = "{{color3}}"
error   = "#f7768e"

# Barra de estado (abajo)
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.command.bg = bg
c.colors.statusbar.command.fg = fg
c.colors.statusbar.insert.bg = ok
c.colors.statusbar.insert.fg = bg
c.colors.statusbar.passthrough.bg = acento2
c.colors.statusbar.passthrough.fg = bg
c.colors.statusbar.caret.bg = acento2
c.colors.statusbar.caret.fg = bg
c.colors.statusbar.url.fg = fg
c.colors.statusbar.url.success.https.fg = ok
c.colors.statusbar.url.success.http.fg = aviso
c.colors.statusbar.url.error.fg = error
c.colors.statusbar.url.hover.fg = acento
c.colors.statusbar.progress.bg = acento

# Pestañas
c.colors.tabs.bar.bg = bg
c.colors.tabs.odd.bg = bg
c.colors.tabs.even.bg = bg
c.colors.tabs.odd.fg = dim
c.colors.tabs.even.fg = dim
c.colors.tabs.selected.odd.bg = acento
c.colors.tabs.selected.even.bg = acento
c.colors.tabs.selected.odd.fg = bg
c.colors.tabs.selected.even.fg = bg
c.colors.tabs.indicator.start = acento
c.colors.tabs.indicator.stop = ok
c.colors.tabs.indicator.error = error

# Lista de sugerencias (al pulsar o, :)
c.colors.completion.fg = fg
c.colors.completion.odd.bg = bg
c.colors.completion.even.bg = bg
c.colors.completion.category.bg = surface
c.colors.completion.category.fg = acento
c.colors.completion.category.border.top = surface
c.colors.completion.category.border.bottom = surface
c.colors.completion.item.selected.bg = acento
c.colors.completion.item.selected.fg = bg
c.colors.completion.item.selected.border.top = acento
c.colors.completion.item.selected.border.bottom = acento
c.colors.completion.item.selected.match.fg = bg
c.colors.completion.match.fg = acento2
c.colors.completion.scrollbar.bg = bg
c.colors.completion.scrollbar.fg = acento

# Letras para seguir enlaces (f)
c.colors.hints.bg = acento
c.colors.hints.fg = bg
c.colors.hints.match.fg = acento2
c.hints.border = "1px solid " + bg

# Avisos y descargas
c.colors.messages.info.bg = bg
c.colors.messages.info.fg = fg
c.colors.messages.info.border = surface
c.colors.messages.warning.bg = aviso
c.colors.messages.warning.fg = bg
c.colors.messages.warning.border = aviso
c.colors.messages.error.bg = error
c.colors.messages.error.fg = bg
c.colors.messages.error.border = error
c.colors.downloads.bar.bg = bg
c.colors.downloads.start.bg = acento
c.colors.downloads.stop.bg = ok
c.colors.downloads.error.bg = error
c.colors.prompts.bg = surface
c.colors.prompts.fg = fg
c.colors.prompts.selected.bg = acento
c.colors.prompts.selected.fg = bg

# Menú de clic derecho y fondo antes de cargar una web
c.colors.contextmenu.menu.bg = bg
c.colors.contextmenu.menu.fg = fg
c.colors.contextmenu.selected.bg = acento
c.colors.contextmenu.selected.fg = bg
c.colors.webpage.bg = bg
