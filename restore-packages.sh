#!/bin/bash
# restore-packages.sh - Restore straight.el packages from lockfile
# Run this on a new machine after git pull to sync packages

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EMACS_DIR="$SCRIPT_DIR"

echo "================================"
echo "Restoring packages from lockfile"
echo "================================"
echo ""
echo "This will download and install all packages specified in"
echo "straight/versions/default.el to match your other machines."
echo ""

# Check if lockfile exists
if [ ! -f "$EMACS_DIR/straight/versions/default.el" ]; then
    echo "ERROR: Lockfile not found at straight/versions/default.el"
    echo "Make sure you've created it on your original machine with:"
    echo "  M-x straight-freeze-versions"
    exit 1
fi

# Run emacs to restore packages
# We use --eval instead of --batch so init.el loads normally and can bootstrap straight.el
echo "Starting package restoration (this may take a few minutes)..."
echo ""

cd "$EMACS_DIR"
emacs --eval "(progn
                 (message \"Thawing versions from lockfile...\")
                 (sit-for 1)
                 (straight-thaw-versions)
                 (message \"Package restoration complete!\")
                 (sit-for 2)
                 (save-buffers-kill-emacs t))" 2>&1 | grep -v "^Loading\|^For information"

echo ""
echo "================================"
echo "✓ Packages restored successfully!"
echo "================================"
echo ""
echo "You can now start Emacs normally."
