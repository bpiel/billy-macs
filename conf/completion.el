;;; completion.el --- Modern completion framework configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Configures the vertico/consult/corfu/orderless completion stack.
;; Replaces the older ido/smex/auto-complete setup from Phase 1.
;;
;; Stack overview:
;; - vertico: Vertical completion UI for minibuffer (replaces ido)
;; - consult: Enhanced minibuffer commands (replaces many ido/smex features)
;; - orderless: Fuzzy matching completion style (replaces flx-ido)
;; - marginalia: Rich annotations in minibuffer (shows keybindings, docs, etc.)
;;
;; Phase 2 of Billy-macs modernization (November 2025)

;;; Code:

;;; Orderless - Flexible completion style with fuzzy matching
;; Provides better fuzzy matching than flx-ido
;; Supports space-separated components that can match in any order
(use-package orderless
  :demand t
  :custom
  ;; Use orderless for most completions, with basic as fallback
  (completion-styles '(orderless basic))
  ;; For file paths, use partial-completion (supports wildcards) then basic
  (completion-category-overrides '((file (styles partial-completion basic))
                                   (buffer (styles orderless basic))
                                   (command (styles orderless basic)))))

;;; Vertico - Vertical completion UI
;; Modern, lightweight completion interface for the minibuffer
;; Replaces ido-mode and smex
(use-package vertico
  :demand t
  :init
  (vertico-mode)
  :custom
  ;; Cycle through candidates (wrap around at end)
  (vertico-cycle t)
  ;; Show 15 candidates at a time
  (vertico-count 15)
  :bind (:map vertico-map
              ;; Use C-n/C-p for navigation (familiar bindings)
              ("C-n" . vertico-next)
              ("C-p" . vertico-previous)
              ;; Use M-RET to submit exactly what's typed (not the selected candidate)
              ("M-RET" . vertico-exit-input)))

;;; Vertico extensions
;; Enable useful extensions that come with vertico
(use-package vertico
  :config
  ;; Enable vertico-directory for better directory navigation
  (require 'vertico-directory)
  ;; When in a directory, DEL goes up to parent directory
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
  (define-key vertico-map (kbd "M-DEL") #'vertico-directory-delete-word)
  ;; Tidy shadowed file names (e.g., ~/foo//~/ becomes ~/)
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy))

;;; Marginalia - Rich annotations in minibuffer
;; Adds helpful annotations to completion candidates
;; Shows keybindings for commands, file sizes, documentation, etc.
(use-package marginalia
  :demand t
  :init
  (marginalia-mode)
  :bind (:map minibuffer-local-map
              ;; Toggle between different annotation levels
              ("M-A" . marginalia-cycle)))

;;; Consult - Enhanced minibuffer commands
;; Provides powerful search and navigation commands
;; Replaces many ido/smex features with better alternatives
(use-package consult
  :demand t  ; Load immediately so keybindings work
  :bind (;; Buffer switching with live preview (replaces ido buffer switching)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)

         ;; Recent file access (replaces live-recentf-ido-find-file)
         ("C-x f" . consult-recent-file)

         ;; Jump to symbol in buffer (replaces live-ido-goto-symbol)
         ("C-x C-i" . consult-imenu)
         ("M-g i" . consult-imenu)

         ;; Search commands
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-s l" . consult-line)              ; Search lines in current buffer
         ("C-c l" . consult-line)              ; Alternative: easier to type
         ("M-s L" . consult-line-multi)        ; Search lines in multiple buffers
         ("C-c C-g" . consult-ripgrep)         ; Project-wide search with ripgrep

         ;; Yank/kill-ring
         ("M-y" . consult-yank-pop)

         ;; Bookmark navigation
         ("C-x r b" . consult-bookmark)

         ;; Mark navigation (M-g prefix for goto commands)
         ("M-g m" . consult-mark)
         ("M-g M" . consult-global-mark)

         ;; Error navigation
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)  ; or consult-flycheck if using flycheck

         :map isearch-mode-map
         ;; Use consult during isearch
         ("M-s l" . consult-line))

  :custom
  ;; Preview settings
  (consult-preview-key 'any)  ; Preview on any key press
  (consult-narrow-key "<")     ; Use < for narrowing

  :config
  ;; Configure consult-ripgrep to use ripgrep if available
  (when (executable-find "rg")
    (setq consult-ripgrep-args
          "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --line-number .")))

;;; Savehist - Persist minibuffer history across sessions
;; Built-in package that saves completion history
;; Makes vertico/consult even more useful by remembering what you use
(use-package savehist
  :straight (:type built-in)
  :demand t
  :init
  (savehist-mode 1)
  :custom
  ;; Save additional state
  (savehist-additional-variables '(search-ring regexp-search-ring kill-ring))
  ;; Autosave every 5 minutes
  (savehist-autosave-interval 300))

;;; Corfu - In-buffer completion popup
;; Modern completion-at-point UI (replaces auto-complete)
;; Lightweight, fast, and integrates with native Emacs completion
(use-package corfu
  :demand t
  :init
  (global-corfu-mode)
  :bind (:map corfu-map
              ;; TAB to select next candidate
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ;; Shift-TAB to select previous candidate
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)
              ;; RET to insert selected candidate
              ("RET" . corfu-insert)
              ([return] . corfu-insert))
  :custom
  ;; Cycle through candidates
  (corfu-cycle t)
  ;; Enable auto-completion
  (corfu-auto t)
  ;; Delay before showing auto-completion (in seconds)
  (corfu-auto-delay 0.25)
  ;; Minimum prefix length for auto-completion
  (corfu-auto-prefix 2)
  ;; Preview current candidate
  (corfu-preview-current 'insert)
  ;; Disable default keybindings that might conflict
  (corfu-quit-at-boundary nil)
  (corfu-quit-no-match 'separator))

;; Enable corfu-popupinfo for documentation popups
(use-package corfu
  :config
  (require 'corfu-popupinfo)
  (corfu-popupinfo-mode 1)
  :custom
  ;; Show documentation popup after a delay
  (corfu-popupinfo-delay '(0.5 . 0.5)))

;;; Cape - Completion-at-point extensions
;; Provides additional completion backends for corfu
;; Adds file path completion, dabbrev, etc.
(use-package cape
  :init
  ;; Add useful completion-at-point functions
  ;; File path completion
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;; Dabbrev completion (dynamic abbreviations from buffers)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;;; Keybindings preserved from old ido/smex setup
;; C-x k - Kill current buffer (was in ido-conf.el)
(global-set-key (kbd "C-x k") 'kill-current-buffer)

;; Note: M-x now uses vertico natively (no smex needed)
;; Vertico provides the same functionality with better performance

;; Note: Corfu replaces auto-complete for in-buffer completion
;; It works automatically with CIDER and other major modes

(provide 'completion)
;;; completion.el ends here
