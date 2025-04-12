
#!/bin/bash

set -e

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="x86_64"
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Detect current version
if command -v nvim &> /dev/null; then
    CURRENT_VERSION=$(nvim --version | head -n 1 | awk '{print $2}')
    echo "🔎 Current Neovim version: $CURRENT_VERSION"
else
    CURRENT_VERSION="none"
    echo "ℹ️ Neovim not currently installed."
fi

# Get latest release tag from GitHub API
LATEST_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

echo "🌐 Latest Neovim version available: $LATEST_VERSION"

# Compare versions
if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo "✅ You already have the latest Neovim ($CURRENT_VERSION). No update needed."
    exit 0
fi

# Download and install/update
DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.appimage"

echo "⬇️ Downloading Neovim $LATEST_VERSION from $DOWNLOAD_URL ..."
mkdir -p ~/.local/bin
cd ~/.local/bin

wget -O nvim.appimage "$DOWNLOAD_URL"

chmod u+x nvim.appimage

# Optionally create a symlink if first install
if ! command -v nvim &> /dev/null; then
    echo "🔗 Creating symlink for 'nvim'..."
    ln -sf ~/.local/bin/nvim.appimage ~/.local/bin/nvim
fi

echo "🚀 Neovim is now installed/updated to version:"
~/.local/bin/nvim.appimage --version | head -n 1

