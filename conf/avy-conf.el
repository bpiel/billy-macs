(require 'avy)

(global-set-key (kbd "C-o") 'avy-goto-word-1)
(global-set-key (kbd "C-x p") 'avy-pop-mark)
(global-set-key (kbd "C-x C-p") 'avy-pop-mark)

(setq avy-keys '(?a ?s ?d ?f ?j ?k ?l ?g ?h ?r ?e ?w ?u ?i ?o))
