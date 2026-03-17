#!/bin/bash

clear
echo ">> ZERO V8.5 - EXIS INSTALL"

BASE="$HOME/.hyperion"
REPO="https://github.com/HyperionLinuxTeam/ZERO"

# =========================

# DEPENDENCIAS

# =========================

sudo pacman -Sy --noconfirm zsh git fzf tmux btop fastfetch figlet

# =========================

# ESTRUCTURA

# =========================

mkdir -p $BASE/{core,modules,repos,bin,config}

echo "es" > $BASE/config/lang.conf

# =========================

# BOOT ANIMATION

# =========================

cat > $BASE/core/boot.sh << 'EOF'
#!/bin/bash
echo -e "\e[35m[ZERO EXIS] Initializing core...\e[0m"
sleep 0.2
echo -e "\e[36m[ZERO EXIS] Loading modules...\e[0m"
sleep 0.2
echo -e "\e[32m[ZERO EXIS] Injecting interface...\e[0m"
sleep 0.2
echo -e "\e[35m[ZERO EXIS] Syncing environment...\e[0m"
sleep 0.2
echo -e "\e[32m[OK] System ready\e[0m"
sleep 0.3
EOF
chmod +x $BASE/core/boot.sh

# =========================

# ASCII LOGO

# =========================

cat > $BASE/core/logo.sh << 'EOF'
#!/bin/bash
echo -e "\e[35m"
echo "███████╗███████╗██████╗  ██████╗ "
echo "╚══███╔╝██╔════╝██╔══██╗██╔═══██╗"
echo "  ███╔╝ █████╗  ██████╔╝██║   ██║"
echo " ███╔╝  ██╔══╝  ██╔══██╗██║   ██║"
echo "███████╗███████╗██║  ██║╚██████╔╝"
echo "╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ "
echo -e "\e[36m        V8.5 - EXIS\e[0m"
echo -e "\e[0m"
EOF
chmod +x $BASE/core/logo.sh

# =========================

# GREETING

# =========================

cat > $BASE/core/greeting.sh << 'EOF'
#!/bin/bash

LANG=$(cat ~/.hyperion/config/lang.conf 2>/dev/null)
HOUR=$(date +%H)
USER=$(whoami)

if [ "$LANG" == "en" ]; then
[ $HOUR -lt 12 ] && MSG="Good morning" || 
[ $HOUR -lt 19 ] && MSG="Good afternoon" || MSG="Good evening"
else
[ $HOUR -lt 12 ] && MSG="Buenos días" || 
[ $HOUR -lt 19 ] && MSG="Buenas tardes" || MSG="Buenas noches"
fi

echo -e "\e[36m$MSG, \e[32m$USER\e[0m"
EOF
chmod +x $BASE/core/greeting.sh

# =========================

# HELP

# =========================

cat > $BASE/core/help.sh << 'EOF'
#!/bin/bash
LANG=$(cat ~/.hyperion/config/lang.conf 2>/dev/null)

if [ "$LANG" == "en" ]; then
echo "ZERO V8.5 EXIS COMMANDS:"
echo " zero --update"
echo " help"
echo " lang --en / --es"
echo " delete --zero"
else
echo "COMANDOS ZERO V8.5 EXIS:"
echo " zero --update"
echo " help"
echo " lang --en / --es"
echo " delete --zero"
fi
EOF
chmod +x $BASE/core/help.sh

# =========================

# HELP GLOBAL

# =========================

cat > $BASE/bin/help << 'EOF'
#!/bin/bash
~/.hyperion/core/help.sh
EOF
chmod +x $BASE/bin/help

# =========================

# LANG

# =========================

cat > $BASE/bin/lang << 'EOF'
#!/bin/bash
CONF="$HOME/.hyperion/config/lang.conf"

case "$1" in
--es) echo "es" > "$CONF" ;;
--en) echo "en" > "$CONF" ;;
*) echo "lang --es | --en" ;;
esac
EOF
chmod +x $BASE/bin/lang

# =========================

# ZERO UPDATE

# =========================

cat > $BASE/bin/zero << EOF
#!/bin/bash

if [ "$1" == "--update" ]; then
echo ">> Updating ZERO EXIS..."
if [ ! -d "$BASE/repo" ]; then
git clone "$REPO" "$BASE/repo"
else
cd "$BASE/repo" && git pull
fi
(cd "$BASE/repo" && ./setup.sh)
else
echo "ZERO EXIS CORE ACTIVE"
fi
EOF
chmod +x $BASE/bin/zero

# =========================

# DELETE ZERO

# =========================

cat > $BASE/bin/delete << 'EOF'
#!/bin/bash

[ "$1" != "--zero" ] && echo "Uso: delete --zero" && exit

echo "⚠️ Esto eliminará ZERO completamente"
read -p "Type YES: " confirm

[ "$confirm" != "YES" ] && exit

rm -rf ~/.hyperion
sed -i '/hyperion/d' ~/.zshrc

echo "ZERO eliminado"
EOF
chmod +x $BASE/bin/delete

# =========================

# ZSH CONFIG

# =========================

cat > ~/.zshrc << 'EOF'
export PATH="$HOME/.hyperion/bin:$PATH"

clear

~/.hyperion/core/boot.sh
~/.hyperion/core/logo.sh
~/.hyperion/core/greeting.sh

echo -e "\e[35m>> ZERO V8.5 - EXIS ONLINE\e[0m"

PROMPT='%F{magenta}┌─[%n@%m]%f %F{cyan}[%~]
└─%F{green}⚡ %f'
EOF

echo ""
echo ">> ZERO V8.5 - EXIS INSTALLED"
echo ">> RUN: zsh"
