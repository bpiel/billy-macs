(require 'browse-kill-ring)

(setq browse-kill-ring-highlight-current-entry t)
(setq browse-kill-ring-no-duplicates t)
(setq browse-kill-ring-display-duplicates nil)
(setq browse-kill-ring-highlight-inserted-item nil)

(global-set-key (kbd "M-y") 'browse-kill-ring)
