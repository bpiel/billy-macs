;;; early-init.el --- Early initialization settings for optimal startup  -*- lexical-binding: t; -*-

;;; Commentary:
;; This file is loaded before the package system and GUI is initialized.
;; Used for startup optimizations that must happen early in the boot process.
;; Part of the billy-macs modernization (Phase 1: Foundation)

;;; Code:

;;; Package Management
;; Disable package.el (we use straight.el instead, configured in init.el)
;; This prevents package.el from auto-loading packages before we set up straight.el
(setq package-enable-at-startup nil)

;;; Garbage Collection Optimization
;; Increase GC threshold during startup for faster loading
;; This will be restored to a reasonable value in init.el after startup
(setq gc-cons-threshold most-positive-fixnum  ; Effectively disable GC during startup
      gc-cons-percentage 0.6)                 ; Increase percentage threshold too

;;; File Name Handler Optimization
;; file-name-handler-alist is consulted on every file access
;; Disabling it during startup significantly speeds up loading
;; We save the original value to restore it after startup
(defvar billy-macs--file-name-handler-alist file-name-handler-alist
  "Backup of file-name-handler-alist to restore after startup.")
(setq file-name-handler-alist nil)

;; Note: This will be restored in init.el with:
;; (add-hook 'emacs-startup-hook
;;   (lambda ()
;;     (setq file-name-handler-alist billy-macs--file-name-handler-alist)))

;;; UI Optimization
;; Set frame parameters early to prevent flash of unstyled content
;; These settings prevent the default UI elements from briefly appearing
(push '(menu-bar-lines . 0) default-frame-alist)       ; No menu bar
(push '(tool-bar-lines . 0) default-frame-alist)       ; No tool bar
(push '(vertical-scroll-bars) default-frame-alist)     ; No scroll bars

;;; Native Compilation Cache (Emacs 28+)
;; Keep native compilation cache in the repo for self-contained config
;; This ensures all compiled files stay with the configuration
;; If you prefer to keep this outside the repo, uncomment the following:
;; (when (fboundp 'startup-redirect-eln-cache)
;;   (startup-redirect-eln-cache
;;    (expand-file-name ".local/var/eln-cache/" user-emacs-directory)))

(provide 'early-init)
;;; early-init.el ends here
