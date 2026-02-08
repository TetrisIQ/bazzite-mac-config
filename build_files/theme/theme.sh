# Install needed packages

dnf install -y sassc glib2-devel 

# Ensure pipx state/cache paths exist (container builds may not have them)
export PIPX_HOME="${PIPX_HOME:-/root/.local/share/pipx}"
export PIPX_STATE_HOME="${PIPX_STATE_HOME:-/root/.local/state/pipx}"
mkdir -p "${PIPX_HOME}" "${PIPX_STATE_HOME}/log"

pipx install gnome-extensions-cli 
# --- GNOME Shell Extensions Installation ---
echo "Installing GNOME Shell Extensions..."

# List of required extensions (UUIDs and names)
EXTENSIONS=(
  "user-theme@gnome-shell-extensions.gcampax.github.com" # User Themes
  "compiz-windows-effect@hermes83.github.com"           # Compiz Window Effect
  "dash-to-dock@micxgx.gmail.com"                      # Dash To Dock
  "dynamic-panel-transparency@rockon999.github.io"     # Dynamic Panel Transparency
  "panel-osd@berend.de.schouwer.gmail.com"             # Panel OSD
  "trayIconsReloaded@selfmade.pl"                      # Tray Icons Reloaded
)

# Install and enable each extension
for UUID in "${EXTENSIONS[@]}"; do
  echo "Installing $UUID..."
  /var/roothome/.local/bin/gext install "$UUID"
done

echo "All GNOME Shell extensions installed and enabled."

git clone https://github.com/vinceliuice/WhiteSur-gtk-theme
git clone https://github.com/vinceliuice/WhiteSur-icon-theme
git clone https://github.com/vinceliuice/WhiteSur-cursors

./WhiteSur-gtk-theme/install.sh
./WhiteSur-icon-theme/install.sh
./WhiteSur-cursors/install.sh

# uninstall pipx dependency to avoid it being included in the final image
pipx uninstall gnome-extensions-cli 