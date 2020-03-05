
(defvar auto-highlight-symbol-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-J") 'ahs-backward)
    (define-key map (kbd "M-K"   ) 'ahs-forward)
    (define-key map (kbd "M-S-<left>"  ) 'ahs-backward-definition )
    (define-key map (kbd "M-S-<right>" ) 'ahs-forward-definition  )
    (define-key map (kbd "M--"         ) 'ahs-back-to-start       )
    (define-key map (kbd "C-x C-'"     ) 'ahs-change-range        )
    (define-key map (kbd "C-x C-a"     ) 'ahs-edit-mode           )
    map))

(require 'auto-highlight-symbol)
(require 'clojure-mode)

(global-auto-highlight-symbol-mode t)
(add-to-list 'ahs-modes 'clojure-mode)
(add-to-list 'ahs-modes 'rust-mode)
(setq ahs-default-range 'ahs-range-whole-buffer)

;; add support for matching '<' and '>' in clojure mode
(setq ahs-include '((clojure-mode . "^[<>0-9A-Za-z/_.,:;*+=&%|$#@!^?-]+$")))
