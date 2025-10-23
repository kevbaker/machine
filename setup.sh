#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  xcode-select --install || true
  for i in {1..60}; do
    xcode-select -p &>/dev/null && break || { echo "…waiting for Command Line Tools…"; sleep 10; }
  done
fi
echo "✅ Xcode Command Line Tools installed."

# Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Updating Homebrew..."
brew update

echo "==> Installing from Brewfile..."
BREWFILE="${1:-$(dirname "$0")/Brewfile}"
brew bundle --file="$BREWFILE"

# ---- Node & Python basics ----
echo "==> Setting up Node + Python..."
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
if ! grep -q 'NVM_DIR' ~/.zshrc; then
  cat <<'EOF' >> ~/.zshrc

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
EOF
fi
. "/opt/homebrew/opt/nvm/nvm.sh" || true
nvm install --lts || true
nvm alias default 'lts/*' || true

pyenv install -s 3.12.6
pyenv global 3.12.6
python3 -m pip install --upgrade pip

echo "==> Installing global npm & pip tools..."
npm install -g typescript ts-node eslint prettier nodemon
pipx install poetry black flake8 pytest httpie jupyterlab notebook torch torchvision torchaudio transformers sentencepiece openai huggingface_hub

# ---- Podman setup (Docker alternative) ----
if command -v podman &>/dev/null; then
  echo "==> Initializing Podman machine..."
  if ! podman machine list 2>/dev/null | grep -q Running; then
    podman machine init --cpus 4 --memory 4096 --disk-size 60 || true
    podman machine start || true
  fi
  # Docker CLI compatibility (simple)
  if ! grep -q 'alias docker=podman' ~/.zshrc; then
    echo "alias docker=podman" >> ~/.zshrc
  fi
  echo "✅ Podman ready (use 'podman' or 'docker' alias)."
fi

echo "✅ All done. Open VS Code / Warp, sign into App Store for MAS apps, and you're set."
