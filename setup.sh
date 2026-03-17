#!/bin/bash

clear
echo ">> ZERO V8.6 - EXIS CORE INSTALL"

BASE="$HOME/.hyperion"
REPO="https://github.com/HyperionLinuxTeam/ZERO"

# =========================

# DEPENDENCIAS

# =========================

sudo pacman -Sy --noconfirm git fzf tmux btop fastfetch figlet

# =========================

# ESTRUCTURA

# =========================

mkdir -p $BASE/{core,modules,repos,bin,config}

echo "es" > $BASE/config/lang.conf

# =========================

# BOOT

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
sleep 0.2
EOF
chmod +x $BASE/core/boot.sh

# =========================

# LOGO

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
echo -e "\e[36m        V8.6 - EXIS CORE\e[0m"
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
echo "ZERO COMMANDS:"
echo " help"
echo " about"
echo " info / version"
echo " lang --en / --es"
echo " zero --update"
echo " delete --zero"
echo " exit"
EOF
chmod +x $BASE/core/help.sh

# =========================

# ABOUT

# =========================

cat > $BASE/core/about.sh << 'EOF'
#!/bin/bash
clear
echo "========== ZERO V8.6 EXIS =========="
echo ""
echo "GitHub:"
echo "https://github.com/HyperionLinuxTeam/ZERO"
echo ""
echo "Web:"
echo "https://hyperionlinuxteam.github.io/ZERO/"
echo ""
echo "Equipo:"
echo "https://hyperionlinuxteam.github.io"
echo ""
echo "User: $(whoami)"
echo "Host: $(hostname)"
echo "===================================="
EOF
chmod +x $BASE/core/about.sh

# =========================

# VERSION

# =========================

cat > $BASE/core/version.sh << 'EOF'
#!/bin/bash
echo "ZERO V8.6 - EXIS CORE"
echo "User   : $(whoami)"
echo "Host   : $(hostname)"
echo "Kernel : $(uname -r)"
EOF
chmod +x $BASE/core/version.sh

# =========================

# LANG

# =========================

cat > $BASE/core/lang.sh << 'EOF'
#!/bin/bash
CONF="$HOME/.hyperion/config/lang.conf"

case "$1" in
--es) echo "es" > "$CONF" ;;
--en) echo "en" > "$CONF" ;;
*) echo "lang --es | --en" ;;
esac
EOF
chmod +x $BASE/core/lang.sh

# =========================

# DELETE

# =========================

cat > $BASE/core/delete.sh << 'EOF'
#!/bin/bash

echo "⚠️ Delete ZERO?"
read -p "Type YES: " confirm

[ "$confirm" != "YES" ] && exit

rm -rf ~/.hyperion
echo "ZERO eliminado"
EOF
chmod +x $BASE/core/delete.sh

# =========================

# UPDATE

# =========================

cat > $BASE/core/update.sh << EOF
#!/bin/bash
echo ">> Updating ZERO..."
if [ ! -d "$BASE/repo" ]; then
git clone "$REPO" "$BASE/repo"
else
cd "$BASE/repo" && git pull
fi
(cd "$BASE/repo" && ./setup.sh)
EOF
chmod +x $BASE/core/update.sh

# =========================

# MAIN ZERO COMMAND

# =========================

cat > $BASE/bin/zero << 'EOF'
#!/bin/bash

BASE="$HOME/.hyperion"

clear
$BASE/core/boot.sh
$BASE/core/logo.sh
$BASE/core/greeting.sh

echo -e "\e[35m>> ZERO V8.6 - EXIS CORE\e[0m"

while true; do
echo -ne "\e[32mzero ⚡ \e[0m"
read cmd args

```
case "$cmd" in
    help) $BASE/core/help.sh ;;
    about) $BASE/core/about.sh ;;
    info|version) $BASE/core/version.sh ;;
    lang) $BASE/core/lang.sh $args ;;
    delete) [ "$args" == "--zero" ] && $BASE/core/delete.sh ;;
    zero) [ "$args" == "--update" ] && $BASE/core/update.sh ;;
    exit) break ;;
    *) echo "Command not found" ;;
esac
```

done
EOF

chmod +x $BASE/bin/zero

# =========================

# PATH GLOBAL

# =========================

if ! grep -q hyperion ~/.bashrc; then
echo 'export PATH="$HOME/.hyperion/bin:$PATH"' >> ~/.bashrc
fi

echo ""
echo ">> ZERO INSTALLED"
echo ">> RUN: zero"
