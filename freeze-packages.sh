#!/bin/bash
# freeze-packages.sh - Create/update straight.el lockfile
# Run this after adding, removing, or updating packages

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EMACS_DIR="$SCRIPT_DIR"

echo "==============================="
echo "Freezing package versions"
echo "==============================="
echo ""
echo "This will create/update the lockfile at:"
echo "  straight/versions/default.el"
echo ""

# Run emacs in batch mode to freeze versions
echo "Creating lockfile..."
echo ""

cd "$EMACS_DIR"
emacs --batch \
      --eval "(setq user-emacs-directory \"$EMACS_DIR/\")" \
      --load "$EMACS_DIR/early-init.el" \
      --load "$EMACS_DIR/init.el" \
      --eval "(progn
                (message \"Freezing package versions...\")
                (straight-freeze-versions)
                (message \"Lockfile updated!\"))"

echo ""
echo "==============================="
echo "✓ Lockfile created/updated!"
echo "==============================="
echo ""

# Check if there are changes to commit
if git diff --quiet straight/versions/default.el 2>/dev/null; then
    echo "No changes to lockfile (packages unchanged)."
else
    echo "Lockfile has been updated with current package versions."
fi
