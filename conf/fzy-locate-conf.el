(load-file (concat billy-lib-dir "fzy-locate/fzy-locate.el"))
(fzloc-load-dbs-from-path "/home/bill/.emacs.d/locatedbs/*.locatedb")
(setq fzloc-filter-regexps '("/target/" "/.git/"))

(global-set-key (kbd "C-x SPC") 'fzy-locate)

(defun refresh-emacs-locatedb ()
  (interactive)
  (message "Refreshing locatedb. This may take a bit...")
  (shell-command "/home/bill/bin/refresh-emacs-locatedb.sh")
  (message "Refresh completed."))

(global-set-key (kbd "C-c r") 'refresh-emacs-locatedb)
