# macos-mint

Estilo macOS (WhiteSur) para Linux Mint XFCE: tema GTK/xfwm4, iconos y cursores, Plank (dock),
picom (blur y sombras), rofi (Spotlight), xfdashboard (Mission Control), gestos de 3 dedos,
redshift (Night Shift), fuentes Inter y JetBrains Mono, y fondos.

## Instalar (Mint XFCE recién instalado)
```bash
sudo apt install -y git
git clone <URL-DEL-REPO> macos-mint && cd macos-mint
./install.sh
```
Después cierra sesión y vuelve a entrar. Respalda tu `~/.config/xfce4` antes (el script ya lo hace).

## Notas
- Redshift usa coordenadas de Bolivia; edita `~/.config/redshift.conf` si estás en otra ciudad.
- Temas, iconos y fondos son de [vinceliuice](https://github.com/vinceliuice) (WhiteSur), con sus licencias.
