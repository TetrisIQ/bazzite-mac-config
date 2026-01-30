#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux 

# LightDM installation steps
dnf5 install -y lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
# Disable any existing display managers (GDM from Fedora default)
systemctl disable gdm.service || true
systemctl disable sddm.service || true
# Enable LightDM
systemctl enable lightdm.service

# Set default session
echo "pantheon" > /var/lib/AccountsService/users/default-session

# Use a COPR Example:dnf group install 'pantheon desktop'
#
dnf copr enable decathorpe/elementary-nightly
dnf group install 'pantheon desktop'

# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
