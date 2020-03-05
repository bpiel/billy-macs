;; (require 'rust-mode)
;; (require 'cargo)
;; (require 'racer)
;; (require 'company)
;; (require 'eldoc)

;; (add-hook 'rust-mode-hook 'cargo-minor-mode)

;; (add-hook 'rust-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "M-q") #'rust-format-buffer)
;;             (local-set-key (kbd "M-RET") #'racer-describe)))


;; (setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
;; (setq racer-rust-src-path "/home/bill/repos/rust/src") ;; Rust source code PATH

;; (add-hook 'rust-mode-hook #'racer-mode)
;; (add-hook 'racer-mode-hook #'eldoc-mode)
;; (add-hook 'racer-mode-hook #'company-mode)

