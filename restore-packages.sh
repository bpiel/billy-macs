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

# Run emacs in batch mode to restore packages
echo "Starting package restoration (this may take a few minutes)..."
echo ""

cd "$EMACS_DIR"
emacs --batch \
      --eval "(setq user-emacs-directory \"$EMACS_DIR/\")" \
      --load "$EMACS_DIR/early-init.el" \
      --load "$EMACS_DIR/init.el" \
      --eval "(progn
                (message \"Thawing versions from lockfile...\")
                (straight-thaw-versions)
                (message \"Package restoration complete!\"))"

echo ""
echo "================================"
echo "✓ Packages restored successfully!"
echo "================================"
echo ""
echo "You can now start Emacs normally."
