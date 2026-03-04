#!/usr/bin/env bash
set -euo pipefail

# Symlinks agents and commands from this repo into ~/.claude/
# Backs up existing non-symlink files to ~/.claude/backups/<timestamp>/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups/$(date +%Y%m%d_%H%M%S)"

linked=0
skipped=0
backed_up=0
backup_created=false

install_files() {
  local src_dir="$1"
  local dest_dir="$2"
  local category="$3"

  mkdir -p "$dest_dir"

  for src_file in "$src_dir"/*.md; do
    [ -f "$src_file" ] || continue
    local filename
    filename="$(basename "$src_file")"
    local dest_file="$dest_dir/$filename"

    # Already symlinked to our file — skip
    if [ -L "$dest_file" ] && [ "$(readlink "$dest_file")" = "$src_file" ]; then
      echo "  skip  $category/$filename (already linked)"
      ((skipped++))
      continue
    fi

    # Exists and is not our symlink — back it up
    if [ -e "$dest_file" ] || [ -L "$dest_file" ]; then
      if ! $backup_created; then
        mkdir -p "$BACKUP_DIR/$category"
        backup_created=true
      else
        mkdir -p "$BACKUP_DIR/$category"
      fi
      mv "$dest_file" "$BACKUP_DIR/$category/$filename"
      echo "  backup $category/$filename → backups/$(basename "$BACKUP_DIR")/$category/"
      ((backed_up++))
    fi

    ln -sf "$src_file" "$dest_file"
    echo "  link  $category/$filename"
    ((linked++))
  done
}

echo "Installing skills from $SCRIPT_DIR"
echo ""

install_files "$SCRIPT_DIR/agents" "$CLAUDE_DIR/agents" "agents"
install_files "$SCRIPT_DIR/commands" "$CLAUDE_DIR/commands" "commands"

echo ""
echo "Done: $linked linked, $skipped skipped, $backed_up backed up"

if [ "$backed_up" -gt 0 ]; then
  echo "Backups saved to: $BACKUP_DIR"
fi

echo ""
echo "Note: config/settings.json and config/CLAUDE.md are not auto-installed."
echo "Review them manually and copy what you need to ~/.claude/"
