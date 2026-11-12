#!/usr/bin/env bash
# Panel de control estilo macOS: volumen, brillo, WiFi, Bluetooth y bloqueo. Requiere yad.
command -v yad >/dev/null || { notify-send "Centro de control" "Falta yad: sudo apt install yad"; exit 1; }

vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oE '[0-9]+%' | head -1 | tr -d %)
if command -v brightnessctl >/dev/null; then
  bri=$(( $(brightnessctl g) * 100 / $(brightnessctl m) )); hay_bri=1
else bri=0; hay_bri=0; fi
[[ $(nmcli radio wifi) == enabled ]] && wifi=TRUE || wifi=FALSE
rfkill list bluetooth | grep -q "Soft blocked: no" && bt=TRUE || bt=FALSE
bat=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)

res=$(yad --form --title="Centro de control" --width=320 --on-top --skip-taskbar --undecorated --borders=14 \
  --text="<b>Batería: ${bat:-?}%</b>" \
  --field="Volumen:SCL" "$vol" \
  --field="Brillo:SCL" "$bri" \
  --field="WiFi:CHK" "$wifi" \
  --field="Bluetooth:CHK" "$bt" \
  --button="Bloquear!system-lock-screen:2" --button="Aplicar!gtk-apply:0" --button="Cerrar!gtk-close:1")
rc=$?
[[ $rc == 2 ]] && { light-locker-command -l; exit 0; }
[[ $rc != 0 ]] && exit 0

IFS='|' read -r v b w t _ <<< "$res"
pactl set-sink-volume @DEFAULT_SINK@ "${v%%.*}%"
(( hay_bri )) && brightnessctl -q s "${b%%.*}%"
[[ $w == TRUE ]] && nmcli radio wifi on || nmcli radio wifi off
[[ $t == TRUE ]] && rfkill unblock bluetooth || rfkill block bluetooth
