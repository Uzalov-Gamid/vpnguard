#!/bin/sh
# Установка vpnguard: скачивает программу в ~/.local/bin и запускает сторож через launchd.
set -eu

REPO="Uzalov-Gamid/vpnguard"
BRANCH="${VPNGUARD_BRANCH:-main}"

if [ "$(uname)" != "Darwin" ]; then
    echo "vpnguard работает только на macOS" >&2
    exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
    echo "Нужен Python 3.9+: выполни xcode-select --install или brew install python" >&2
    exit 1
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
echo "Скачиваю vpnguard ($BRANCH)…"
curl -fsSL "https://raw.githubusercontent.com/$REPO/$BRANCH/vpnguard" -o "$tmp/vpnguard"
chmod +x "$tmp/vpnguard"
python3 -I "$tmp/vpnguard" install

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) echo "Добавь ~/.local/bin в PATH: echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc" ;;
esac
echo "Готово. Запусти: vpn"
