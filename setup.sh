#!/bin/bash

clear
echo ">> ZERO V8 - INYNKA FINAL BUILD"

BASE="$HOME/.hyperion"
REPO="https://github.com/HyperionLinuxTeam/ZERO"

# =========================

# DEPENDENCIAS

# =========================

sudo pacman -Sy --noconfirm 
zsh git fzf tmux 
btop fastfetch figlet

# =========================

# ESTRUCTURA

# =========================

mkdir -p $BASE/{core,modules,repos,bin,config}

# =========================

# CONFIG LANG

# =========================

echo "es" > $BASE/config/lang.conf

# =========================

# ENGINE

# =========================

cat > $BASE/core/engine.sh << 'EOF'
#!/bin/bash
log() { echo "[ZERO] $1"; }
EOF
chmod +x $BASE/core/engine.sh

# =========================

# GREETING

# =========================

cat > $BASE/core/greeting.sh << 'EOF'
#!/bin/bash
CONF="$HOME/.hyperion/config/lang.conf"
LANG=$(cat "$CONF" 2>/dev/null)

HOUR=$(date +%H)
USER=$(whoami)

if [ "$LANG" == "en" ]; then
if [ "$HOUR" -ge 6 ] && [ "$HOUR" -lt 12 ]; then
echo "Good morning, $USER"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 19 ]; then
echo "Good afternoon, $USER"
else
echo "Good evening, $USER"
fi
else
if [ "$HOUR" -ge 6 ] && [ "$HOUR" -lt 12 ]; then
echo "Buenos días, $USER"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 19 ]; then
echo "Buenas tardes, $USER"
else
echo "Buenas noches, $USER"
fi
fi
EOF
chmod +x $BASE/core/greeting.sh

# =========================

# LANG

# =========================

cat > $BASE/core/lang.sh << 'EOF'
#!/bin/bash
CONF="$HOME/.hyperion/config/lang.conf"

case "$1" in
--es)
echo "es" > "$CONF"
echo "Idioma cambiado a Español"
;;
--en)
echo "en" > "$CONF"
echo "Language set to English"
;;
*)
echo "Uso: lang --es | lang --en"
;;
esac
EOF
chmod +x $BASE/core/lang.sh

# =========================

# HELP

# =========================

cat > $BASE/core/help.sh << 'EOF'
#!/bin/bash
CONF="$HOME/.hyperion/config/lang.conf"
LANG=$(cat "$CONF" 2>/dev/null)

if [ "$LANG" == "en" ]; then
echo "===== ZERO HELP ====="
echo " zero --update"
echo " hyper menu"
echo " hyper panel"
echo " hyper install <repo>"
echo " hyper list"
echo " hyper about"
echo " hyper version"
echo " lang --en / --es"
echo " delete --zero"
else
echo "===== AYUDA ZERO ====="
echo " zero --update"
echo " hyper menu"
echo " hyper panel"
echo " hyper install <repo>"
echo " hyper list"
echo " hyper about"
echo " hyper version"
echo " lang --en / --es"
echo " delete --zero"
fi
EOF
chmod +x $BASE/core/help.sh

# =========================

# ABOUT

# =========================

cat > $BASE/core/about.sh << 'EOF'
#!/bin/bash
clear
echo "ZERO V8 - INYNKA"
echo ""
echo "GitHub:"
echo "https://github.com/HyperionLinuxTeam/ZERO"
echo ""
echo "Web:"
echo "https://hyperionlinuxteam.github.io/ZERO/"
echo ""
echo "Team:"
echo "https://hyperionlinuxteam.github.io"
EOF
chmod +x $BASE/core/about.sh

# =========================

# VERSION

# =========================

cat > $BASE/core/version.sh << 'EOF'
#!/bin/bash
echo "ZERO V8 - INYNKA"
echo "User: $(whoami)"
echo "Host: $(hostname)"
echo "Modules: $(ls ~/.hyperion/modules | wc -l)"
EOF
chmod +x $BASE/core/version.sh

# =========================

# DASHBOARD

# =========================

cat > $BASE/core/dashboard.sh << 'EOF'
#!/bin/bash
while true; do
clear
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
RAM=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2*100}')
figlet ZERO
echo "CPU: $CPU%"
echo "RAM: $RAM%"
echo "TIME: $(date)"
sleep 2
done
EOF
chmod +x $BASE/core/dashboard.sh

