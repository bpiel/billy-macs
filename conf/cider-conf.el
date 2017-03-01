(require 'cider)
(require 'cider-apropos)
(require 'cider-macroexpansion)
(require 'cider-repl)
(require 'cider-mode)

(defun live-windows-hide-eol ()
 "Do not show ^M in files containing mixed UNIX and DOS line endings."
 (interactive)
 (setq buffer-display-table (make-display-table))
 (aset buffer-display-table ?\^M []))

(when (eq system-type 'windows-nt)
  (add-hook 'nrepl-mode-hook 'live-windows-hide-eol ))

(add-hook 'cider-repl-mode-hook
          (lambda ()
            (eldoc-mode 1)
            (paredit-mode 1)))

(add-hook 'cider-mode-hook
           (lambda ()
             (eldoc-mode 1)
             (paredit-mode 1)))

(setq cider-popup-stacktraces t)
(setq cider-popup-stacktraces-in-repl t)
(add-to-list 'same-window-buffer-names "*cider*")

;;Auto Complete
(require 'ac-cider )

(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)

(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'cider-mode))

;; Specify the print length to be 100 to stop infinite sequences killing
;; things. This might be dangerous for some people relying on
;; *print-length* being larger. Consider a work around
(defun live-nrepl-set-print-length ()
  (nrepl-send-string-sync "(set! *print-length* 100)" "clojure.core"))

(add-hook 'nrepl-connected-hook 'live-nrepl-set-print-length)

(setq nrepl-port "4555")


;; Show documentation/information with M-RET
(define-key cider-repl-mode-map (kbd "M-RET") 'cider-doc)
(define-key cider-mode-map (kbd "M-RET") 'cider-doc)

(define-key cider-repl-mode-map (kbd "C-c C-l") 'cider-repl-clear-buffer)
(define-key cider-repl-mode-map (kbd "C-x C-x C-x") 'cider-make-connection-default)

;; https://github.com/clojure-emacs/cider#basic-configuration
(setq cider-auto-select-error-buffer nil)
