(require 'package)

(defvar billy-conf-dir "/home/bill/.emacs.d/conf/")
(defvar billy-lib-dir "/home/bill/.emacs.d/lib/")

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("billpiel" . "http://billpiel.com/emacs-packages/") t)


(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar namooh/required-packages '(better-defaults))

(dolist (p namooh/required-packages)
  (when (not (package-installed-p 'better-defaults))
    (package-install 'better-defaults)))

;; ========== emacs-live stuff

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
(load-file (concat billy-conf-dir "smex-conf.el"))
(load-file (concat billy-conf-dir "backup-dir-conf.el"))

;; clojure

(require 'paredit)
(define-key paredit-mode-map (kbd "M-j")     'paredit-join-sexps)
(define-key paredit-mode-map (kbd "M-P")     'live-paredit-previous-top-level-form)
(define-key paredit-mode-map (kbd "M-N")     'live-paredit-next-top-level-form)
(define-key paredit-mode-map (kbd "C-M-f")   'live-paredit-forward)
(define-key paredit-mode-map (kbd "M-q")     'live-paredit-reindent-defun)
(define-key paredit-mode-map (kbd "M-d")     'live-paredit-forward-kill-sexp)
(define-key paredit-mode-map (kbd "M-k")     'live-paredit-backward-kill)
(define-key paredit-mode-map (kbd "M-\\")    'live-paredit-delete-horizontal-space)
(define-key paredit-mode-map (kbd "C-M-i")   'paredit-forward-down)
(define-key paredit-mode-map (kbd "C-M-n")   'paredit-forward-up)
(define-key paredit-mode-map (kbd "C-M-p")   'paredit-backward-down)
(define-key paredit-mode-map (kbd "C-M-u")   'paredit-backward-up)
(define-key paredit-mode-map (kbd "M-T")     'transpose-sexps)
;; (define-key paredit-mode-map (kbd "C-M-k")   'live-paredit-copy-sexp-at-point)

;;browse kill ring (visual paste)
(global-set-key (kbd "M-y") 'browse-kill-ring)

;;emacs-lisp shortcuts
(global-set-key (kbd "C-c m s") 'eval-and-replace) ;swap
(global-set-key (kbd "C-c m b") 'eval-buffer)
(global-set-key (kbd "C-c m e") 'eval-last-sexp)
(global-set-key (kbd "C-c m i") 'eval-expression)
(global-set-key (kbd "C-c m d") 'eval-defun)
(global-set-key (kbd "C-c m n") 'eval-print-last-sexp)
(global-set-key (kbd "C-c m r") 'eval-region)

(global-set-key (kbd "C-c n e b") 'cider-eval-buffer)

;;use delete-horizontal-space to completely nuke all whitespace
(global-set-key (kbd "M-SPC ") 'live-delete-whitespace-except-one)

;;set the mark
(global-set-key (kbd "C-SPC") 'set-mark-command)

;;repeat previous command
(global-set-key (kbd "M-'") 'repeat)

;;scroll other window
(global-set-key (kbd "C-M-]") 'scroll-other-window)
(global-set-key (kbd "C-M-[") 'scroll-other-window-down)

;;fast vertical naviation
(global-set-key  (kbd "M-U") (lambda () (interactive) (forward-line -10)))
(global-set-key  (kbd "M-D") (lambda () (interactive) (forward-line 10)))
(global-set-key  (kbd "M-p") 'outline-previous-visible-heading)
(global-set-key  (kbd "M-n") 'outline-next-visible-heading)

;; comment region
(global-set-key (kbd "M-/") 'comment-or-uncomment-region)

;; Jump to a definition in the current file.
;;(global-set-key (kbd "C-x C-i") 'idomenu)
(global-set-key (kbd "C-x C-i") 'live-ido-goto-symbol)

;; File
(global-set-key (kbd "C-x f")     'live-recentf-ido-find-file)
(global-set-key (kbd "C-x C-r")   'ido-recentf-open)
(global-set-key (kbd "C-x C-b")   'ibuffer)

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))

;; Ace jump mode
(global-set-key (kbd "C-o") 'ace-jump-mode)

(require 'cider-repl)
(require 'cider-mode)
;; Show documentation/information with M-RET
(define-key lisp-mode-shared-map (kbd "M-RET") 'live-lisp-describe-thing-at-point)
(define-key cider-repl-mode-map (kbd "M-RET") 'cider-doc)
(define-key cider-mode-map (kbd "M-RET") 'cider-doc)

(define-key cider-repl-mode-map (kbd "C-c C-l") 'cider-repl-clear-buffer)
(define-key cider-repl-mode-map (kbd "C-x C-x C-x") 'cider-make-connection-default)

;; ====== Bill Stuff

(message "\n\n Doing Bill's stuff \n\n")

(global-unset-key (kbd "C-z")) ;; get rid of "suspend frame"
(cua-mode 0) ;; kill CUA

(global-linum-mode t)

(global-set-key (kbd  "C-,") 'beginning-of-line-text)

(load-file (concat billy-lib-dir "fzy-locate/fzy-locate.el"))
(fzloc-load-dbs-from-path "/home/bill/.emacs.d/locatedbs/*.locatedb")
(setq fzloc-filter-regexps '("/target/" "/.git/"))

(global-set-key (kbd "C-x SPC") 'fzy-locate)
(global-set-key (kbd  "C-x p") 'ace-jump-mode-pop-mark)
(global-set-key (kbd  "C-x C-p") 'ace-jump-mode-pop-mark)
(global-set-key (kbd  "C-x x") 'rgrep)
(setq ag-highlight-search t)

(defun refresh-emacs-locatedb ()
  (interactive)
  (message "Refreshing locatedb. This may take a bit...")
  (shell-command "/home/bill/bin/refresh-emacs-locatedb.sh")
  (message "Refresh completed."))

(global-set-key (kbd "C-c r") 'refresh-emacs-locatedb)

(setq frame-title-format
  '("" invocation-name ": "(:eval (if (buffer-file-name)
                (abbreviate-file-name (buffer-file-name))
                  "%b"))))


;; auto-highlight-symbol config

;; customize keybindings
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
(global-auto-highlight-symbol-mode t)
(add-to-list 'ahs-modes 'clojure-mode)
(setq ahs-default-range 'ahs-range-whole-buffer)

;; add support for matching '<' and '>' in clojure mode
(setq ahs-include '((clojure-mode . "^[<>0-9A-Za-z/_.,:;*+=&%|$#@!^?-]+$")))

;; ------

(defun switch-to-most-recent-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key (kbd  "C-M-<return>") 'switch-to-most-recent-buffer)
(global-set-key (kbd  "C-M-<backspace>") 'revert-buffer)
(global-set-key (kbd  "C-S-o") 'ace-jump-char-mode)
(global-set-key (kbd  "C-S-a") 'mark-whole-buffer)

;; https://github.com/clojure-emacs/cider#basic-configuration
(setq cider-auto-select-error-buffer nil)

;; turn on rainbow-mode to see the rainbow!
(require 'rainbow-delimiters)
(set-face-attribute 'rainbow-delimiters-depth-1-face nil :foreground "#BB2222")
(set-face-attribute 'rainbow-delimiters-depth-2-face nil :foreground "#BB7700")
(set-face-attribute 'rainbow-delimiters-depth-3-face nil :foreground "#BBBB22")
(set-face-attribute 'rainbow-delimiters-depth-4-face nil :foreground "#11BB11")
(set-face-attribute 'rainbow-delimiters-depth-5-face nil :foreground "#33BBBB")
(set-face-attribute 'rainbow-delimiters-depth-6-face nil :foreground "#5555AA")
(set-face-attribute 'rainbow-delimiters-depth-7-face nil :foreground "#AA55AA")
(set-face-attribute 'rainbow-delimiters-depth-8-face nil :foreground "#BBBBBB")
(set-face-attribute 'rainbow-delimiters-depth-9-face nil :foreground "#66FF66")

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

(defun bpiel/add-midje-forms-to-clojure-dedenting ()
  (put-clojure-indent 'fact-group 1)
  (put-clojure-indent 'facts 1)
  (put-clojure-indent 'fact 1)
  (put-clojure-indent 'tabular nil)
  (put-clojure-indent 'for-all 1))

(eval-after-load 'clojure-mode
  '(add-hook 'clojure-mode-hook 'bpiel/add-midje-forms-to-clojure-dedenting))

(defun bpiel/add-compojure-forms-to-clojure-dedenting ()
  (put-clojure-indent 'context 2)
  (put-clojure-indent 'ANY 2)
  (put-clojure-indent 'PUT 2)
  (put-clojure-indent 'GET 2)
  (put-clojure-indent 'POST 2)
  (put-clojure-indent 'DELETE 2)
  (put-clojure-indent 'PATCH 2))

(eval-after-load 'clojure-mode
  '(add-hook 'clojure-mode-hook 'bpiel/add-compojure-forms-to-clojure-dedenting))

;; show keystrokes in mini-buffer instantly
(setq echo-keystrokes 0.01)

(require 'undo-tree)
(global-undo-tree-mode)


(defun gentle-visible-bell ()
   (invert-face 'mode-line)
   (run-with-timer 0.1 nil 'invert-face 'mode-line))

(setq visible-bell nil
      ring-bell-function #'gentle-visible-bell)

(require 'elisp-slime-nav)
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'turn-on-elisp-slime-nav-mode))

(defalias 'yes-or-no-p 'y-or-n-p)
(setq column-number-mode t)

(defun conf-php-mode ()
  (setq indent-tabs-mode t
        tab-width 2
        c-basic-offset 2))
(add-hook 'php-mode-hook 'conf-php-mode)

(winner-mode t)
(global-set-key (kbd "C-c C-<backspace>") 'winner-undo)
(global-set-key (kbd "C-S-c C-S-<backspace>") 'winner-redo)

(setq markdown-command "pandoc -f markdown_github -s")

(load-file "/home/bill/repos/billy-macs/conf/startup-buffer.el")

;; END Bill's stuff

(message "\n\n init.el done loading  \n\n")
