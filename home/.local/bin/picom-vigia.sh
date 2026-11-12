#!/usr/bin/env bash
# Mantiene picom vivo; tras 3 caídas en 5 min vuelve al compositor de XFCE y avisa.
CONF="$HOME/.config/picom/picom.conf"
caidas=()
while true; do
  if ! pgrep -x picom >/dev/null; then
    ahora=$(date +%s)
    caidas=("${caidas[@]}" "$ahora")
    recientes=()
    for t in "${caidas[@]}"; do (( ahora - t < 300 )) && recientes+=("$t"); done
    caidas=("${recientes[@]}")
    if (( ${#caidas[@]} >= 3 )); then
      xfconf-query -c xfwm4 -p /general/use_compositing -s true
      notify-send "picom" "Cayó 3 veces; vuelvo al compositor de XFCE." 2>/dev/null
      exit 0
    fi
    xfconf-query -c xfwm4 -p /general/use_compositing -s false
    picom --config "$CONF" >/dev/null 2>&1 &
    sleep 3
    pkill -x plank; sleep 1; setsid plank >/dev/null 2>&1 &
  fi
  sleep 10
done
