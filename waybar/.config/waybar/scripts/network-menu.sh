#!/bin/bash
# ~/.config/waybar/scripts/network-menu.sh
# Menú de red (clic en el icono de red de Waybar) con rofi + nmcli.
# Requiere: NetworkManager-wifi (sin él la tarjeta sale «sin gestión»),
#           rofi, libnotify, nm-connection-editor (Ajustes avanzados)

ROFI="rofi -dmenu -i -p"

aviso() {
    notify-send -a "Red" -i network-wireless "$@"
}

main_menu() {
    wifi_status=$(nmcli radio wifi)
    if [ "$wifi_status" = "enabled" ]; then
        toggle_label="Desactivar Wifi"
    else
        toggle_label="Activar Wifi"
    fi

    choice=$(printf "Redes disponibles\nRedes guardadas\nRed oculta\n%s\nRefrescar\nAjustes avanzados" \
        "$toggle_label" | $ROFI "Red")

    case "$choice" in
        "Redes disponibles") available_networks ;;
        "Redes guardadas") known_networks ;;
        "Red oculta") hidden_network ;;
        "$toggle_label")
            if [ "$wifi_status" = "enabled" ]; then
                nmcli radio wifi off
            else
                nmcli radio wifi on
            fi
            ;;
        "Refrescar")
            aviso "Buscando redes…"
            nmcli dev wifi rescan 2>/dev/null
            sleep 3
            available_networks
            ;;
        # Para eduroam (usuario + certificado), VPN, IP fija...
        "Ajustes avanzados") nm-connection-editor & ;;
    esac
}

# SSIDs de las redes wifi guardadas (el nombre de la conexión puede ser
# otro, p. ej. «Auto MiCasa», por eso se mira el SSID)
saved_ssids() {
    nmcli -t -f NAME,TYPE connection show | awk -F: '$2=="802-11-wireless"{print $1}' |
        while read -r name; do
            nmcli -g 802-11-wireless.ssid connection show "$name"
        done
}

available_networks() {
    # -e no: sin escapar los «:» del SSID; el SSID va el último para que
    # read se quede con el resto de la línea aunque los tenga.
    # awk quita duplicados (varios puntos de acceso con el mismo nombre;
    # nmcli ya los ordena por señal).
    networks=$(nmcli -t -e no -f IN-USE,SIGNAL,SECURITY,SSID dev wifi list | awk -F: '$4!="" && !seen[$4]++')
    if [ -z "$networks" ]; then
        aviso "No se ven redes wifi" "¿Está el wifi activado? Prueba «Refrescar»."
        return
    fi
    saved=$(saved_ssids)

    # ● conectada, ✓ guardada; 󰌾 con contraseña
    list=""
    while IFS=: read -r inuse signal security ssid; do
        if [ "$inuse" = "*" ]; then
            mark="●"
        elif grep -qxF "$ssid" <<< "$saved"; then
            mark="✓"
        else
            mark=" "
        fi
        [ -n "$security" ] && [ "$security" != "--" ] && lock="󰌾" || lock=" "
        list+="$mark $lock $ssid ($signal%)\n"
    done <<< "$networks"

    chosen=$(echo -en "$list" | $ROFI "Redes disponibles" -format i)
    [ -z "$chosen" ] && return

    # -format i devuelve el número de línea: así no hay que recortar el texto
    line=$(sed -n "$((chosen + 1))p" <<< "$networks")
    IFS=: read -r _ _ security ssid <<< "$line"

    if grep -qxF "$ssid" <<< "$saved"; then
        # Ya la conocemos: conecta con la contraseña guardada
        connect "$ssid"
    elif [ -z "$security" ] || [ "$security" = "--" ]; then
        connect "$ssid"
    else
        # Red nueva: pedimos contraseña (rofi -password oculta el texto tecleado)
        pass=$(rofi -dmenu -password -p "Contraseña para $ssid" < /dev/null)
        [ -z "$pass" ] && return
        connect "$ssid" password "$pass"
    fi
}

# connect <ssid> [password <clave>] [hidden yes]
connect() {
    local ssid="$1"
    shift
    local existed=no
    nmcli -t -f NAME connection show | grep -qxF "$ssid" && existed=yes

    aviso "Conectando a $ssid…"
    if out=$(nmcli dev wifi connect "$ssid" "$@" 2>&1); then
        aviso "Conectado a $ssid"
    else
        # nmcli guarda la red aunque falle (p. ej. contraseña mal): se borra
        # para que la próxima vez vuelva a pedirla
        [ "$existed" = no ] && nmcli connection delete "$ssid" >/dev/null 2>&1
        aviso -u critical "No se pudo conectar a $ssid" "$out"
    fi
}

hidden_network() {
    ssid=$(echo -n | $ROFI "Nombre de la red oculta")
    [ -z "$ssid" ] && return
    pass=$(rofi -dmenu -password -p "Contraseña (vacío si es abierta)" < /dev/null)
    if [ -z "$pass" ]; then
        connect "$ssid" hidden yes
    else
        connect "$ssid" password "$pass" hidden yes
    fi
}

known_networks() {
    conns=$(nmcli -t -f NAME,TYPE connection show | awk -F: '$2=="802-11-wireless"{print $1}')
    if [ -z "$conns" ]; then
        aviso "No hay redes wifi guardadas"
        return
    fi
    chosen=$(echo "$conns" | $ROFI "Redes guardadas")
    [ -z "$chosen" ] && return

    action=$(printf "Conectar\nOlvidar\nAlternar autoconexión" | $ROFI "Acción para $chosen")
    case "$action" in
        "Conectar")
            if out=$(nmcli connection up "$chosen" 2>&1); then
                aviso "Conectado a $chosen"
            else
                aviso -u critical "No se pudo conectar a $chosen" "$out"
            fi
            ;;
        "Olvidar") nmcli connection delete "$chosen" && aviso "Olvidada: $chosen" ;;
        "Alternar autoconexión")
            current=$(nmcli -g connection.autoconnect connection show "$chosen")
            if [ "$current" = "yes" ]; then
                nmcli connection modify "$chosen" connection.autoconnect no
                aviso "$chosen" "Ya no se conectará sola"
            else
                nmcli connection modify "$chosen" connection.autoconnect yes
                aviso "$chosen" "Se conectará sola cuando esté al alcance"
            fi
            ;;
    esac
}

main_menu
