#!/bin/bash
# ~/.config/waybar/scripts/network-menu.sh

ROFI="rofi -dmenu -p"

main_menu() {
    wifi_status=$(nmcli radio wifi)
    if [ "$wifi_status" = "enabled" ]; then
        toggle_label="Desactivar Wifi"
    else
        toggle_label="Activar Wifi"
    fi

    choice=$(printf "Redes disponibles\nRedes guardadas\n%s\nRefrescar" "$toggle_label" | $ROFI "Red")

    case "$choice" in
        "Redes disponibles") available_networks ;;
        "Redes guardadas") known_networks ;;
        "$toggle_label")
            if [ "$wifi_status" = "enabled" ]; then
                nmcli radio wifi off
            else
                nmcli radio wifi on
            fi
            ;;
        "Refrescar")
            nmcli dev wifi rescan
            main_menu
            ;;
    esac
}

available_networks() {
    # -t = salida "parseable", -f = solo estos campos. awk quita SSIDs duplicados.
    networks=$(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | awk -F: '!seen[$1]++')

    list=""
    while IFS=: read -r ssid signal security; do
        [ -z "$ssid" ] && continue
        # Si ya existe una conexión guardada con ese nombre, marcamos con ✓
        if nmcli -t -f NAME connection show | grep -qx "$ssid"; then
            saved="✓"
        else
            saved=" "
        fi
        list+="$saved $ssid ($signal%)\n"
    done <<< "$networks"

    chosen=$(echo -e "$list" | $ROFI "Redes disponibles")
    [ -z "$chosen" ] && return

    # Limpiamos el marcador y el porcentaje para quedarnos solo con el SSID real
    ssid=$(echo "$chosen" | sed -E 's/^. //; s/ \([0-9]+%\)$//')

    if nmcli -t -f NAME connection show | grep -qx "$ssid"; then
        # Ya la conocemos: conecta directo, sin pedir contraseña
        nmcli connection up "$ssid"
    else
        # Red nueva: pedimos contraseña (rofi -password oculta el texto tecleado)
        pass=$(rofi -dmenu -password -p "Contraseña para $ssid")
        if [ -z "$pass" ]; then
            nmcli dev wifi connect "$ssid"
        else
            nmcli dev wifi connect "$ssid" password "$pass"
        fi
    fi
}

known_networks() {
    conns=$(nmcli -t -f NAME,TYPE connection show | awk -F: '$2=="802-11-wireless"{print $1}')
    chosen=$(echo "$conns" | $ROFI "Redes guardadas")
    [ -z "$chosen" ] && return

    action=$(printf "Conectar\nOlvidar\nAlternar autoconexión" | $ROFI "Acción para $chosen")
    case "$action" in
        "Conectar") nmcli connection up "$chosen" ;;
        "Olvidar") nmcli connection delete "$chosen" ;;
        "Alternar autoconexión")
            current=$(nmcli -g connection.autoconnect connection show "$chosen")
            if [ "$current" = "yes" ]; then
                nmcli connection modify "$chosen" connection.autoconnect no
            else
                nmcli connection modify "$chosen" connection.autoconnect yes
            fi
            ;;
    esac
}

main_menu
