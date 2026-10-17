# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# HERRAMIENTAS DE SHELL (lo carga ~/.bashrc)
# Cada una solo se activa si está instalada.
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# Historial más grande, sin duplicados y compartido entre terminales
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# fzf: CTRL+R historial, CTRL+T archivos, ALT+C carpetas
if command -v fzf >/dev/null; then
    eval "$(fzf --bash)"
fi

# zoxide: "z carpeta" salta a carpetas que ya visitaste, "zi" con fzf
if command -v zoxide >/dev/null; then
    eval "$(zoxide init bash)"
fi

# yazi: «y» abre el gestor de archivos y al salir (q) te deja en la
# carpeta donde estabas (Q sale sin cambiar de carpeta)
if command -v yazi >/dev/null; then
    y() {
        local tmp cwd
        tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        cwd="$(<"$tmp")"
        [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    }
fi

# starship: el prompt (config en ~/.config/starship.toml).
# Debe ir lo último porque modifica PROMPT_COMMAND.
if command -v starship >/dev/null; then
    eval "$(starship init bash)"
fi
