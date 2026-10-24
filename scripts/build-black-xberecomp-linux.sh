#!/usr/bin/env bash

# BLACK-XBERecomp-Linux - Automated build script for Arch Linux
# Based on datfooldive's Linux fork
# https://github.com/datfooldive/BLACK-XBERecomp-Linux

set -e

BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

REPO_DIR="$HOME/BLACK-XBERecomp-Linux"
ASSETS_DIR="$REPO_DIR/assets"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  BLACK-XBERecomp-Linux | Arch Linux Setup${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}[ERROR]${NC} Do not run this script as root. Use your normal user."
  exit 1
fi

# 1) Install dependencies
echo -e "${YELLOW}[1/5]${NC} Installing required dependencies..."
sudo pacman -S --needed --noconfirm \
  base-devel \
  clang \
  lld \
  cmake \
  ninja \
  git \
  pkgconf \
  vulkan-headers \
  vulkan-icd-loader \
  shaderc \
  sdl3 \
  libx11 \
  libxext \
  libxrandr \
  libxcursor \
  libxi \
  libxkbcommon \
  wayland \
  wayland-protocols \
  pipewire \
  alsa-lib \
  pulseaudio \
  libpulse

echo -e "${GREEN}[OK]${NC} Dependencies installed."
echo ""

# 2) Clone the Linux fork
echo -e "${YELLOW}[2/5]${NC} Cloning BLACK-XBERecomp-Linux fork..."
if [ -d "$REPO_DIR" ]; then
  echo -e "${YELLOW}[INFO]${NC} $REPO_DIR already exists."
  read -p "Do you want to update it with git pull? [y/N]: " UPDATE
  if [[ "$UPDATE" =~ ^[Yy]$ ]]; then
    cd "$REPO_DIR"
    git pull --ff-only
    echo -e "${GREEN}[OK]${NC} Repository updated."
  else
    echo -e "${YELLOW}[SKIP]${NC} Skipping git clone/pull."
  fi
else
  git clone https://github.com/datfooldive/BLACK-XBERecomp-Linux.git "$REPO_DIR"
  echo -e "${GREEN}[OK]${NC} Repository cloned to $REPO_DIR"
fi
echo ""

# 3) Copy game assets
echo -e "${YELLOW}[3/5]${NC} Looking for extracted Black (USA) game files..."
mkdir -p "$ASSETS_DIR"

CANDIDATES=(
  "$HOME/Games/BLACK-2006-Recomp/game"
  "$HOME/Games/Black 2006/game"
  "$HOME/Games/Black Build/game"
  "$HOME/Games/Heroic/Prefixes/Black Build/BLACK-0.1.0-alpha.5/game"
  "$HOME/Games/Heroic/Prefixes/Black 2006/pfx/drive_c/Games/Black/game"
  "$HOME/Games/Heroic/Prefixes/Black 2006 2/pfx/drive_c/Games/Black/assets"
  "$HOME/Downloads/Black (USA)"
)

FOUND_PATH=""

for path in "${CANDIDATES[@]}"; do
  if [ -f "$path/default.xbe" ]; then
    FOUND_PATH="$path"
    break
  fi
done

if [ -n "$FOUND_PATH" ]; then
  echo -e "${GREEN}[FOUND]${NC} Game files detected at: $FOUND_PATH"
  echo -e "${YELLOW}[INFO]${NC} Copying files to $ASSETS_DIR (this may take a moment)..."
  rsync -ah --info=progress2 "$FOUND_PATH"/ "$ASSETS_DIR"/
  echo -e "${GREEN}[OK]${NC} Assets copied successfully."
else
  echo -e "${RED}[NOT FOUND]${NC} Could not automatically find 'default.xbe'."
  echo -e "Please manually copy the extracted USA/EU Black files to:"
  echo -e "  ${ASSETS_DIR}/"
  echo -e "Make sure 'default.xbe' is directly inside that folder."
  read -p "Press ENTER once you've copied the files to continue..."
fi

# Verify
if [ ! -f "$ASSETS_DIR/default.xbe" ]; then
  echo -e "${RED}[ERROR]${NC} 'default.xbe' not found in $ASSETS_DIR"
  echo -e "Aborting build. Copy your game files and run this script again."
  exit 1
fi

echo -e "${GREEN}[OK]${NC} Verified: default.xbe present."
echo ""

# 4) Build
echo -e "${YELLOW}[4/5]${NC} Building BLACK-XBERecomp-Linux..."
echo -e "${YELLOW}[INFO]${NC} First build can take 15 - 60 minutes depending on your CPU."
echo ""
cd "$REPO_DIR"
chmod +x build.sh
./build.sh

echo ""
echo -e "${GREEN}[OK]${NC} Build completed."
echo ""

# 5) Done
echo -e "${YELLOW}[5/5]${NC} All done!"
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}Executable:${NC} $REPO_DIR/out/build/release/black"
echo -e "${GREEN}Run with:${NC}   cd $REPO_DIR && ./out/build/release/black"
echo -e "${GREEN}Saves/Config:${NC} Created next to the executable (hdd/, black.toml)"
echo -e "${GREEN}Settings Menu:${NC} Press F10 in-game"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "${YELLOW}Tip:${NC} Run from a terminal on first launch to check for any errors."
