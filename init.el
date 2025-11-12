;;; init.el --- Billy-macs Emacs configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Main initialization file for billy-macs.
;; This file bootstraps straight.el and loads modular configuration files.
;; See early-init.el for pre-initialization optimizations.
;; Modernization began November 2025 - Phase 1: Foundation

;;; Code:

;;; Startup Performance Restoration
;; Restore file-name-handler-alist and GC settings after startup
;; These were optimized in early-init.el for faster startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16777216  ; 16MB (reasonable for interactive use)
                  gc-cons-percentage 0.1)
            (setq file-name-handler-alist billy-macs--file-name-handler-alist)
            (message "Billy-macs loaded in %.3fs with %d GCs"
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

;;; Package Management - straight.el
;; We keep straight-base-dir at default (user-emacs-directory)
;; to keep packages in the repo for reliability and offline access
(setq straight-repository-branch "develop"
      straight-use-package-by-default t
      use-package-always-defer t          ; Lazy load by default (override with :demand)
      straight-cache-autoloads t
      straight-check-for-modifications '(check-on-save)  ; Only check when saving, not on startup
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

;; Install use-package via straight.el
(straight-use-package 'use-package)

;;; Directory Configuration
;; Define config and library directories using portable paths
(defvar billy-conf-dir (expand-file-name "conf/" user-emacs-directory)
  "Directory containing modular configuration files.")
(defvar billy-lib-dir (expand-file-name "lib/" user-emacs-directory)
  "Directory containing custom libraries and utilities.")

;;; Legacy package.el support (will be removed after full migration)
;; Keep old package.el code commented for now during transition
;; (require 'package)
;; (setq package-archives ...)
;; (package-initialize)

;;; Directory Organization with no-littering
;; Organize cache files and data files into .local/ subdirectory
;; This keeps the main config directory clean and organized
(use-package no-littering
  :demand t
  :config
  ;; Put auto-save files in a dedicated directory
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  ;; Put custom-set-variables in a separate file (won't be loaded)
  ;; This prevents Emacs from modifying init.el directly
  (setq custom-file (no-littering-expand-etc-file-name "custom.el")))

;;; Core Settings
(setq-default line-spacing 0.2)
(setq line-spacing 0.2)

(load-theme 'Billy-Theme t)

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(show-paren-mode 1)

(add-to-list 'default-frame-alist
             '(vertical-scroll-bars . nil))

;;; Package Declarations
;; Install packages via straight.el before loading config files
;; Config files will then be able to require/configure these packages

;; Core utility packages
(use-package avy :demand t)
(use-package better-defaults :demand t)

;; Modern completion framework (Phase 2)
;; Vertico/Consult/Orderless stack - replaces ido/smex
(use-package vertico)
(use-package consult)
(use-package orderless)
(use-package marginalia)

;; Corfu - in-buffer completion (replaces auto-complete)
(use-package corfu)
(use-package cape)  ; Completion-at-point extensions for corfu

;; Old completion - DISABLED in Phase 2
;; Replaced by corfu/cape
;; (use-package auto-complete :demand t)
;; (use-package popup :demand t)  ; Dependency for auto-complete
;; (use-package fuzzy :demand t)  ; Dependency for auto-complete
(use-package fzf)

;; Editing enhancements
(use-package paredit :demand t)
(use-package undo-tree :demand t)
(use-package browse-kill-ring :demand t)
(use-package rainbow-delimiters :demand t)
(use-package auto-highlight-symbol)
(use-package winner :straight (:type built-in) :demand t)

;; Git integration (Phase 3)
(use-package diff-hl)  ; Show git diff in fringe

;; Better help buffers (Phase 3)
(use-package helpful)  ; Enhanced help buffers with more information

;; Window management
(use-package popwin :demand t)

;; Clojure development
(use-package clojure-mode :demand t)
(use-package cider :demand t)
;; (use-package ac-cider :demand t)  ; DISABLED - using corfu instead
(use-package clj-refactor)
(use-package sayid)  ; Clojure debugger/tracer
(use-package align-cljlet)

;; Language support
(use-package go-mode)
(use-package typescript-mode)
(use-package zig-mode)
(use-package json-mode)
(use-package rustic)
(use-package markdown-mode)

;; LSP and syntax checking
;; Note: eglot is built-in (Emacs 29+), configured below
(use-package flycheck)

;; Other tools
(use-package pdf-tools
  ;; Don't build/load on startup (has C dependencies that may fail)
  ;; Will build when first opening a PDF file
  :mode ("\\.pdf\\'" . pdf-view-mode))
(use-package vlf)
(use-package edn)
;; Note: eglot is built-in to Emacs 29+, no need to install via straight.el
;; It will be loaded on-demand when eglot-ensure is called
(use-package s)  ; String manipulation library
(use-package elisp-slime-nav)
(use-package recentf :straight (:type built-in) :demand t)
(use-package org :straight (:type built-in))

;; Python support
(use-package elpy)

;; Additional packages from package-selected-packages
(use-package gnu-elpa-keyring-update)
(use-package clang-format)  ; C/C++ code formatting (used with eglot)

;;; Load Configuration Files
;; Now that packages are installed, load the config files

;; Modern completion framework (Phase 2) - replaces ido-conf.el and smex-conf.el
(load-file (concat billy-conf-dir "completion.el"))

;; Core configuration files
(load-file (concat billy-conf-dir "avy-conf.el"))
(load-file (concat billy-conf-dir "util-fns.el"))
;; (load-file (concat billy-conf-dir "auto-complete-conf.el"))  ; REPLACED by corfu in completion.el
(load-file (concat billy-conf-dir "browse-kill-ring-conf.el"))
;;(load-file (concat billy-conf-dir "color-theme-conf.el"))
(load-file (concat billy-conf-dir "cider-conf.el"))
(load-file (concat billy-conf-dir "clojure-conf.el"))
;; (load-file (concat billy-conf-dir "ido-conf.el"))  ; REPLACED by completion.el
(load-file (concat billy-conf-dir "lisp-conf.el"))
(load-file (concat billy-conf-dir "paredit-conf.el"))
(load-file (concat billy-conf-dir "popwin-conf.el"))
(load-file (concat billy-conf-dir "recentf-conf.el"))
;;(load-file (concat billy-conf-dir "rust-conf.el"))
(load-file (concat billy-conf-dir "rustic-conf.el"))
;; (load-file (concat billy-conf-dir "smex-conf.el"))  ; REPLACED by completion.el
(load-file (concat billy-conf-dir "backup-dir-conf.el"))
(load-file (concat billy-conf-dir "ahs-conf.el"))
(load-file (concat billy-conf-dir "fzf-conf.el"))
(load-file (concat billy-conf-dir "winner-conf.el"))
(load-file (concat billy-conf-dir "rainbow-conf.el"))
;;(load-file (concat billy-conf-dir "php-conf.el"))
(load-file (concat billy-conf-dir "org-conf.el"))

;; GOLANG =============
;; Go - eglot (built-in LSP client)
;; Set up before-save hooks to format buffer and organize imports using eglot
(defun eglot-go-install-save-hooks ()
  "Set up before-save hooks for Go files with eglot."
  (add-hook 'before-save-hook #'eglot-format-buffer -10 t)
  (add-hook 'before-save-hook
            (lambda ()
              (call-interactively 'eglot-code-action-organize-imports))
            nil t))
(add-hook 'go-mode-hook #'eglot-go-install-save-hooks)

;; Start eglot for Go files
(add-hook 'go-mode-hook #'eglot-ensure)

;; END GOLANG =============


(add-hook 'ibuffer-mode-hook
	  (lambda ()
	    (define-key ibuffer-mode-map
	      (kbd "C-o")
	      'avy-goto-word-1)))

;; https://github.com/politza/pdf-tools
(pdf-loader-install)

(global-set-key (kbd "C-c n e b") 'cider-eval-buffer)

;;set the mark
(global-set-key (kbd "C-SPC") 'set-mark-command)

;;override C-x C-o
(global-set-key (kbd "C-x C-o") 'other-window)

;;fast vertical naviation
(global-set-key  (kbd "M-U") (lambda () (interactive) (forward-line -10)))
(global-set-key  (kbd "M-D") (lambda () (interactive) (forward-line 10)))
(global-set-key  (kbd "M-p") 'outline-previous-visible-heading)
(global-set-key  (kbd "M-n") 'outline-next-visible-heading)

;; comment region
(global-set-key (kbd "M-/") 'comment-or-uncomment-region)

(global-set-key (kbd "C-x C-b")   'ibuffer)

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))


(global-unset-key (kbd "C-z")) ;; get rid of "suspend frame"
(cua-mode 0) ;; kill CUA

;; Line numbers - using built-in display-line-numbers-mode (Emacs 26+)
;; More performant than the old linum-mode, especially with large files
(use-package display-line-numbers
  :straight (:type built-in)
  :hook (prog-mode . display-line-numbers-mode)
  :custom
  (display-line-numbers-type t))  ; t = absolute line numbers

;;; LSP Configuration - eglot (built-in LSP client, Emacs 29+)
;; eglot is a lighter-weight alternative to lsp-mode
;; It's built-in to Emacs 29+ and works seamlessly with native completion
(use-package eglot
  :straight (:type built-in)
  :commands (eglot eglot-ensure)
  :custom
  ;; Automatically shutdown language server after closing last file
  (eglot-autoshutdown t)
  ;; Don't block on server connection
  (eglot-sync-connect nil)
  ;; Allow edits before server is ready
  (eglot-extend-to-xref t)
  :config
  ;; Configure language servers
  (add-to-list 'eglot-server-programs
               '(go-mode . ("gopls")))
  (add-to-list 'eglot-server-programs
               '(typescript-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) . ("clangd")))
  (add-to-list 'eglot-server-programs
               '((rust-mode rustic-mode) . ("rust-analyzer"))))

;;; Git Integration - diff-hl (Phase 3)
;; Show git diff indicators in the fringe
;; Helps visualize which lines have been added/modified/deleted
(use-package diff-hl
  :demand t
  :config
  ;; Enable diff-hl globally
  (global-diff-hl-mode)
  ;; Highlight diffs in Dired
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  ;; Update diff-hl after magit operations
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

;;; Better Help Buffers - helpful (Phase 3)
;; Enhanced help buffers with more context and information
;; Shows source code, references, and better formatting
(use-package helpful
  :bind
  ;; Remap default help commands to use helpful
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key)
  ([remap describe-command] . helpful-command))

(global-set-key (kbd  "C-,") 'beginning-of-line-text)

(global-set-key (kbd  "C-x x") 'rgrep)
(setq ag-highlight-search t)

(setq frame-title-format
  '("" invocation-name ": "(:eval (if (buffer-file-name)
                (abbreviate-file-name (buffer-file-name))
                  "%b"))))

(setq icon-title-format '("" invocation-name ": "(:eval (if (buffer-file-name)
                (abbreviate-file-name (buffer-file-name))
                  "%b"))))

(defun switch-to-most-recent-buffer ()
  (interactive)
  ;;(switch-to-buffer  (other-buffer (current-buffer) 2 ))
  (switch-to-buffer
   (first (first (window-prev-buffers)))))

(global-set-key (kbd  "C-M-<return>") 'switch-to-most-recent-buffer)
(global-set-key (kbd  "C-M-<backspace>") 'revert-buffer)
(global-set-key (kbd  "C-S-a") 'mark-whole-buffer)

(defun sudo-edit (&optional arg)
  "Edit currently visited file as root. With a prefix ARG prompt
for a file to visit. Will also prompt for a file to visit if
current buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun insert-pprint ()
  (interactive)
  (insert "clojure.pprint/pprint")
  (live-delete-whitespace-except-one))

(defun repl-clear-and-prev ()
  (interactive)
  (cider-repl-clear-buffer)
  (cider-repl-previous-input))

(global-set-key (kbd "C-c s p") 'insert-pprint)
(global-set-key (kbd "C-S-c C-S-p") 'repl-clear-and-prev)

(defun go-big-font-size ()
  (interactive)
  (set-face-attribute 'default nil :height 260))

(defun go-normal-font-size ()
  (interactive)
  (set-face-attribute 'default nil :height 110))

(put 'erase-buffer 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(defun insert-midje-repl ()
  (interactive)
  (insert "(require '[midje.repl :as mr])"))

(defun insert-sayid ()
  (interactive)
  (insert "(require '[com.billpiel.sayid.core :as sd])"))

(defun insert-sayid-pro ()
  (interactive)
  (insert "(require '[com.billpiel.sayid-pro.core :as sd])"))

;; show keystrokes in mini-buffer instantly
(setq echo-keystrokes 0.01)

(require 'undo-tree)
(global-undo-tree-mode)

(defun set-indent-tabs-mode-nil ()
  (interactive)
  (setq indent-tabs-mode nil))


(defun gentle-visible-bell ()
   (invert-face 'mode-line)
   (run-with-timer 0.1 nil 'invert-face 'mode-line))

(setq visible-bell nil
      ring-bell-function #'gentle-visible-bell)

(defun indent-buffer ()
      (interactive)
      (save-excursion
        (indent-region (point-min) (point-max) nil)))

(defalias 'yes-or-no-p 'y-or-n-p)
(setq column-number-mode t)

(setq markdown-command "pandoc -f markdown_github -s")

(eval-after-load 'clojure-mode
  '(sayid-setup-package))

(elpy-enable)

(defun make-this()
  (interactive)
  (let* ((src (file-name-nondirectory (buffer-file-name)))
         (exe (file-name-sans-extension src)))
    (compile (concat "make -B " exe))))

(add-to-list 'auto-mode-alist '("\\.mts$" . typescript-mode))

;; TypeScript - eglot (built-in LSP client)
(add-hook 'typescript-mode-hook #'eglot-ensure)


;; https://github.com/typescript-language-server/typescript-language-server/issues/559
;; same definition as mentioned earlier
(advice-add 'json-parse-string :around
            (lambda (orig string &rest rest)
              (apply orig (s-replace "\\u0000" "" string)
                     rest)))

;; https://github.com/typescript-language-server/typescript-language-server/issues/559
;; minor changes: saves excursion and uses search-forward instead of re-search-forward
(advice-add 'json-parse-buffer :around
            (lambda (oldfn &rest args)
	      (save-excursion 
                (while (search-forward "\\u0000" nil t)
                  (replace-match "" nil t)))
		(apply oldfn args)))

;; Ruby lsp
;; (with-eval-after-load 'lsp-mode
;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-stdio-connection lsp-solargraph-server-command)
;;                     :activation-fn (lsp-activate-on "ruby")
;; 		    :priority 0
;;                     :server-id 'solargraph-ls)))


;;(require 'lsp-solargraph)

;; C/C++ - eglot (configured in main eglot section above)
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

;; Custom variables and faces are now managed by no-littering
;; They will be stored in .local/etc/custom.el (not loaded)
;; This keeps init.el clean and prevents Emacs from modifying it

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(cargo-process--enable-rust-backtrace t)
;;  '(custom-safe-themes
;;    '("6b233389ceb3d6699564bf4d95eb1ec5086308d687d0fa03e33af0128a2e067e" "599e6b74c4522a5e735453084c1465e4c69200bf766fa74351c84c4db6b596ce" "c7eb06356fd16a1f552cfc40d900fe7326ae17ae7578f0ef5ba1edd4fdd09e58" default))
;;  '(elpy-rpc-python-command "python3")
;;  '(exec-path ...)
;;  '(fzf/executable ...)
;;  ... all other custom variables ...
;; )

;; (custom-set-faces
;;  ... all custom faces ...
;; )

(load-file (expand-file-name "conf/startup-buffer.el" user-emacs-directory))

;; END Bill's stuff

(message "\n\n init.el done loading  \n\n")

(provide 'init)
;;; init.el ends here

