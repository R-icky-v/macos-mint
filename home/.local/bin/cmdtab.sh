#!/bin/bash
# Selector tipo Cmd+Tab: abre rofi y confirma solo al soltar Alt.
pgrep -x rofi >/dev/null && exit 0
rofi -show window -theme macos -window-format '{c}' -show-icons -selected-row 1 \
  -kb-row-right Alt+Tab -kb-row-left Alt+Shift+ISO_Left_Tab &
RP=$!
python3 - "$RP" <<'P' &
import ctypes, os, sys, time
x = ctypes.CDLL("libX11.so.6"); d = x.XOpenDisplay(None)
root = x.XDefaultRootWindow(d)
def alt():
    a=ctypes.c_ulong(); b=ctypes.c_ulong(); i=ctypes.c_int(); m=ctypes.c_uint()
    x.XQueryPointer(d, root, ctypes.byref(a), ctypes.byref(b), *[ctypes.byref(i)]*4, ctypes.byref(m))
    return m.value & 8  # Mod1 = Alt
time.sleep(0.15)
while os.path.exists(f"/proc/{sys.argv[1]}"):
    if not alt():
        os.system("xdotool key Return"); break
    time.sleep(0.02)
P
wait $RP
