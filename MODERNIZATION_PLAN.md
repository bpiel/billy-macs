# Billy-Macs Modernization Plan

**Date:** 2025-10-26
**Purpose:** Comprehensive plan to modernize billy-macs Emacs configuration to align with current best practices

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current State Analysis](#current-state-analysis)
3. [Modernization Priorities](#modernization-priorities)
4. [Detailed Changes](#detailed-changes)
5. [Migration Strategy](#migration-strategy)
6. [Testing Plan](#testing-plan)
7. [Rollback Strategy](#rollback-strategy)

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
- Maintain all existing functionality while improving performance

**Expected Benefits:**
- Faster startup time (target: < 2 seconds)
- More maintainable and organized configuration
- Reproducible package installations
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
;; Disable package.el
(setq package-enable-at-startup nil)

;; GC optimization
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; file-name-handler-alist optimization
(defvar bg--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Frame parameters (prevent flash)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Native compilation cache
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name ".local/var/eln-cache/" user-emacs-directory)))
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
(setf straight-base-dir (expand-file-name ".local/var/" user-emacs-directory))
(setf straight-repository-branch "develop")
(setq straight-use-package-by-default t
      use-package-always-defer t
      straight-cache-autoloads t
      straight-vc-git-default-clone-depth 1)

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" straight-base-dir))
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
- Reproducible package installations
- Version control for packages
- No more package-install breakage
- Easy to pin package versions

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
;;; init.el --- GNU/Emacs configuration

;; Bootstrap straight.el
;; ... (straight.el setup)

;; Define directories
(defvar billy-conf-dir (expand-file-name "conf/" user-emacs-directory))
(defvar billy-lib-dir (expand-file-name "lib/" user-emacs-directory))

;; Load utility functions
(load-file (expand-file-name "utils.el" user-emacs-directory))

;; Load configurations
(defun billy/load-config (file)
  "Load FILE from billy-conf-dir if it exists."
  (let ((path (expand-file-name file billy-conf-dir)))
    (when (file-exists-p path)
      (load-file path))))

;; Load in order
(billy/load-config "settings.el")
(billy/load-config "core.el")
(billy/load-config "completion.el")
(billy/load-config "themes.el")
(billy/load-config "dev.el")
(billy/load-config "clojure.el")
(billy/load-config "languages.el")

;; Load theme
(load-theme 'Billy-Theme t)

;; Startup message
(message "Billy-macs loaded in %.3fs"
         (float-time (time-subtract after-init-time before-init-time)))
```

**Benefits:**
- Clearer organization
- Easier to maintain
- Logical grouping
- Can selectively disable modules

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

### Step 1: Backup Current Configuration
```bash
cd ~/repos
cp -r billy-macs billy-macs-backup-$(date +%Y%m%d)
cd billy-macs
git checkout -b modernization
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
5. Commit: "Migrate to straight.el package management"

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
3. Update init.el to load new structure
4. Remove old config files
5. Commit: "Reorganize configuration structure"

### Step 8: Add quality-of-life improvements
1. Add no-littering, which-key, helpful, etc.
2. Replace undo-tree with undo-fu
3. Update linum to display-line-numbers-mode
4. Fix hardcoded paths
5. Commit: "Add modern quality-of-life packages"

### Step 9: Polish and optimize
1. Review all configurations
2. Add any missing modern packages
3. Optimize startup time
4. Update .gitignore
5. Commit: "Final polish and optimizations"

### Step 10: Documentation
1. Update README.md
2. Document installation process
3. Document keybindings
4. Create this MODERNIZATION_PLAN.md
5. Commit: "Update documentation"

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
- **Package management:** Reproducible with straight.el
- **Configuration structure:** Clearer organization
- **Code quality:** Modern use-package declarations
- **Documentation:** Better documented with this plan

### Feature Improvements
- **Better completion:** Fuzzy matching with orderless
- **Better search:** consult-ripgrep, consult-line
- **Better help:** helpful package
- **Better discoverability:** which-key
- **Cleaner .emacs.d:** no-littering

### Modern Best Practices Adopted
- early-init.el for startup optimization
- use-package for lazy loading
- straight.el for reproducible builds
- Proper directory structure with no-littering
- Built-in packages over external when possible (eglot, display-line-numbers-mode)
- Modern completion framework (vertico ecosystem)

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
   *.elc
   auto-save-list
   tramp
   .\#*

   # straight.el
   .local/
   straight/
   eln-cache/

   # Old package.el
   elpa/

   # Custom file
   conf/custom.el

   # Temporary files
   ac-comphist.dat
   ido.last
   smex-items
   places
   recentf
   .lsp-session-v1
   ```

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
- Following Emacs community best practices
- Well-organized and documented

The result will be a modern, efficient, and maintainable Emacs configuration that will serve well for years to come.

**Good luck with the modernization!**
