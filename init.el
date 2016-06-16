(require 'package)

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
(define-key paredit-mode-map (kbd "C-M-k")   'live-paredit-copy-sexp-at-point)

;;browse kill ring (visual paste)
(global-set-key (kbd "M-y") 'browse-kill-ring)

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

;; File
(global-set-key (kbd "C-x f")     'live-recentf-ido-find-file)
(global-set-key (kbd "C-x C-r")   'ido-recentf-open)
(global-set-key (kbd "C-x C-b")   'ibuffer)

;; Ace jump mode
(global-set-key (kbd "C-o") 'ace-jump-mode)

(require 'cider-repl)
(require 'cider-mode)
;; Show documentation/information with M-RET
(define-key lisp-mode-shared-map (kbd "M-RET") 'live-lisp-describe-thing-at-point)
(define-key cider-repl-mode-map (kbd "M-RET") 'cider-doc)
(define-key cider-mode-map (kbd "M-RET") 'cider-doc)

;; ====== Bill Stuff

(message "\n\n Doing Bill's stuff \n\n")

(global-unset-key (kbd "C-z")) ;; get rid of "suspend frame"
(cua-mode 0) ;; kill CUA

(global-linum-mode t)

(global-set-key (kbd  "C-,") 'beginning-of-line-text)

(load-file "/home/bill/.emacs.d/lib/fzy-locate/fzy-locate.el")
(fzloc-load-dbs-from-path "/home/bill/repos/emacs-live/locatedbs/*.locatedb")
(setq fzloc-filter-regexps '("/target/" "/.git/"))

(global-set-key (kbd "C-x SPC") 'fzy-locate)
(global-set-key (kbd  "C-x p") 'ace-jump-mode-pop-mark)
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

;; Finds the auto-highlight-symbol file and loads it
;; I have no idea why the next line is necessary, but 'require' wasn't working
; (load-file (first (file-expand-wildcards "/home/bill/.emacs.d/elpa/auto-highlight-symbol-*/auto-highlight-symbol.el" )))
; (add-to-list 'ahs-modes 'clojure-mode)
; (setq ahs-default-range 'ahs-range-whole-buffer)
; (global-auto-highlight-symbol-mode t)

(defun switch-to-most-recent-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key (kbd  "C-M-<return>") 'switch-to-most-recent-buffer)
(global-set-key (kbd  "C-M-<backspace>") 'revert-buffer)
(global-set-key (kbd  "C-S-o") 'ace-jump-char-mode)
(global-set-key (kbd  "C-S-a") 'mark-whole-buffer)

;; https://github.com/clojure-emacs/cider#basic-configuration
(setq cider-auto-select-error-buffer nil)

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

(defun insert-spyd ()
  (interactive)
  (insert "#spy/d")
  (live-delete-whitespace-except-one))

(defun repl-clear-and-prev ()
  (interactive)
  (cider-repl-clear-buffer)
  (cider-repl-previous-input))

(global-set-key (kbd "C-c s d") 'insert-spyd)
(global-set-key (kbd "C-S-c C-S-p") 'repl-clear-and-prev)

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

;; END Bill's stuff

(message "\n\n init.el done loading  \n\n")


