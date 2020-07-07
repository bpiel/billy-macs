(use-package company)
(require 'company-lsp)
(push 'company-lsp company-backends)

(use-package lsp-mode
  :commands lsp
  :config (require 'lsp-clients))

(use-package lsp-ui)

(use-package toml-mode)

(use-package cargo)

(use-package rust-mode
  :hook (rust-mode . lsp))

(use-package rust-mode
  :hook (rust-mode . cargo-minor-mode))

(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "M-q") #'rust-format-buffer)
            (local-set-key (kbd "M-RET") #'lsp-describe-thing-at-point)))

(add-hook 'rust-mode-hook 'rainbow-delimiters-mode)
