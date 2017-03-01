(require 'winner)

(winner-mode t)
(global-set-key (kbd "C-c C-<backspace>") 'winner-undo)
(global-set-key (kbd "C-S-c C-S-<backspace>") 'winner-redo)
