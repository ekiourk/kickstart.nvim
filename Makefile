# Where things are
MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

PYTHON_VENV = $(HOME)/.venvs/nvim
PYTHON_HOST_FILE = $(MAKEFILE_DIR)/lua/user/languages/python_host.lua

SCRIPTS_DIR = $(MAKEFILE_DIR)/scripts
LOCAL_BIN = $(HOME)/.local/bin
BACKUP_DIR = $(HOME)/nvim-backups
BACKUP_FILE = $(BACKUP_DIR)/nvim-config-$(shell date +%Y%m%d).tar.gz

# Default action
all: help

help:
	@echo ""
	@echo "Available targets:"
	@echo "  make update    - Update Neovim to latest version"
	@echo "  make install   - First-time install Neovim"
	@echo "  make backup    - Backup your Neovim config"
	@echo "  make restore   - Restore your Neovim config"
	@echo "  make check     - Run basic Neovim health checks"
	@echo "  make clean     - Clean up temp files"
	@echo ""

update:
	bash $(SCRIPTS_DIR)/update-nvim.sh

install:
	bash $(SCRIPTS_DIR)/update-nvim.sh

backup:
	mkdir -p $(BACKUP_DIR)
	tar czvf $(BACKUP_FILE) -C $(HOME)/.config nvim
	@echo "✅ Backup created at $(BACKUP_FILE)"

restore:
	@echo "ℹ️ Available backups:"
	@ls -lh $(BACKUP_DIR)
	@echo ""
	@read -p "Enter backup filename to restore: " FILE; \
	tar xzvf $(BACKUP_DIR)/$$FILE -C $(HOME)/.config

check:
	@if command -v nvim &> /dev/null; then \
		echo "✅ Neovim is installed."; \
		nvim --version | head -n 1; \
	else \
		echo "❌ Neovim not installed."; \
	fi
	@echo "🔎 Checking config health (needs Neovim running)..."
	@echo "  You can run :checkhealth inside Neovim."

clean:
	rm -f $(LOCAL_BIN)/nvim.appimage
	@echo "🧹 Cleaned AppImage."

python-env:
	@echo "📦 Creating Neovim Python environment..."
	@python3 -m venv $(PYTHON_VENV)
	@$(PYTHON_VENV)/bin/pip install --upgrade pip > /dev/null
	@$(PYTHON_VENV)/bin/pip install pynvim > /dev/null
	@$(PYTHON_VENV)/bin/pip install debugpy > /dev/null
	@mkdir -p $$(dirname $(PYTHON_HOST_FILE))
	@echo "vim.g.python3_host_prog = '$(PYTHON_VENV)/bin/python'" > $(PYTHON_HOST_FILE)
	@echo "✅ Python virtual environment for Neovim set up and configured:"
	@echo "   - Virtual env: $(PYTHON_VENV)"
	@echo "   - Config written to: $(PYTHON_HOST_FILE)"

