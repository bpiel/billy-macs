(require 'php-mode)

(defun conf-php-mode ()
  (setq indent-tabs-mode t
        tab-width 2
        c-basic-offset 2))
(add-hook 'php-mode-hook 'conf-php-mode)
