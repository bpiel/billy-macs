(require 'fzf)

(global-set-key (kbd "C-x SPC") 'fzf)


(defun refresh-fzf-index ()
  (interactive)
  (message "Refreshing fzf index. This may take a bit...")
  (shell-command "/home/bill/bin/refresh-fzf-index.sh")
  (message "Refresh completed."))

(global-set-key (kbd "C-c r") 'refresh-fzf-index)
