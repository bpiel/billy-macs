# Billy-Macs User Guide

**Last Updated:** November 2025
**Purpose:** Quick reference for new features, shortcuts, and configuration management

---

## Table of Contents

1. [New Completion System](#new-completion-system)
2. [New Shortcuts & Modes](#new-shortcuts--modes)
3. [Quality of Life Features](#quality-of-life-features)
4. [Advanced Features](#advanced-features)
5. [Package Management](#package-management)
6. [Configuration Guide](#configuration-guide)

---

## New Completion System

### Vertico (Minibuffer Completion)
**What it does:** Provides vertical completion UI in the minibuffer, replacing ido.

**When to use:** Automatically active for all minibuffer completions (M-x, C-x b, etc.).

**Key bindings:**
- `C-n` / `C-p` - Navigate down/up through candidates
- `M-RET` - Submit exactly what you typed (not the selected candidate)

### Consult (Enhanced Commands)
**What it does:** Provides powerful search and navigation commands with live preview.

**When to use:** For searching buffers, files, recent files, or project-wide searches.

**Key bindings:**
- `C-x b` - Switch buffers with preview (replaces old ido buffer switching)
- `C-x f` - Open recent file (replaces `live-recentf-ido-find-file`)
- `C-x C-i` - Jump to symbol in buffer (replaces `live-ido-goto-symbol`)
- `M-s l` / `C-c l` - Search lines in current buffer with live preview
- `C-c C-g` - Project-wide search using ripgrep
- `M-y` - Yank from kill ring with preview
- `M-g g` - Go to line number
- `M-g i` - Jump to symbol via imenu

### Corfu (In-Buffer Completion)
**What it does:** Modern completion popup that replaces auto-complete.

**When to use:** Automatically appears while typing code (after 2 characters, 0.25s delay). Works with all language modes including CIDER, Go, Rust, TypeScript.

**Key bindings:**
- `TAB` - Select next candidate
- `S-TAB` - Select previous candidate
- `RET` - Insert selected candidate

### Orderless (Fuzzy Matching)
**What it does:** Provides powerful fuzzy matching for completions.

**When to use:** Automatically active. Type space-separated components in any order (e.g., "buf swi" matches "buffer-switch").

---

## New Shortcuts & Modes

### Undo System (undo-fu + vundo)

**undo-fu:** Simple, reliable linear undo/redo system.
- `M-z` - Undo
- `M-Z` (shift) - Redo

**vundo:** Visual undo tree for complex undo histories.
- `C-x u` - Open visual undo tree
- Use when you need to navigate branches in your undo history (e.g., after undoing changes, then making new edits, then wanting to recover the undone changes).

### Embark (Contextual Actions)

**What it does:** Provides context-sensitive actions on targets at point or in the minibuffer. Think of it as a "right-click context menu" for Emacs.

**When to use:** When you want to perform actions on files, buffers, symbols, URLs, or other objects.

**Key bindings:**
- `C-.` - Show available actions for target at point (pick action with completion)
- `C-;` - "Do What I Mean" - execute smart default action for target
- `C-h B` - Show all keybindings (alternative to `describe-bindings`)

**Example use cases:**
- Cursor on a file path? `C-.` shows actions like "find-file", "delete", "copy path"
- In buffer list? `C-.` shows actions like "kill buffer", "switch to buffer", "save"
- On a symbol? `C-.` shows "find definition", "find references", "describe"

### Popper (Popup Window Management)

**What it does:** Intelligently manages temporary popup buffers (help, compilation, messages, etc.) without cluttering your window layout.

**When to use:** When you want to quickly toggle or cycle through help buffers, compilation output, or other temporary windows.

**Key bindings:**
- `` C-` `` - Toggle last popup (show/hide)
- `` M-` `` - Cycle through all popup buffers
- `` C-M-` `` - Toggle popup type (normal window ↔ popup)

**Configured popups:** *Messages*, *Warnings*, *Compile-Log*, help-mode, compilation-mode, flycheck-error-list-mode

### Which-Key (Keybinding Discovery)

**What it does:** Shows available keybindings in a popup when you pause while typing a command.

**When to use:** All the time! Helps discover commands you didn't know existed. For example, type `C-x` and wait 1 second - you'll see all possible `C-x` keybindings.

### Helpful (Better Help Buffers)

**What it does:** Enhanced help system showing source code, references, and better formatting.

**When to use:** Automatically active when you use help commands.

**Key bindings:** (These replace the default help commands)
- `C-h f` - Describe function (shows source code + documentation)
- `C-h v` - Describe variable (shows current value + documentation)
- `C-h k` - Describe key (shows what a keybinding does)
- `C-h x` - Describe command

---

## Quality of Life Features

### Which-Key
Displays available keybindings after 1 second pause. Always active - just start typing a prefix key like `C-x` or `C-c` and wait.

### Super-Save
**What it does:** Automatically saves files when switching buffers, windows, or when idle.

**When to use:** Always active - provides peace of mind. Files auto-save when:
- Switching to another buffer
- Switching to another window
- Idle for 5 seconds
- Emacs loses focus

### Pulsar (Visual Feedback)
**What it does:** Briefly pulses/highlights the current line when cursor makes large jumps.

**When to use:** Automatically active when jumping with commands like `other-window`, page up/down, bookmark-jump, etc. Makes it easier to track where cursor landed.

### Diff-HL (Git Integration)
**What it does:** Shows git diff indicators in the fringe (left/right margin).

**When to use:** Always active in version-controlled files. Shows visual indicators for:
- Lines you've added (green)
- Lines you've modified (blue)
- Lines you've deleted (red)

### Rainbow-Mode
**What it does:** Highlights color codes (hex, rgb, etc.) with their actual colors.

**When to use:** Automatically enabled in emacs-lisp-mode, css-mode, html-mode, web-mode. Useful when editing themes or CSS.

### Session Persistence

**savehist:** Remembers minibuffer history (commands, searches, kill-ring) between sessions.

**saveplace:** Remembers cursor position in files. When you reopen a file, cursor returns to where you left off.

**recentf:** Tracks recently opened files (up to 100). Access via `C-x f` (consult-recent-file).

---

## Advanced Features

### Treesit-Auto (Tree-Sitter)
**What it does:** Automatic tree-sitter grammar installation for better syntax highlighting and code understanding.

**Status:** Currently disabled by default due to version compatibility.

**When to use:** Enable manually with `M-x treesit-auto-apply-remap` for specific languages when needed.

### Display Line Numbers
**What it does:** Shows line numbers in programming modes (faster than old linum-mode).

**When to use:** Automatically enabled in all prog-mode buffers (any programming language).

### Eglot (LSP - Language Server Protocol)
**What it does:** Provides IDE-like features (code completion, jump-to-definition, refactoring, etc.) for multiple languages.

**Configured languages:**
- **Go:** Uses gopls
- **Rust:** Uses rust-analyzer (via rustic-mode)
- **TypeScript:** Uses typescript-language-server
- **C/C++:** Uses clangd

**When to use:** Automatically starts when opening files in supported languages.

**Common eglot commands:**
- `M-?` - Find references
- `M-.` - Jump to definition
- `M-,` - Jump back
- `C-c C-c a` - Code actions (Rust)
- `C-c C-c r` - Rename symbol (Rust)
- `C-c C-c f` - Format buffer (Rust)

---

## Package Management

### Adding New Packages

Billy-macs uses **straight.el** for package management, which provides reproducible builds and version control.

**Steps to add a new package:**

1. **Open init.el**
   ```bash
   emacs ~/repos/billy-macs/init.el
   ```

2. **Add use-package declaration** in the "Package Declarations" section (~line 98):
   ```elisp
   ;; Add near other packages
   (use-package package-name)
   ```

3. **Configure the package** (either inline or in separate file):

   **Option A - Inline configuration:**
   ```elisp
   (use-package package-name
     :demand t          ; Load immediately (remove for lazy loading)
     :custom
     (package-variable-name value)
     :bind (("C-c x" . package-command))
     :config
     (package-mode 1))
   ```

   **Option B - Separate config file:**
   ```elisp
   ;; In init.el, just declare the package
   (use-package package-name)

   ;; Create ~/repos/billy-macs/conf/package-name-conf.el
   ;; Add configuration there, then load it:
   (load-file (concat billy-conf-dir "package-name-conf.el"))
   ```

4. **Restart Emacs** - straight.el will automatically install the package

**Example - Adding `company-mode`:**
```elisp
;; In init.el (Package Declarations section)
(use-package company
  :demand t
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous))
  :custom
  (company-idle-delay 0.3)
  (company-minimum-prefix-length 2)
  :config
  (global-company-mode))
```

### Package Sources & Offline Access

**Important:** Billy-macs keeps package source code in the repository for offline reliability.

**What's committed:**
- `straight/repos/` - All package source code
- `straight/versions/` - Lockfile with exact package versions

**What's ignored:**
- `straight/build/` - Compiled packages (regenerated on each system)
- `.local/` - Cache and temporary files

**Benefits:**
- Fully self-contained configuration
- Works without network access
- Exact reproducibility

### Updating Packages

```elisp
;; Update all packages
M-x straight-pull-all

;; Update specific package
M-x straight-pull-package RET package-name RET

;; Rebuild package after update
M-x straight-rebuild-package RET package-name RET

;; Check for package modifications
M-x straight-check-package RET package-name RET
```

---

## Configuration Guide

### Modifying Existing Package Configuration

**Find where package is configured:**

1. **Check init.el** - Look in the "Package Declarations" section and below
2. **Check conf/ directory** - Many packages have dedicated config files:
   ```
   conf/
     avy-conf.el
     cider-conf.el
     clojure-conf.el
     completion.el      (vertico, consult, corfu, orderless)
     paredit-conf.el
     rustic-conf.el
     ... etc
   ```

**Common modification patterns:**

**Changing keybindings:**
```elisp
(use-package package-name
  :bind (("C-c x" . new-command)  ; Add new binding
         ("C-c y" . another-command)))
```

**Modifying settings:**
```elisp
(use-package package-name
  :custom
  (package-variable-name new-value)
  (another-variable another-value))
```

**Adding hooks:**
```elisp
(use-package package-name
  :hook (some-mode . package-mode)  ; Enable package-mode in some-mode
  :config
  (add-hook 'some-mode-hook 'custom-function))
```

### Example Configurations

**Modify Corfu completion delay:**
```elisp
;; In conf/completion.el, find the corfu use-package and modify:
(use-package corfu
  :custom
  (corfu-auto-delay 0.1)  ; Change from 0.25 to 0.1 seconds
  (corfu-auto-prefix 3))  ; Change from 2 to 3 characters
```

**Add new consult keybinding:**
```elisp
;; In conf/completion.el, in the consult :bind section:
(use-package consult
  :bind (
         ;; ... existing bindings ...
         ("C-c s" . consult-line)))  ; Add new binding
```

**Configure eglot for new language (Python example):**
```elisp
;; In init.el, in the eglot :config section:
(use-package eglot
  :config
  ;; ... existing server configurations ...
  (add-to-list 'eglot-server-programs
               '(python-mode . ("pylsp")))  ; Use python-lsp-server
  :hook (python-mode . eglot-ensure))  ; Auto-start for Python files
```

**Modify which-key delay:**
```elisp
;; In init.el, find which-key configuration and modify:
(use-package which-key
  :custom
  (which-key-idle-delay 0.5))  ; Change from 1.0 to 0.5 seconds
```

### Configuration File Structure

```
billy-macs/
├── early-init.el          # Startup optimizations (loaded first)
├── init.el                # Main config (package declarations & loading)
├── conf/                  # Modular configuration files
│   ├── completion.el      # Modern completion stack (NEW)
│   ├── cider-conf.el      # Clojure/CIDER config
│   ├── rustic-conf.el     # Rust config (updated for eglot)
│   ├── avy-conf.el        # Navigation
│   └── ...
├── straight/
│   ├── repos/            # Package sources (COMMITTED to repo)
│   └── build/            # Compiled packages (IGNORED)
└── .local/               # Cache files (IGNORED, managed by no-littering)
```

### Best Practices

1. **Use `:demand t` sparingly** - Only for packages needed at startup
2. **Prefer lazy loading** - Most packages should load on-demand
3. **Group related settings** - Use `:custom` for variables, `:bind` for keys
4. **Document your changes** - Add comments explaining why you changed something
5. **Test incrementally** - Restart Emacs after each change to catch errors early
6. **Keep backups** - Billy-macs is in git, so commit before major changes

### Troubleshooting

**Package not loading:**
```elisp
;; Check if it's set to lazy load (remove :defer or add :demand t)
(use-package package-name
  :demand t)  ; Force immediate loading
```

**Keybinding not working:**
```elisp
;; Make sure package is loaded before binding
(use-package package-name
  :demand t    ; Ensure package is loaded
  :bind ...)
```

**Want to disable a package temporarily:**
```elisp
;; Comment out the use-package declaration
;; (use-package package-name ...)
```

**Check if package is installed:**
```
M-x straight-check-package RET package-name RET
```

**View all loaded packages:**
```
M-x straight-use-package-mode RET
```

---

## Quick Reference Card

### Essential New Shortcuts

| Shortcut | Command | Description |
|----------|---------|-------------|
| `C-x b` | consult-buffer | Buffer switching with preview |
| `C-x f` | consult-recent-file | Open recent file |
| `C-c l` | consult-line | Search current buffer |
| `C-c C-g` | consult-ripgrep | Project-wide search |
| `M-z` | undo-fu-only-undo | Undo |
| `M-Z` | undo-fu-only-redo | Redo |
| `C-x u` | vundo | Visual undo tree |
| `C-.` | embark-act | Context menu actions |
| `C-;` | embark-dwim | Smart default action |
| `` C-` `` | popper-toggle | Toggle popup window |
| `` M-` `` | popper-cycle | Cycle through popups |
| `C-h f` | helpful-callable | Better function help |
| `C-h v` | helpful-variable | Better variable help |

### Completion Shortcuts

| Context | Shortcut | Action |
|---------|----------|--------|
| Minibuffer | `C-n` / `C-p` | Next/previous candidate |
| Minibuffer | `M-RET` | Submit exact input |
| In-buffer | `TAB` | Next completion |
| In-buffer | `S-TAB` | Previous completion |
| In-buffer | `RET` | Insert completion |

---

## Migration Notes

### What Changed from Old Setup

**Replaced packages:**
- ~~ido + smex~~ → **vertico + consult**
- ~~auto-complete~~ → **corfu + cape**
- ~~undo-tree~~ → **undo-fu + vundo**
- ~~linum-mode~~ → **display-line-numbers-mode** (built-in)
- ~~lsp-mode~~ → **eglot** (built-in)
- ~~package.el~~ → **straight.el**

**Keybindings that changed:**
- Recent files: Still `C-x f` (now uses consult-recent-file instead of live-recentf-ido)
- Jump to symbol: Still `C-x C-i` (now uses consult-imenu instead of live-ido-goto-symbol)
- Buffer switch: Still `C-x b` (now uses consult-buffer instead of ido)
- All other major keybindings preserved!

**New directories:**
- `.local/` - Cache and data files (gitignored, managed by no-littering)
- `straight/repos/` - Package sources (committed to repo)
- `straight/build/` - Compiled packages (gitignored)

---

## Getting Help

**Within Emacs:**
- `C-h f function-name` - Describe function
- `C-h v variable-name` - Describe variable
- `C-h k key-sequence` - Describe what a key does
- `C-h m` - Describe current mode
- `C-h b` or `C-h B` - List all keybindings

**External Resources:**
- MODERNIZATION_PLAN.md - Full documentation of changes
- Package documentation: Most packages have README on GitHub
  - Vertico: https://github.com/minad/vertico
  - Consult: https://github.com/minad/consult
  - Corfu: https://github.com/minad/corfu
  - straight.el: https://github.com/radian-software/straight.el

---

**Last Updated:** November 2025
**For questions or issues:** Check the package documentation or open an issue in the package's GitHub repository.