# =========================

# MULTIPANEL

# =========================

cat > $BASE/core/multipanel.sh << 'EOF'
#!/bin/bash
tmux new-session -d -s zero
tmux split-window -h
tmux split-window -v
tmux send-keys -t 0 "~/.hyperion/core/dashboard.sh" C-m
tmux send-keys -t 1 "btop" C-m
tmux send-keys -t 2 "fastfetch" C-m
tmux attach -t zero
EOF
chmod +x $BASE/core/multipanel.sh

# =========================

# PKG

# =========================

cat > $BASE/core/pkg.sh << 'EOF'
#!/bin/bash
BASE="$HOME/.hyperion"
TMP="$BASE/repos/tmp"

case "$1" in
install)
git clone "$2" "$TMP" || exit
if [ -f "$TMP/setup.sh" ]; then
chmod +x "$TMP/setup.sh"
(cd "$TMP" && ./setup.sh)
else
echo "setup.sh no encontrado"
fi
rm -rf "$TMP"
;;
list)
ls "$BASE/modules"
;;
*)
echo "Uso: hyper install <repo>"
;;
esac
EOF
chmod +x $BASE/core/pkg.sh

# =========================

# MENU

# =========================

cat > $BASE/core/menu.sh << 'EOF'
#!/bin/bash
while true; do
choice=$(printf "Panel\nDashboard\nModulos\nSalir" | fzf --prompt="ZERO > ")
case "$choice" in
Panel) ~/.hyperion/core/multipanel.sh ;;
Dashboard) ~/.hyperion/core/dashboard.sh ;;
Modulos) ls ~/.hyperion/modules; read ;;
Salir) break ;;
esac
done
EOF
chmod +x $BASE/core/menu.sh

# =========================

# COMMANDS

# =========================

cat > $BASE/bin/hyper << 'EOF'
#!/bin/bash
case "$1" in
menu) ~/.hyperion/core/menu.sh ;;
dash) ~/.hyperion/core/dashboard.sh ;;
panel) ~/.hyperion/core/multipanel.sh ;;
install) ~/.hyperion/core/pkg.sh install "$2" ;;
list) ~/.hyperion/core/pkg.sh list ;;
about) ~/.hyperion/core/about.sh ;;
version|info) ~/.hyperion/core/version.sh ;;
help) ~/.hyperion/core/help.sh ;;
*) echo "ZERO V8 INYNKA" ;;
esac
EOF
chmod +x $BASE/bin/hyper

# ZERO COMMAND

cat > $BASE/bin/zero << EOF
#!/bin/bash
if [ "$1" == "--update" ]; then
echo ">> Updating ZERO..."
if [ ! -d "$BASE/repo" ]; then
git clone "$REPO" "$BASE/repo"
else
cd "$BASE/repo" && git pull
fi
(cd "$BASE/repo" && ./setup.sh)
else
hyper "$@"
fi
EOF
chmod +x $BASE/bin/zero

# LANG GLOBAL

cat > $BASE/bin/lang << 'EOF'
#!/bin/bash
~/.hyperion/core/lang.sh "$@"
EOF
chmod +x $BASE/bin/lang

# DELETE ZERO

cat > $BASE/bin/delete << 'EOF'
#!/bin/bash

if [ "$1" != "--zero" ]; then
echo "Uso: delete --zero"
exit
fi

echo "⚠️ Esto eliminará ZERO completamente."
read -p "Escribe 'YES' para confirmar: " confirm

if [ "$confirm" != "YES" ]; then
echo "Cancelado."
exit
fi

rm -rf ~/.hyperion
sed -i '/.hyperion/d' ~/.zshrc 2>/dev/null
hash -r

echo "ZERO eliminado"
EOF
chmod +x $BASE/bin/delete

# =========================

# ZSH

# =========================

cat > ~/.zshrc << 'EOF'
export PATH="$HOME/.hyperion/bin:$PATH"

PROMPT='%F{green}┌──(%n@%m)-[%~]
└─%F{cyan}λ %f'

~/.hyperion/core/greeting.sh
echo ">> ZERO V8 INYNKA ONLINE"
EOF

echo ""
echo ">> INSTALADO ZERO V8 - INYNKA"
echo ">> Ejecuta: zsh"
