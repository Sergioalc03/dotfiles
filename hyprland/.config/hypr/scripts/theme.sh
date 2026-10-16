#!/usr/bin/env bash
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# TEMA OSCURO para apps GTK4/libadwaita y portales
# Se lanza desde autostart.lua. Debe coincidir con
# gtk/.config/gtk-3.0/settings.ini
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

gs="gsettings set org.gnome.desktop.interface"
$gs color-scheme  'prefer-dark'
$gs gtk-theme     'adw-gtk3-dark'
$gs icon-theme    'Papirus-Dark'
$gs cursor-theme  'breeze_cursors'
$gs cursor-size   24
