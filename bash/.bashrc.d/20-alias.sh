# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# ALIAS (lo carga ~/.bashrc)
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# eza: ls con iconos y colores
if command -v eza >/dev/null; then
    alias ls='eza --icons=auto --group-directories-first'
    alias ll='eza -l --icons=auto --group-directories-first --git'
    alias la='eza -la --icons=auto --group-directories-first --git'
    alias lt='eza --tree --level=2 --icons=auto'
fi

# bat: cat con resaltado de sintaxis (sin paginar)
if command -v bat >/dev/null; then
    alias cat='bat --paging=never --style=plain'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Sistema
alias actualizar='sudo dnf upgrade --refresh && flatpak update -y'
alias recargar='source ~/.bashrc'

# Dotfiles
alias dots='cd ~/dotfiles && git status -sb'
