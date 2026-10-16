#!/usr/bin/env bash
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# BATERÍA - avisos de batería baja y perfil de energía automático
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# Se lanza desde autostart.lua y se queda en bucle.
#  - Al desenchufar: perfil power-saver. Al enchufar: balanced.
#    (solo al cambiar; si eliges otro perfil a mano, se respeta)
#  - Avisos al 20 % y 10 %; al 5 % suspende tras 60 s si sigue
#    sin cargador.
# Requiere: power-profiles-daemon, libnotify (notify-send), swaync

BAT=/sys/class/power_supply/BAT1
AC=/sys/class/power_supply/ACAD

AVISO=20
CRITICO=10
SUSPENDER=5
PERFIL_BATERIA=power-saver
PERFIL_CORRIENTE=balanced
INTERVALO=30

# Una sola instancia (por si Hyprland se recarga)
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/battery-notify.lock"
flock -n 9 || exit 0

notificar() { # urgencia icono título cuerpo
    notify-send -u "$1" -i "$2" -a "Batería" \
        -h string:x-canonical-private-synchronous:bateria "$3" "$4"
}

ac_anterior=""
avisado=100   # último umbral avisado (se reinicia al enchufar)

while true; do
    capacidad=$(<"$BAT/capacity")
    ac=$(<"$AC/online")

    # Cambio de cargador (no en la primera vuelta)
    if [[ $ac != "$ac_anterior" ]]; then
        if [[ -n $ac_anterior ]]; then
            if [[ $ac == 1 ]]; then
                powerprofilesctl set "$PERFIL_CORRIENTE"
                notificar low ac-adapter "Cargador conectado" "Perfil: $PERFIL_CORRIENTE · $capacidad %"
            else
                powerprofilesctl set "$PERFIL_BATERIA"
                notificar low battery "Funcionando con batería" "Perfil: $PERFIL_BATERIA · $capacidad %"
            fi
        fi
        ac_anterior=$ac
        avisado=100
    fi

    if [[ $ac == 0 ]]; then
        if (( capacidad <= SUSPENDER && avisado > SUSPENDER )); then
            avisado=$SUSPENDER
            notificar critical battery-empty "Batería al $capacidad %" "Conecta el cargador. Suspendiendo en 60 s…"
            sleep 60
            [[ $(<"$AC/online") == 0 ]] && systemctl suspend
        elif (( capacidad <= CRITICO && avisado > CRITICO )); then
            avisado=$CRITICO
            notificar critical battery-caution "Batería muy baja: $capacidad %" "Conecta el cargador pronto."
        elif (( capacidad <= AVISO && avisado > AVISO )); then
            avisado=$AVISO
            notificar normal battery-low "Batería baja: $capacidad %" "Quedan unos minutos de autonomía."
        fi
    fi

    sleep "$INTERVALO"
done
