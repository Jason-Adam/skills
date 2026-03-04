#!/usr/bin/env bash
set -euo pipefail

# Removes symlinks created by install.sh
# Restores backups if available (uses most recent backup)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_BASE="$CLAUDE_DIR/backups"

removed=0
restored=0
skipped=0

# Find most recent backup directory
latest_backup=""
if [ -d "$BACKUP_BASE" ]; then
  latest_backup="$(ls -1d "$BACKUP_BASE"/*/ 2>/dev/null | sort -r | head -1)" || true
fi

uninstall_files() {
  local src_dir="$1"
  local dest_dir="$2"
  local category="$3"

  for src_file in "$src_dir"/*.md; do
    [ -f "$src_file" ] || continue
    local filename
    filename="$(basename "$src_file")"
    local dest_file="$dest_dir/$filename"

    # Only remove if it's a symlink pointing to our repo
    if [ -L "$dest_file" ] && [ "$(readlink "$dest_file")" = "$src_file" ]; then
      rm "$dest_file"
      echo "  remove $category/$filename"
      ((removed++))

      # Restore from backup if available
      if [ -n "$latest_backup" ] && [ -f "$latest_backup/$category/$filename" ]; then
        cp "$latest_backup/$category/$filename" "$dest_file"
        echo "  restore $category/$filename (from backup)"
        ((restored++))
      fi
    else
      if [ -e "$dest_file" ]; then
        echo "  skip  $category/$filename (not our symlink)"
      fi
      ((skipped++))
    fi
  done
}

echo "Uninstalling skills (removing symlinks to $SCRIPT_DIR)"
echo ""

uninstall_files "$SCRIPT_DIR/agents" "$CLAUDE_DIR/agents" "agents"
uninstall_files "$SCRIPT_DIR/commands" "$CLAUDE_DIR/commands" "commands"

echo ""
echo "Done: $removed removed, $restored restored, $skipped skipped"
