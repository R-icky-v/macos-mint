#!/usr/bin/env bash
# Instala el estilo macOS (WhiteSur) en Linux Mint XFCE. Uso: ./install.sh
set -euo pipefail
cd "$(dirname "$0")"

sudo apt update
sudo apt install -y plank picom rofi xfdashboard libinput-tools libinput-gestures xdotool redshift-gtk fonts-inter xfce4-clipman-plugin
sudo gpasswd -a "$USER" input   # libinput-gestures necesita este grupo (requiere reiniciar sesión)

# Respaldo de la config actual, por si quieres volver atrás
cp -r ~/.config/xfce4 ~/.config/xfce4.bak-$(date +%F) 2>/dev/null || true

mkdir -p ~/Imágenes/fondos && cp -r wallpapers/. ~/Imágenes/fondos/
cp -r home/. ~/
chmod +x ~/.local/bin/*.sh
# Las rutas absolutas se guardaron como __HOME__; se ajustan a este usuario
grep -rIl "__HOME__" ~/.config ~/.local/bin | xargs -r sed -i "s#__HOME__#$HOME#g"

fc-cache -f
dconf load /net/launchpad/plank/ < dconf/plank.dconf
echo "Listo. Cierra sesión y vuelve a entrar para aplicar todo."
