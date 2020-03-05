(require 'package)

(defvar billy-conf-dir "/home/bill/.emacs.d/conf/")
(defvar billy-lib-dir "/home/bill/.emacs.d/lib/")

(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("MELPA"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("MELPA Stable" . 10)
        ("GNU ELPA"     . 5)
        ("MELPA"        . 0)))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar namooh/required-packages '(better-defaults))

(dolist (p namooh/required-packages)
  (when (not (package-installed-p 'better-defaults))
    (package-install 'better-defaults)))



(load-file (concat billy-conf-dir "ace-jump-conf.el"))
(load-file (concat billy-conf-dir "util-fns.el"))
(load-file (concat billy-conf-dir "auto-complete-conf.el"))
(load-file (concat billy-conf-dir "browse-kill-ring-conf.el"))
(load-file (concat billy-conf-dir "color-theme-conf.el"))
(load-file (concat billy-conf-dir "cider-conf.el"))
(load-file (concat billy-conf-dir "clojure-conf.el"))
(load-file (concat billy-conf-dir "ido-conf.el"))
(load-file (concat billy-conf-dir "lisp-conf.el"))
(load-file (concat billy-conf-dir "paredit-conf.el"))
(load-file (concat billy-conf-dir "popwin-conf.el"))
(load-file (concat billy-conf-dir "recentf-conf.el"))
(load-file (concat billy-conf-dir "rust-conf.el"))
(load-file (concat billy-conf-dir "smex-conf.el"))
(load-file (concat billy-conf-dir "backup-dir-conf.el"))
(load-file (concat billy-conf-dir "ahs-conf.el"))
(load-file (concat billy-conf-dir "fzf-conf.el"))
(load-file (concat billy-conf-dir "winner-conf.el"))
(load-file (concat billy-conf-dir "rainbow-conf.el"))
;;(load-file (concat billy-conf-dir "php-conf.el"))
(load-file (concat billy-conf-dir "org-conf.el"))

(global-set-key (kbd "C-c n e b") 'cider-eval-buffer)

;;set the mark
(global-set-key (kbd "C-SPC") 'set-mark-command)

;;fast vertical naviation
(global-set-key  (kbd "M-U") (lambda () (interactive) (forward-line -10)))
(global-set-key  (kbd "M-D") (lambda () (interactive) (forward-line 10)))
(global-set-key  (kbd "M-p") 'outline-previous-visible-heading)
(global-set-key  (kbd "M-n") 'outline-next-visible-heading)

;; comment region
(global-set-key (kbd "M-/") 'comment-or-uncomment-region)

(global-set-key (kbd "C-x C-b")   'ibuffer)

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))


(global-unset-key (kbd "C-z")) ;; get rid of "suspend frame"
(cua-mode 0) ;; kill CUA

(global-linum-mode t)

(global-set-key (kbd  "C-,") 'beginning-of-line-text)

(global-set-key (kbd  "C-x x") 'rgrep)
(setq ag-highlight-search t)

(setq frame-title-format
  '("" invocation-name ": "(:eval (if (buffer-file-name)
                (abbreviate-file-name (buffer-file-name))
                  "%b"))))

(defun switch-to-most-recent-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key (kbd  "C-M-<return>") 'switch-to-most-recent-buffer)
(global-set-key (kbd  "C-M-<backspace>") 'revert-buffer)
(global-set-key (kbd  "C-S-a") 'mark-whole-buffer)

(defun sudo-edit (&optional arg)
  "Edit currently visited file as root. With a prefix ARG prompt
for a file to visit. Will also prompt for a file to visit if
current buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun insert-pprint ()
  (interactive)
  (insert "clojure.pprint/pprint")
  (live-delete-whitespace-except-one))

(defun repl-clear-and-prev ()
  (interactive)
  (cider-repl-clear-buffer)
  (cider-repl-previous-input))

(global-set-key (kbd "C-c s p") 'insert-pprint)
(global-set-key (kbd "C-S-c C-S-p") 'repl-clear-and-prev)

(defun go-big-font-size ()
  (interactive)
  (set-face-attribute 'default nil :height 260))

(defun go-normal-font-size ()
  (interactive)
  (set-face-attribute 'default nil :height 130))

(put 'erase-buffer 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(defun insert-midje-repl ()
  (interactive)
  (insert "(require '[midje.repl :as mr])"))

(defun insert-sayid ()
  (interactive)
  (insert "(require '[com.billpiel.sayid.core :as sd])"))

(defun insert-sayid-pro ()
  (interactive)
  (insert "(require '[com.billpiel.sayid-pro.core :as sd])"))

;; show keystrokes in mini-buffer instantly
(setq echo-keystrokes 0.01)

(require 'undo-tree)
(global-undo-tree-mode)

(defun gentle-visible-bell ()
   (invert-face 'mode-line)
   (run-with-timer 0.1 nil 'invert-face 'mode-line))

(setq visible-bell nil
      ring-bell-function #'gentle-visible-bell)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq column-number-mode t)

(setq markdown-command "pandoc -f markdown_github -s")

(eval-after-load 'clojure-mode
  '(sayid-setup-package))

(elpy-enable)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fzf/args "")
 '(fzf/directory-start "/home/bill")
 '(fzf/executable "/home/bill/repos/billy-macs/lib/fzf1.sh")
 '(package-selected-packages
   (quote
    (dash racer company cargo flycheck-rust rust-mode cider yaml-mode vlf undo-tree smex sayid rainbow-mode rainbow-delimiters popwin php-mode paredit packed mic-paren markdown-mode idomenu fzf fuzzy flx-ido eval-sexp-fu elpy elisp-slime-nav edn color-theme coffee-mode browse-kill-ring better-defaults auto-highlight-symbol align-cljlet adoc-mode ace-jump-mode ac-cider))))

(load-file "/home/bill/repos/billy-macs/conf/startup-buffer.el")

;; END Bill's stuff

(message "\n\n init.el done loading  \n\n")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-added ((t (:foreground "Green"))))
 '(diff-removed ((t (:foreground "Red"))))
 '(ediff-even-diff-A ((((class color) (background dark)) (:background "dark green"))))
 '(ediff-even-diff-B ((((class color) (background dark)) (:background "dark red"))))
 '(ediff-odd-diff-A ((((class color) (background dark)) (:background "dark green"))))
 '(ediff-odd-diff-B ((((class color) (background dark)) (:background "dark red"))))
 '(markup-meta-face ((t (:stipple nil :foreground "gray50" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "unknown" :family "Monospace"))))
 '(markup-meta-hide-face ((t (:inherit markup-meta-face :foreground "gray80" :height 1.1))))
 '(mumamo-background-chunk-major ((((class color) (background dark)) (:background "black"))))
 '(mumamo-background-chunk-submode1 ((((class color) (background dark)) (:background "black")))))
