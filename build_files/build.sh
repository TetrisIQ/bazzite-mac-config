#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux 

# Install Pantheon Desktop and dependencies
# Try to enable COPR for elementary packages, fallback to standard repos
dnf5 install -y 'dnf5-command(copr)' || true
dnf5 copr enable -y decathorpe/elementary-nightly || echo "COPR not available, using standard repos"
dnf5 group install -y 'Pantheon Desktop' || dnf5 install -y pantheon-session-settings gala wingpanel plank switchboard pantheon-files pantheon-terminal || echo "Pantheon packages not available, installing minimal DE components"

# LightDM installation steps
dnf5 install -y lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings elementary-theme elementary-icon-theme
# Disable any existing display managers (GDM from Fedora default)
systemctl disable gdm.service || true
systemctl disable sddm.service || true
# Enable LightDM
systemctl enable lightdm.service

### Configure LightDM
# Create LightDM main configuration
mkdir -p /etc/lightdm
cat > /etc/lightdm/lightdm.conf << 'EOF'
[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=pantheon
allow-guest=false
session-timeout=60
EOF

# Configure GTK greeter for Pantheon look
cat > /etc/lightdm/lightdm-gtk-greeter.conf << 'EOF'
[greeter]
theme-name=elementary
icon-theme-name=elementary
cursor-theme-name=elementary
font-name=Inter 11
show-indicators=~host;~spacer;~clock;~power
show-clock=true
clock-format=%a, %b %d  %H:%M
user-background=false
hide-user-image=false
active-monitor=0
screensaver-timeout=60
EOF

# Create Pantheon session file
mkdir -p /usr/share/xsessions
cat > /usr/share/xsessions/pantheon.desktop << 'EOF'
[Desktop Entry]
Name=Pantheon
Comment=Pantheon Desktop Environment
Exec=io.elementary.session-settings
TryExec=io.elementary.session-settings
Icon=distributor-logo
Type=XSession
DesktopNames=Pantheon
EOF

# Set default session
mkdir -p /var/lib/AccountsService/users
echo "pantheon" > /var/lib/AccountsService/users/default-session

# Disable COPR so it doesn't end up enabled on the final image
dnf5 copr disable -y decathorpe/elementary-nightly || true

#### Example for enabling a System Unit File

systemctl enable podman.socket
