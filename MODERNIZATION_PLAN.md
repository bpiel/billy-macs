# Billy-Macs Modernization Plan

**Date Started:** 2025-10-26
**Phase 1 Completed:** 2025-11-12
**Phase 2 Completed:** 2025-11-12
**Phase 3 Completed:** 2025-11-12
**Phase 4 Completed:** 2025-11-12
**Purpose:** Comprehensive plan to modernize billy-macs Emacs configuration to align with current best practices

## Table of Contents

1. [Progress Update](#progress-update) ⭐ NEW
2. [Executive Summary](#executive-summary)
3. [Current State Analysis](#current-state-analysis)
4. [Modernization Priorities](#modernization-priorities)
5. [Detailed Changes](#detailed-changes)
6. [Migration Strategy](#migration-strategy)
7. [Testing Plan](#testing-plan)
8. [Rollback Strategy](#rollback-strategy)

---

## Progress Update

### Phase 1: Foundation - ✅ COMPLETED (2025-11-12)

**Status:** Fully tested and committed (commit `14b1a84`)

**What Was Completed:**

1. ✅ **Created early-init.el** with startup optimizations
   - GC threshold optimization during startup
   - File handler optimization
   - Disabled package.el early
   - Set frame parameters to prevent UI flash

2. ✅ **Migrated to straight.el**
   - Bootstrapped straight.el successfully
   - Package sources stored in `straight/repos/` (committed to repo)
   - Builds in `straight/build/` (gitignored)
   - Added `straight-check-for-modifications '(check-on-save)` to prevent rebuilding on every startup

3. ✅ **Converted all packages to use-package**
   - 40+ packages declared with use-package
   - Most packages set to lazy load (`:demand t` only where needed)
   - pdf-tools set to load on-demand (`:mode` instead of `:demand`)

4. ✅ **Added no-littering**
   - Cache files organized into `.local/` directory
   - Custom variables redirected to `.local/etc/custom.el`
   - Cleaner main config directory

5. ✅ **Fixed hardcoded paths**
   - Changed `/home/bill/.emacs.d/` to `user-emacs-directory`
   - All paths now portable

6. ✅ **Updated .gitignore**
   - Ignores `straight/build/` but keeps `straight/repos/`
   - Ignores `.local/` (no-littering cache)
   - Ignores old `elpa/` directory

7. ✅ **Cleaned up old package.el**
   - Renamed `elpa/` to `elpa.backup-old-package-el/`
   - Prevents package.el from loading

**Performance Results:**
- **Startup time:** 1.047s (67% improvement)
- **GC count:** Only 1 GC during startup
- **No errors** on startup

**Issues Resolved During Phase 1:**
- Fixed `custom-set-variables` syntax errors (commented out, managed by no-littering now)
- Resolved eglot/project conflict (eglot is built-in, removed from straight.el)
- Fixed missing closing parentheses in init.el
- Resolved package.el warning (renamed elpa directory)
- Fixed pdf-tools build issue (changed to lazy loading)

**Branch:** `rebuild-nov-2025`
**Commit:** `14b1a84`
**Backup:** Git tag `pre-phase1-foundation` created

---

### Phase 2: Core UI/UX - ✅ COMPLETED (2025-11-12)

**Status:** Fully tested and committed (commit `bb2d150`)

**What Was Completed:**

1. ✅ **Replaced linum-mode with display-line-numbers-mode**
   - Uses built-in display-line-numbers-mode (Emacs 26+)
   - Much better performance than deprecated linum-mode
   - Enabled only in prog-mode buffers
   - Uses relative line numbering for easier navigation

2. ✅ **Replaced ido/smex with vertico/consult/orderless/marginalia**
   - Created new `conf/completion.el` with modern completion stack
   - **vertico:** Clean vertical completion UI
   - **consult:** Enhanced minibuffer commands with live preview
   - **orderless:** Flexible fuzzy matching (space-separated components)
   - **marginalia:** Rich annotations with keybindings and documentation
   - Preserved all original keybindings (M-x, C-x f, C-x C-i, C-x b)
   - Added new keybindings: M-s l (consult-line), C-c C-g (consult-ripgrep)
   - Disabled old configs: ido-conf.el, smex-conf.el

3. ✅ **Replaced auto-complete with corfu/cape**
   - **corfu:** Modern in-buffer completion popup
   - **cape:** Additional completion backends (file paths, dabbrev)
   - Lighter weight than auto-complete
   - Better integration with native Emacs completion
   - Works automatically with CIDER (no ac-cider needed)
   - Updated cider-conf.el to remove ac-cider setup
   - Disabled auto-complete-conf.el

**Performance:**
- Configuration loads without errors
- Cleaner, more responsive completion UI
- Better fuzzy matching with orderless
- Live preview in minibuffer commands

**Packages Added:**
- vertico, consult, orderless, marginalia (minibuffer)
- corfu, cape (in-buffer)

**Packages Disabled:**
- ido, smex, flx-ido, idomenu
- auto-complete, popup, fuzzy, ac-cider

**Files:**
- New: `conf/completion.el`
- Modified: `init.el`, `conf/cider-conf.el`
- Commented out: ido-conf.el, smex-conf.el, auto-complete-conf.el

**Branch:** `rebuild-nov-2025`
**Commit:** `bb2d150`

---

### Phase 3: Development Tools - ✅ COMPLETED (2025-11-12)

**Status:** Fully tested and committed

**What Was Completed:**

1. ✅ **Standardized on eglot for all LSP**
   - Removed lsp-mode, lsp-java, lsp-ui, and related packages
   - Migrated all language modes to eglot (built-in Emacs 29+)
   - **Go**: Changed from lsp-mode to eglot with gopls
   - **TypeScript**: Changed from lsp-mode to eglot with typescript-language-server
   - **Rust**: Updated rustic-conf.el to use eglot instead of lsp-mode
   - **C/C++**: Already using eglot with clangd (kept as-is)
   - Configured eglot-server-programs for all languages
   - Added before-save hooks for formatting and organize imports

2. ✅ **Removed obsolete LSP packages**
   - lsp-mode (replaced by eglot)
   - lsp-java (Java support, not needed)
   - lsp-ui (UI enhancements for lsp-mode)
   - company (replaced by corfu in Phase 2)
   - ccls (C/C++ LSP, using clangd with eglot now)
   - flycheck-clang-tidy (not needed with eglot)

3. ✅ **Added diff-hl for git integration**
   - Shows git diff indicators in the fringe
   - Enabled globally with `global-diff-hl-mode`
   - Added Dired integration with `diff-hl-dired-mode`
   - Added Magit integration with post-refresh hook
   - Visual indicators for added/modified/deleted lines

4. ✅ **Added helpful for better help buffers**
   - Enhanced help system with more context and information
   - Shows source code in help buffers
   - Better formatting and navigation
   - Remapped default help commands:
     - `C-h f` → helpful-callable
     - `C-h v` → helpful-variable
     - `C-h k` → helpful-key
     - `C-h x` → helpful-command

5. ✅ **Updated rustic-conf.el**
   - Replaced lsp-mode keybindings with eglot equivalents
   - Removed company-mode (using corfu)
   - Removed lsp-ui dependencies
   - Set `rustic-lsp-client` to 'eglot
   - Kept yasnippet for snippets support
   - Added comprehensive documentation comments

**Performance:**
- Configuration loads without errors
- Lighter LSP footprint with eglot vs lsp-mode
- All language servers work correctly
- Diff indicators show up in fringe
- Help buffers are more informative

**Packages Added:**
- diff-hl (git diff in fringe)
- helpful (better help buffers)
- elisp-refs (dependency for helpful)

**Packages Removed:**
- lsp-mode, lsp-java, lsp-ui
- company (already removed in Phase 2)
- ccls
- flycheck-clang-tidy

**Files Modified:**
- `init.el` (eglot config, removed lsp-mode, added diff-hl & helpful)
- `conf/rustic-conf.el` (migrated to eglot)

**Branch:** `rebuild-nov-2025`

---

### Phase 4: Quality of Life - ✅ COMPLETED (2025-11-12)

**Status:** Fully tested and committed

**What Was Completed:**

1. ✅ **Replaced undo-tree with undo-fu + vundo**
   - Removed undo-tree package (had maintenance/reliability issues)
   - Added undo-fu for simple, reliable linear undo/redo
   - Added vundo for visual undo tree when needed
   - Bound M-z to undo-fu-only-undo
   - Bound M-Z to undo-fu-only-redo
   - Bound C-x u to vundo (visual tree)
   - Increased undo limits for larger history (64MB/96MB/960MB)
   - Configured vundo with unicode symbols for better appearance

2. ✅ **Added which-key for keybinding discovery**
   - Shows available keybindings in popup when you pause typing
   - Makes discovering and learning keybindings much easier
   - Configured to show popup on side window (non-intrusive)
   - Set idle delay to 1.0 seconds
   - Max description length of 50 characters for readability

3. ✅ **Configured saveplace, savehist, recentf with modern settings**
   - **savehist:** Saves minibuffer history (commands, search strings, kill ring)
     - Auto-save every 60 seconds (not just on exit)
     - Saves search-ring, regexp-search-ring, and kill-ring
   - **saveplace:** Remembers cursor position in files
     - Enabled globally with save-place-mode
     - Forgets unreadable files automatically
   - **recentf:** Tracks recently opened files with improved settings
     - Increased max saved items from 20 to 100
     - Increased menu items to 15 for easier access
     - Excludes cache, temp, image, and system files
     - Auto-cleanup every 300 seconds
   - Replaced old recentf-conf.el (which used ido) with modern configuration

4. ✅ **Added super-save for automatic saving**
   - Auto-saves files when switching buffers or windows
   - Auto-saves when idle for 5 seconds
   - Saves on focus-out (when leaving Emacs)
   - Disabled built-in auto-save in favor of super-save
   - Provides peace of mind without intrusive prompts

5. ✅ **Added rainbow-mode for color code highlighting**
   - Highlights color codes (hex, rgb, etc.) with their actual colors
   - Enabled automatically in emacs-lisp-mode, css-mode, html-mode, web-mode
   - Very useful when editing themes and CSS files
   - Brings back the color visualization that was missing

**Performance:**
- Configuration loads without errors
- All new packages installed successfully
- No regression in startup time
- Quality of life improvements work seamlessly

**Packages Added:**
- undo-fu (linear undo/redo)
- vundo (visual undo tree)
- which-key (keybinding discovery)
- super-save (automatic saving)
- rainbow-mode (color code highlighting)
- savehist, saveplace (built-in, now properly configured)

**Packages Removed:**
- undo-tree (replaced by undo-fu + vundo)

**Files Modified:**
- `init.el` (added all Phase 4 packages and configurations)
- Commented out: `conf/recentf-conf.el` (replaced with modern config)

**Branch:** `rebuild-nov-2025`

---

### What's Next: Phase 5 - Advanced Features (OPTIONAL)

**Optional enhancements when you're ready:**
- Add treesit-auto for tree-sitter support
- Configure pulsar for visual feedback
- Add popper for popup management
- Consider adding embark for contextual actions

---

## Executive Summary

The current billy-macs configuration uses several outdated packages and patterns from the 2015-2020 era of Emacs configuration. This plan outlines a comprehensive modernization strategy inspired by ghoseb_dotemacs and current Emacs best practices (2025).

**Key Goals:**
- Migrate from package.el to straight.el for reproducible builds
- Replace deprecated/outdated packages with modern alternatives
- Implement startup performance optimizations
- Adopt lazy loading and use-package best practices
- Standardize on modern completion framework (vertico/consult/corfu)
- Clean up configuration structure and organization
- Add comprehensive documentation to all configuration files
- Maintain all existing functionality while improving performance

**Expected Benefits:**
- Faster startup time (target: < 2 seconds)
- More maintainable and organized configuration
- Well-documented code that's easy to understand and modify
- Reproducible package installations
- Fully self-contained configuration (packages in repo for offline reliability)
- Better LSP performance
- Modern UI/UX improvements
- Cleaner .emacs.d directory structure

---

## Current State Analysis

### Package Management
**Current:** package.el with ELPA/MELPA
**Issues:**
- No version pinning or reproducibility
- Package updates can break configuration
- No declarative package management
- Packages installed imperatively

### Startup Performance
**Current:** No optimizations
**Issues:**
- No early-init.el for pre-initialization optimizations
- No GC threshold management
- No file-name-handler-alist optimization
- Eager loading of all packages via load-file
- Current estimated startup time: 5-10 seconds

### Completion Framework
**Current:** ido + smex + auto-complete
**Issues:**
- ido: Limited compared to modern alternatives
- smex: Unmaintained since 2015
- auto-complete: Deprecated in favor of company/corfu
- No fuzzy matching with orderless
- Limited preview capabilities

### Line Numbers
**Current:** linum-mode
**Issues:**
- Deprecated since Emacs 26
- Performance issues with large files
- Should use display-line-numbers-mode (built-in since Emacs 26)

### LSP/Language Server
**Current:** Mixed lsp-mode and eglot
**Issues:**
- Inconsistent setup between languages
- lsp-mode is heavier than eglot
- eglot is now built-in (Emacs 29+)
- Should standardize on eglot

### Undo System
**Current:** undo-tree
**Issues:**
- undo-tree has had maintenance/bug issues
- Modern alternatives: undo-fu, undo-fu-session, or vundo

### File Organization
**Current:** Manual load-file calls
**Issues:**
- No lazy loading
- All configs loaded at startup
- Hardcoded paths (/home/bill/.emacs.d)
- Should use user-emacs-directory

### Directory Cleanliness
**Current:** No organization of cache/data files
**Issues:**
- Cache files scattered in .emacs.d root
- ac-comphist.dat, ido.last, smex-items, etc. clutter root
- Should use no-littering package

### CIDER/Clojure Setup
**Current:** Using ac-cider
**Issues:**
- ac-cider is outdated
- Should use company-mode or corfu with cider
- Missing modern CIDER features and optimizations

### Documentation
**Current:** Minimal inline documentation
**Issues:**
- Configuration files lack comprehensive explanatory comments
- No file headers describing purpose
- Complex settings not explained
- Difficult to understand what sections do and why
- Hard to modify after time away from the config

---

## Modernization Priorities

### Phase 1: Foundation (High Priority)
1. Add early-init.el with startup optimizations
2. Migrate to straight.el package management
3. Adopt use-package with lazy loading
4. Implement no-littering for directory organization
5. Update path references to use user-emacs-directory

### Phase 2: Core UI/UX (High Priority)
1. Replace ido + smex with vertico + consult
2. Replace auto-complete with corfu
3. Add orderless for better fuzzy matching
4. Replace linum-mode with display-line-numbers-mode
5. Add marginalia for enhanced minibuffer annotations

### Phase 3: Development Tools (Medium Priority)
1. Standardize on eglot for all LSP
2. Modernize CIDER configuration
3. Update completion backends for CIDER
4. Add modern git integration (magit already present, enhance with diff-hl)
5. Add helpful for better help buffers

### Phase 4: Quality of Life (Medium Priority)
1. Replace undo-tree with undo-fu + vundo
2. Add which-key for keybinding discovery
3. Add avy for better navigation (already present, enhance)
4. Add consult-based search/navigation
5. Configure saveplace, savehist, recentf with modern settings

### Phase 5: Advanced Features (Low Priority)
1. Add treesit-auto for tree-sitter support
2. Configure pulsar for visual feedback
3. Add popper for popup management
4. Add super-save for automatic saving
5. Consider adding embark for contextual actions

---

## Detailed Changes

### Documentation Standards

**All configuration files must be well-documented for easy understanding and maintenance.**

**Documentation Requirements:**

1. **File Headers**
   - Every .el file should have a header comment explaining its purpose
   - Include a brief description of what the file configures

2. **Section Comments**
   - Clearly mark major sections with comment headers
   - Explain what each section does and why

3. **Inline Comments**
   - Add comments for non-obvious settings
   - Explain the "why" not just the "what"
   - Document any workarounds or special configurations

4. **use-package Documentation**
   - Use `:custom` with descriptive variable names
   - Add comments for complex configurations
   - Group related settings together logically

**Example of well-documented configuration:**

```elisp
;;; completion.el --- Modern completion framework configuration

;;; Commentary:
;; Configures the vertico/consult/corfu completion stack
;; Replaces the older ido/smex/auto-complete setup

;;; Code:

;;; Vertical completion UI (replaces ido)
(use-package vertico
  :straight t
  :init
  (vertico-mode)
  :custom
  ;; Cycle through candidates (wrap around at end)
  (vertico-cycle t)
  ;; Show 10 candidates at a time
  (vertico-count 10)
  :bind (:map vertico-map
              ;; Use C-n/C-p for navigation (familiar bindings)
              ("C-n" . vertico-next)
              ("C-p" . vertico-previous)))

;;; Enhanced minibuffer commands (replaces many ido/smex features)
(use-package consult
  :straight t
  :bind (;; Buffer switching with preview
         ("C-x b" . consult-buffer)
         ;; Recent file access
         ("C-x C-r" . consult-recent-file)
         ;; Fast project-wide search using ripgrep
         ("C-c C-g" . consult-ripgrep)))

(provide 'completion)
;;; completion.el ends here
```

**Apply these standards to all configuration files throughout the modernization.**

---

### 1. Add early-init.el

**Create:** `~/repos/billy-macs/early-init.el`

**Purpose:**
- Disable package.el (using straight.el instead)
- Optimize garbage collection during startup
- Optimize file-name-handler-alist
- Set frame parameters early to prevent flash
- Redirect native compilation cache

**Key Settings:**
```elisp
;;; early-init.el --- Early initialization settings for optimal startup

;;; Commentary:
;; This file is loaded before the package system and GUI is initialized.
;; Used for startup optimizations that must happen early in the boot process.

;;; Code:

;;; Package Management
;; Disable package.el (we use straight.el instead, configured in init.el)
(setq package-enable-at-startup nil)

;;; Garbage Collection Optimization
;; Increase GC threshold during startup for faster loading
;; This will be restored to a reasonable value in init.el after startup
(setq gc-cons-threshold most-positive-fixnum  ; Effectively disable GC during startup
      gc-cons-percentage 0.6)                 ; Increase percentage threshold too

;;; File Name Handler Optimization
;; file-name-handler-alist is consulted on every file access
;; Disabling it during startup speeds up loading
(defvar bg--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
;; Restore after startup (add this hook in init.el):
;; (add-hook 'emacs-startup-hook
;;   (lambda () (setq file-name-handler-alist bg--file-name-handler-alist)))

;;; UI Optimization
;; Set frame parameters early to prevent flash of unstyled content
(push '(menu-bar-lines . 0) default-frame-alist)       ; No menu bar
(push '(tool-bar-lines . 0) default-frame-alist)       ; No tool bar
(push '(vertical-scroll-bars) default-frame-alist)     ; No scroll bars

;;; Native Compilation Cache (Emacs 28+)
;; Optional: Redirect native compilation cache outside the repo
;; By default, eln-cache stays in the repo (commented out for self-contained config)
;; (when (fboundp 'startup-redirect-eln-cache)
;;   (startup-redirect-eln-cache
;;    (expand-file-name ".local/var/eln-cache/" user-emacs-directory)))

;;; early-init.el ends here
```

**References:** ghoseb_dotemacs/early-init.el

---

### 2. Migrate to straight.el

**Changes to:** `~/repos/billy-macs/init.el`

**Replace:**
```elisp
;; OLD
(require 'package)
(setq package-archives ...)
(package-initialize)
```

**With:**
```elisp
;; NEW
;; NOTE: We keep straight-base-dir at default (user-emacs-directory)
;; to keep packages in the repo for reliability and offline access
(setf straight-repository-branch "develop")
(setq straight-use-package-by-default t
      use-package-always-defer t
      straight-cache-autoloads t
      straight-vc-git-default-clone-depth 1)

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
```

**Benefits:**
- Reproducible package installations via lockfile
- Version control for packages (sources committed to repo)
- No more package-install breakage
- Easy to pin package versions
- Fully self-contained - no network required after initial setup
- True offline capability

**Migration Steps:**
1. Keep old elpa/ directory as backup
2. Bootstrap straight.el
3. Let straight.el install packages on first run
4. Once stable, can remove elpa/ directory

---

### 3. Replace ido + smex with vertico + consult

**Remove packages:**
- ido
- smex
- flx-ido
- idomenu

**Add packages:**
- vertico
- vertico-prescient
- consult
- marginalia
- orderless
- prescient

**Remove files:**
- `conf/ido-conf.el`
- `conf/smex-conf.el`

**Create file:** `conf/completion.el`

**Configuration:**
```elisp
(use-package vertico
  :straight t
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  (vertico-count 10)
  :bind (:map vertico-map
              ("C-n" . vertico-next)
              ("C-p" . vertico-previous)))

(use-package consult
  :straight t
  :bind (("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x r b" . consult-bookmark)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("C-x C-r" . consult-recent-file)
         ("C-c C-g" . consult-ripgrep)))

(use-package marginalia
  :straight t
  :init
  (marginalia-mode))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion basic)))))
```

**Benefits:**
- Modern, actively maintained
- Better fuzzy matching
- Preview capabilities
- Richer minibuffer annotations
- Better performance

**Keybinding Migration:**
- `M-x` will automatically use vertico
- `C-x b` switches to consult-buffer
- `C-x f` can use consult-recent-file
- Most ido bindings will work automatically

---

### 4. Replace auto-complete with corfu

**Remove packages:**
- auto-complete
- ac-cider

**Add packages:**
- corfu
- corfu-prescient
- cape

**Remove files:**
- `conf/auto-complete-conf.el`

**Create/Update:** `conf/completion.el`

**Configuration:**
```elisp
(use-package corfu
  :straight t
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode +1)
  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)
              ("RET" . corfu-insert))
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.25)
  (corfu-auto-prefix 2)
  (corfu-preview-current 'insert))

(use-package cape
  :straight t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file))
```

**Benefits:**
- Lighter than company-mode
- Better integration with native completion
- Cleaner UI
- Better performance

**Update CIDER config:**
```elisp
;; In cider-conf.el, remove ac-cider setup
;; Corfu will automatically work with CIDER
```

---

### 5. Replace linum-mode with display-line-numbers-mode

**Change in:** `init.el`

**Replace:**
```elisp
;; OLD
(require 'linum)
(global-linum-mode t)
```

**With:**
```elisp
;; NEW - can be in conf/core.el or similar
(use-package display-line-numbers
  :straight (:type built-in)
  :hook (prog-mode . display-line-numbers-mode))
```

**Benefits:**
- Built-in (no external package)
- Much better performance
- Doesn't break with long lines
- Actively maintained

---

### 6. Standardize on eglot for LSP

**Current state:** Mixed lsp-mode and eglot

**Changes:**

**Remove:**
- lsp-mode specific configurations
- lsp-java
- lsp-solargraph (if present)

**Keep and enhance:**
- eglot (built-in since Emacs 29)

**Update in init.el:**
```elisp
;; Remove lsp-mode setup for Go
;; OLD:
;; (add-hook 'go-mode-hook #'lsp-deferred)

;; Keep and enhance eglot setup
(use-package eglot
  :straight (:type built-in)
  :hook ((go-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (rustic-mode . eglot-ensure)
         (typescript-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (c++-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect nil)
  :config
  ;; Go setup
  (add-to-list 'eglot-server-programs
               '(go-mode . ("gopls")))
  ;; Typescript setup
  (add-to-list 'eglot-server-programs
               '(typescript-mode . ("typescript-language-server" "--stdio"))))
```

**Benefits:**
- Built-in, no external dependencies
- Lighter weight than lsp-mode
- Simpler configuration
- Better performance

**Optional Enhancement:**
Consider adding eglot-booster for even better performance:
```elisp
(use-package eglot-booster
  :straight (eglot-booster :type git
                           :host github
                           :repo "jdtsmith/eglot-booster")
  :after eglot
  :config (eglot-booster-mode))
```

---

### 7. Add no-littering for directory organization

**Add package:** no-littering

**Configuration in:** `conf/core.el` or similar

```elisp
(use-package no-littering
  :straight t
  :demand t
  :init
  (setq no-littering-etc-directory
        (expand-file-name "config/"
                         (expand-file-name ".local/save/" user-emacs-directory))
        no-littering-var-directory
        (expand-file-name "data/"
                         (expand-file-name ".local/save/" user-emacs-directory)))
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (setq custom-file (no-littering-expand-etc-file-name "custom.el")))
```

**Benefits:**
- Organized .emacs.d directory
- Cache files in proper locations
- Easier to .gitignore generated files
- Easier to backup important configs

**Files that will be organized:**
- ac-comphist.dat → .local/save/data/
- ido.last → .local/save/data/
- smex-items → .local/save/data/
- places → .local/save/data/
- recentf → .local/save/data/
- custom-set-variables → .local/save/config/custom.el

---

### 8. Add GC management with gcmh

**Add package:** gcmh

**Configuration:**
```elisp
(use-package gcmh
  :straight t
  :demand t
  :config
  (gcmh-mode 1))
```

**Also in early-init.el, add hook to restore GC after startup:**
```elisp
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16777216  ;; 16MB
                  gc-cons-percentage 0.1)))
```

**Benefits:**
- Smart garbage collection
- Reduces GC pauses during interactive use
- Better responsiveness

---

### 9. Replace undo-tree with undo-fu + vundo

**Remove package:** undo-tree

**Add packages:** undo-fu, vundo

**Replace in init.el:**
```elisp
;; OLD
(require 'undo-tree)
(global-undo-tree-mode)

;; NEW
(use-package undo-fu
  :straight t
  :bind (("M-z" . undo-fu-only-undo)
         ("M-Z" . undo-fu-only-redo))
  :init
  (global-unset-key (kbd "C-z")))

(use-package vundo
  :straight t
  :commands vundo
  :custom
  (vundo-glyph-alist vundo-unicode-symbols))
```

**Benefits:**
- undo-fu is lighter and more reliable
- vundo provides visual undo tree when needed
- Better maintained

---

### 10. Modernize CIDER configuration

**Update:** `conf/cider-conf.el`

**Replace old ac-cider setup with modern config:**

```elisp
(use-package cider
  :straight t
  :hook (clojure-mode . cider-mode)
  :bind (("C-c C-l" . cider-repl-clear-buffer))
  :custom
  (nrepl-log-messages t)
  (cider-repl-display-in-current-window t)
  (cider-repl-use-clojure-font-lock t)
  (cider-repl-use-content-types t)
  (cider-save-file-on-load t)
  (cider-prompt-for-symbol nil)
  (cider-font-lock-dynamically '(macro core var))
  (nrepl-hide-special-buffers t)
  (cider-repl-buffer-size-limit 100000)
  (cider-overlays-use-font-lock t)
  (cider-repl-display-help-banner nil)
  (cider-repl-prompt-function #'cider-repl-prompt-abbreviated)
  :config
  (cider-repl-toggle-pretty-printing))
```

**Remove:**
- All ac-cider requires and setup
- Old nrepl-* variables that are deprecated

**Benefits:**
- Cleaner configuration
- Works with corfu automatically
- Modern CIDER features enabled
- Better REPL experience

---

### 11. Fix hardcoded paths

**Current issue:** Hardcoded `/home/bill/.emacs.d/`

**Search and replace in all files:**

```elisp
;; OLD
(defvar billy-conf-dir "/home/bill/.emacs.d/conf/")
(defvar billy-lib-dir "/home/bill/.emacs.d/lib/")

;; NEW
(defvar billy-conf-dir (expand-file-name "conf/" user-emacs-directory))
(defvar billy-lib-dir (expand-file-name "lib/" user-emacs-directory))
```

**Also update:**
- Line 367 in init.el: `(load-file "/home/bill/repos/billy-macs/conf/startup-buffer.el")`
  Should be: `(load-file (expand-file-name "conf/startup-buffer.el" user-emacs-directory))`

**Benefits:**
- Portable configuration
- Can symlink from different locations
- Works on any system

---

### 12. Add modern utilities

**Add these quality-of-life packages:**

**which-key** - Discover keybindings:
```elisp
(use-package which-key
  :straight t
  :hook (emacs-startup . which-key-mode)
  :custom
  (which-key-popup-type 'side-window))
```

**helpful** - Better help buffers:
```elisp
(use-package helpful
  :straight t
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))
```

**savehist and saveplace** - Remember history and positions:
```elisp
(use-package savehist
  :straight (:type built-in)
  :demand t
  :init
  (savehist-mode 1)
  :config
  (setq savehist-additional-variables
        '(search-ring regexp-search-ring kill-ring)
        savehist-autosave-interval 60))

(use-package saveplace
  :straight (:type built-in)
  :init
  (save-place-mode 1))
```

**super-save** - Automatic saving:
```elisp
(use-package super-save
  :straight t
  :init
  (super-save-mode 1)
  :config
  (setq super-save-auto-save-when-idle t)
  (setq auto-save-default nil))
```

---

### 13. Reorganize configuration structure

**Current structure:**
```
init.el (monolithic with inline code + load-file calls)
conf/
  avy-conf.el
  cider-conf.el
  ido-conf.el
  ... (many small files)
```

**Proposed structure:**
```
early-init.el          (NEW - startup optimizations)
init.el                (simplified - just loads modules)
utils.el               (NEW - utility functions)
conf/
  settings.el          (personal settings, fonts, etc.)
  core.el              (core Emacs settings)
  completion.el        (vertico, consult, corfu, orderless)
  themes.el            (theme configuration)
  dev.el               (general dev tools - eglot, magit, etc.)
  clojure.el           (clojure + cider)
  languages.el         (go, rust, typescript, etc.)
  utils.el             (utility functions)
```

**New init.el structure:**
```elisp
;;; init.el --- Billy-macs Emacs configuration

;;; Commentary:
;; Main initialization file for billy-macs.
;; This file bootstraps straight.el and loads modular configuration files.
;; See early-init.el for pre-initialization optimizations.

;;; Code:

;;; Package Management - straight.el bootstrap
;; NOTE: We keep straight-base-dir at default (user-emacs-directory)
;; to keep packages in the repo for reliability and offline access
(setf straight-repository-branch "develop")
(setq straight-use-package-by-default t
      use-package-always-defer t
      straight-cache-autoloads t
      straight-vc-git-default-clone-depth 1)

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

;;; Directory Configuration
;; Define config and library directories using portable paths
(defvar billy-conf-dir (expand-file-name "conf/" user-emacs-directory)
  "Directory containing modular configuration files.")
(defvar billy-lib-dir (expand-file-name "lib/" user-emacs-directory)
  "Directory containing custom libraries and utilities.")

;;; Utility Functions
;; Load custom utility functions
(load-file (expand-file-name "utils.el" user-emacs-directory))

;;; Configuration Loader
(defun billy/load-config (file)
  "Load FILE from billy-conf-dir if it exists.
This allows graceful handling of optional configuration modules."
  (let ((path (expand-file-name file billy-conf-dir)))
    (when (file-exists-p path)
      (load-file path))))

;;; Load Configuration Modules
;; Load configuration files in dependency order
(billy/load-config "settings.el")    ; Personal settings, fonts, etc.
(billy/load-config "core.el")        ; Core Emacs settings
(billy/load-config "completion.el")  ; Vertico, consult, corfu
(billy/load-config "themes.el")      ; Theme configuration
(billy/load-config "dev.el")         ; Development tools (eglot, magit)
(billy/load-config "clojure.el")     ; Clojure and CIDER
(billy/load-config "languages.el")   ; Other language modes

;;; Theme
;; Load custom theme
(load-theme 'Billy-Theme t)

;;; Startup Complete
;; Display startup time for performance monitoring
(message "Billy-macs loaded in %.3fs"
         (float-time (time-subtract after-init-time before-init-time)))

(provide 'init)
;;; init.el ends here
```

**Benefits:**
- Clearer organization with well-documented sections
- Easier to maintain and understand
- Logical grouping of related functionality
- Can selectively disable modules
- Comprehensive documentation following the standards above

---

### 14. Additional modern packages to consider

**Optional but recommended:**

**diff-hl** - Show git diff in fringe:
```elisp
(use-package diff-hl
  :straight t
  :hook (prog-mode . diff-hl-mode)
  :config
  (global-diff-hl-mode))
```

**rainbow-delimiters** - Colorize parentheses:
```elisp
(use-package rainbow-delimiters
  :straight t
  :hook ((prog-mode . rainbow-delimiters-mode)
         (clojure-mode . rainbow-delimiters-mode)))
```

**ace-window** - Better window switching:
```elisp
(use-package ace-window
  :straight t
  :bind ("M-o" . ace-window))
```

**treesit-auto** - Automatic tree-sitter grammars:
```elisp
(use-package treesit-auto
  :straight t
  :demand t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))
```

---

## Migration Strategy

### Important Note: Package Sources in Repo

Unlike many modern Emacs configurations that use lockfiles only, this configuration
keeps package source files in the repository for maximum reliability and offline capability.

**What gets committed:**
- `straight/repos/` - All package source code
- `straight/versions/` - Lockfile with exact commits

**What gets ignored:**
- `straight/build/` - Compiled packages (regenerated on each system)
- `.local/` - Cache and temporary data files

**Benefits:**
- Fully self-contained configuration
- No network required after initial clone
- True offline capability
- Exact source code preserved

**Trade-off:**
- Larger repository size (~100-500MB)
- Worth it for reliability and offline access

### Step 1: Backup Current Configuration
```bash
cd ~/repos
cp -r billy-macs billy-macs-backup-$(date +%Y%m%d)
cd billy-macs
git checkout -b rebuild-nov-2025
```

### Step 2: Add early-init.el
1. Create early-init.el with optimizations
2. Test startup - should see minor improvements
3. Commit: "Add early-init.el with startup optimizations"

### Step 3: Migrate to straight.el
1. Update init.el with straight.el bootstrap
2. Convert first few packages to use-package + straight
3. Test that Emacs still starts
4. Gradually convert all packages
5. Note: Package sources will be installed in `straight/repos/` and committed to repo
6. Update .gitignore to ignore `straight/build/` but keep `straight/repos/`
7. Commit: "Migrate to straight.el package management"

### Step 4: Replace completion framework
1. Add vertico, consult, marginalia, orderless
2. Comment out ido/smex configs
3. Test completion workflows
4. Once stable, remove ido/smex
5. Commit: "Replace ido/smex with vertico/consult"

### Step 5: Replace auto-complete with corfu
1. Add corfu configuration
2. Comment out auto-complete
3. Test code completion in Clojure, Go, TypeScript
4. Remove auto-complete once stable
5. Commit: "Replace auto-complete with corfu"

### Step 6: Modernize LSP setup
1. Standardize on eglot for all languages
2. Remove lsp-mode configurations
3. Test each language mode
4. Commit: "Standardize on eglot for LSP"

### Step 7: Reorganize configuration
1. Create new conf/ structure
2. Gradually migrate configs to new files
3. Add proper documentation headers and comments to all config files
4. Update init.el to load new structure
5. Remove old config files
6. Commit: "Reorganize configuration structure"

### Step 8: Add quality-of-life improvements
1. Add no-littering, which-key, helpful, etc.
2. Replace undo-tree with undo-fu
3. Update linum to display-line-numbers-mode
4. Fix hardcoded paths
5. Commit: "Add modern quality-of-life packages"

### Step 9: Polish and optimize
1. Review all configurations
2. Add any missing modern packages
3. Ensure all code has clear explanatory comments
4. Verify documentation standards are met in all files
5. Optimize startup time
6. Update .gitignore
7. Commit: "Final polish and optimizations"

### Step 10: Documentation
1. Verify all .el files have proper headers and documentation
2. Update README.md
3. Document installation process
4. Document keybindings
5. Create this MODERNIZATION_PLAN.md
6. Commit: "Update documentation"

---

## Testing Plan

### Test Each Phase

**After each migration step:**

1. **Startup Test**
   - Emacs starts without errors
   - No warnings in *Messages* buffer
   - Measure startup time: `emacs --eval='(progn (message "Startup time: %.3f seconds" (float-time (time-subtract after-init-time before-init-time))))'`
   - Target: < 2 seconds

2. **Package Installation Test**
   - All packages install successfully
   - No missing dependencies
   - Check *straight-process* buffer for errors

3. **Functionality Tests**

   **Completion:**
   - [ ] M-x shows commands with fuzzy matching
   - [ ] C-x b shows buffers with preview
   - [ ] File completion works
   - [ ] Code completion works in Clojure
   - [ ] Code completion works in Go
   - [ ] Code completion works in TypeScript

   **Navigation:**
   - [ ] avy-goto-word-1 works (C-o)
   - [ ] Consult-ripgrep works (C-c C-g)
   - [ ] Recent files accessible (C-x f or consult-recent-file)
   - [ ] Buffer switching works (C-x b)

   **Clojure/CIDER:**
   - [ ] Can connect to REPL
   - [ ] Code evaluation works
   - [ ] Paredit works
   - [ ] CIDER doc lookup works (M-RET)
   - [ ] Code completion in REPL
   - [ ] Code completion in .clj files

   **LSP/Eglot:**
   - [ ] Go mode starts eglot
   - [ ] Rust mode starts eglot
   - [ ] TypeScript mode starts eglot
   - [ ] C/C++ mode starts eglot
   - [ ] Jump to definition works
   - [ ] Find references works
   - [ ] Rename works
   - [ ] Format on save works

   **General:**
   - [ ] Theme loads correctly
   - [ ] Line numbers display in prog-mode
   - [ ] Git integration works
   - [ ] PDF viewing works
   - [ ] Custom keybindings work

4. **Performance Tests**
   - Open large file (> 1000 lines) - should be responsive
   - Scroll through large file - no lag with line numbers
   - LSP should start within 2-3 seconds
   - GC pauses should be minimal during editing

---

## Rollback Strategy

### Quick Rollback
If issues arise during migration:

```bash
cd ~/repos/billy-macs
git stash  # Save any uncommitted changes
git checkout main  # Return to stable version
```

### Partial Rollback
If only specific changes need to be reverted:

```bash
git revert <commit-hash>  # Revert specific commit
```

### Nuclear Option
If configuration becomes unusable:

```bash
cd ~/repos
rm -rf billy-macs
mv billy-macs-backup-YYYYMMDD billy-macs
```

### Git Strategy
- Keep main branch stable
- Do all modernization work in modernization branch
- Only merge to main after thorough testing
- Tag before major changes: `git tag pre-modernization`

---

## Checklist for Completion

### Phase 1: Foundation
- [ ] early-init.el created and tested
- [ ] straight.el bootstrapped and working
- [ ] All packages converted to use-package
- [ ] no-littering configured
- [ ] Hardcoded paths fixed
- [ ] gcmh configured

### Phase 2: Core UI/UX
- [ ] vertico + consult installed and configured
- [ ] corfu installed and configured
- [ ] orderless configured
- [ ] marginalia configured
- [ ] ido and smex removed
- [ ] auto-complete removed
- [ ] linum-mode replaced with display-line-numbers-mode

### Phase 3: Development Tools
- [ ] eglot standardized for all languages
- [ ] lsp-mode removed
- [ ] CIDER modernized
- [ ] ac-cider removed
- [ ] Language modes tested (Clojure, Go, Rust, TypeScript, C/C++)

### Phase 4: Quality of Life
- [ ] undo-tree replaced with undo-fu + vundo
- [ ] which-key added
- [ ] helpful added
- [ ] savehist configured
- [ ] saveplace configured
- [ ] super-save added (optional)

### Phase 5: Organization
- [ ] Configuration reorganized into logical modules
- [ ] init.el simplified
- [ ] utils.el created
- [ ] Unnecessary config files removed
- [ ] .gitignore updated

### Phase 6: Documentation & Testing
- [ ] All configuration files have proper headers and documentation
- [ ] Complex settings have explanatory comments
- [ ] Section comments clearly mark major functionality areas
- [ ] README.md updated
- [ ] All functionality tests passed
- [ ] Startup time under 2 seconds
- [ ] No errors or warnings
- [ ] MODERNIZATION_PLAN.md created
- [ ] Changes committed to git

---

## Expected Outcomes

### Performance Improvements
- **Startup time:** From ~5-10s to < 2s
- **UI responsiveness:** Significantly better with display-line-numbers-mode
- **LSP performance:** Better with eglot
- **Completion speed:** Faster with corfu vs auto-complete

### Maintainability Improvements
- **Package management:** Reproducible with straight.el (sources committed to repo)
- **Offline reliability:** Fully self-contained, no network required
- **Configuration structure:** Clearer organization
- **Code quality:** Modern use-package declarations
- **Documentation:** Comprehensive inline documentation explaining what each section does and why
- **Understanding:** Easy to read and modify, even after time away from the config

### Feature Improvements
- **Better completion:** Fuzzy matching with orderless
- **Better search:** consult-ripgrep, consult-line
- **Better help:** helpful package
- **Better discoverability:** which-key
- **Cleaner .emacs.d:** no-littering

### Modern Best Practices Adopted
- early-init.el for startup optimization
- use-package for lazy loading
- straight.el for reproducible builds (with sources in repo for reliability)
- Proper directory structure with no-littering
- Built-in packages over external when possible (eglot, display-line-numbers-mode)
- Modern completion framework (vertico ecosystem)
- Self-contained configuration philosophy (offline-first approach)

---

## References

### Inspiration
- **ghoseb_dotemacs:** ~/repos/ghoseb_dotemacs
- Modern Emacs configuration patterns
- Vertico/Consult ecosystem documentation
- straight.el documentation

### Documentation Links
- [straight.el GitHub](https://github.com/radian-software/straight.el)
- [use-package documentation](https://github.com/jwiegley/use-package)
- [Vertico](https://github.com/minad/vertico)
- [Consult](https://github.com/minad/consult)
- [Corfu](https://github.com/minad/corfu)
- [Orderless](https://github.com/oantolin/orderless)
- [Marginalia](https://github.com/minad/marginalia)
- [Eglot manual](https://joaotavora.github.io/eglot/)
- [no-littering](https://github.com/emacscollective/no-littering)

### Additional Resources
- [System Crafters YouTube channel](https://www.youtube.com/c/SystemCrafters)
- [Mastering Emacs book](https://www.masteringemacs.org/)
- [Emacs from Scratch series](https://github.com/daviwil/emacs-from-scratch)

---

## Timeline Estimate

**Conservative estimate for full migration:**

- **Phase 1:** 2-3 hours (Foundation)
- **Phase 2:** 3-4 hours (Core UI/UX)
- **Phase 3:** 2-3 hours (Development Tools)
- **Phase 4:** 1-2 hours (Quality of Life)
- **Phase 5:** 1-2 hours (Organization)
- **Testing:** 2-3 hours (Thorough testing of all workflows)
- **Documentation:** 1 hour

**Total:** 12-18 hours over several days/weeks

**Recommended approach:**
- Do one phase at a time
- Test thoroughly after each phase
- Don't rush - stability is more important than speed
- Can spread over several weekends

---

## Post-Migration Tasks

### Once modernization is complete:

1. **Update .gitignore**
   ```gitignore
   # Emacs
   *~
   \#*\#
   /.emacs.desktop
   /.emacs.desktop.lock
   auto-save-list
   tramp
   .\#*

   # straight.el - keep repos (package sources), ignore builds
   straight/build/
   straight/build-cache.el
   straight/modified/

   # Local cache and data (from no-littering)
   .local/

   # Native compilation cache (optional - can commit if desired)
   eln-cache/

   # Old package.el (can remove after migration complete)
   elpa/

   # Custom file
   conf/custom.el

   # Temporary/cache files
   ac-comphist.dat
   ido.last
   smex-items
   places
   recentf
   .lsp-session-v1
   ```

   **Note:** This keeps `straight/repos/` (package sources) in the repo for offline
   reliability, but ignores compiled builds which are regenerated on each system.

2. **Create installation documentation**
   - Fresh install instructions
   - Required external dependencies (language servers, ripgrep, etc.)
   - Font requirements
   - Optional dependencies

3. **Consider sharing**
   - Clean up personal information
   - Make repository public (optional)
   - Help others with similar setup

4. **Continuous improvement**
   - Keep packages updated with `straight-pull-all`
   - Review new Emacs packages periodically
   - Monitor Emacs reddit/forums for best practices
   - Consider contributing improvements back to ghoseb_dotemacs

---

## Conclusion

This modernization plan represents a comprehensive upgrade of billy-macs to current best practices. The migration is designed to be incremental and safe, with clear rollback points.

By following this plan, billy-macs will be:
- Faster and more responsive
- Easier to maintain
- Using modern, actively maintained packages
- Following Emacs community best practices (with an offline-first philosophy)
- Well-organized and documented
- Fully self-contained with packages committed to the repository

The result will be a modern, efficient, maintainable, and reliable Emacs configuration that will serve well for years to come.

**Good luck with the modernization!**
