#!/bin/bash
# ~/.config/waybar/scripts/appmenu.sh

case "$1" in
 menu)
  rofi -show drun
  ;;
 options)
# Menu de opciones de configuración de rofi
  choice=$(printf "Editar config\nRecargar\nElegir Tema" | rofi -dmenu -p "Opciones de Rofi")
  case "$choice" in
   "Editar config")
     kitty -e nano ~/.config/rofi/config.rasi
     ;;
   "Recargar")
     pkill rofi
     ;;
   "Elegir Tema")
     printf "No disponible"
     ;;
   esac
   ;;
esac
