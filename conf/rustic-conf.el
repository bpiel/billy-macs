;;; rustic-conf.el --- Rust development configuration with rustic and eglot

;;; Commentary:
;; Configures Rust development using rustic-mode with eglot (built-in LSP).
;; Replaces the previous lsp-mode setup with the lighter-weight eglot.
;; Based on: https://robert.kra.hn/posts/rust-emacs-setup/

;;; Code:

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ;; Use eglot's built-in commands instead of lsp-mode
              ("M-?" . xref-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . eglot-code-actions)
              ("C-c C-c r" . eglot-rename)
              ("C-c C-c f" . eglot-format-buffer)
              ("M-RET" . eldoc-doc-buffer))  ; Show documentation in separate buffer
  :custom
  ;; Use eglot instead of lsp-mode
  (rustic-lsp-client 'eglot)
  ;; Enable rustfmt on save
  (rustic-format-on-save t)
  ;; Prefer rustic's own formatting over eglot's
  (rustic-format-trigger 'on-save)
  :config
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  "Custom rustic-mode hook configuration."
  ;; Allow running C-c C-c C-r without confirmation
  ;; Don't try to save rust buffers that are not file visiting
  ;; See: https://github.com/brotzeit/rustic/issues/253
  (when buffer-file-name
    (setq-local buffer-save-without-query t))
  ;; Start eglot for LSP support
  (eglot-ensure))

;;; Completion - handled by corfu (configured in completion.el)
;; Corfu works automatically with eglot via completion-at-point
;; No additional configuration needed for Rust

;; Old company-mode setup (disabled - using corfu now):
;; (use-package company
;;   :ensure
;;   :custom
;;   (company-idle-delay 0.5)
;;   :bind (:map company-active-map
;;               ("C-n". company-select-next)
;;               ("C-p". company-select-previous)))

;;; Snippets support
(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

;; Old lsp-mode setup (disabled - using eglot now):
;; All LSP functionality is now provided by eglot (built-in)
;; eglot is configured in init.el and started via rustic-lsp-client
;;
;; Previous lsp-mode configuration included:
;; - rust-analyzer with clippy on save
;; - inlay hints for types and lifetimes
;; - lsp-ui for documentation and sideline info
;;
;; With eglot:
;; - rust-analyzer is configured in init.el's eglot-server-programs
;; - Use eldoc-doc-buffer (M-RET) for documentation
;; - Inlay hints can be configured via eglot settings if needed

(provide 'rustic-conf)
;;; rustic-conf.el ends here
