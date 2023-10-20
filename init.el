(require 'package)

(defvar billy-conf-dir "/home/bill/.emacs.d/conf/")
(defvar billy-lib-dir "/home/bill/.emacs.d/lib/")

(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("MELPA"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("MELPA Stable" . 0)
        ("GNU ELPA"     . 5)
        ("MELPA"        . 10)))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar namooh/required-packages '(better-defaults))

(dolist (p namooh/required-packages)
  (when (not (package-installed-p 'better-defaults))
    (package-install 'better-defaults)))

(setq-default line-spacing 0.2)
(setq line-spacing 0.2)

(load-theme 'Billy-Theme t)

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(show-paren-mode 1)

(add-to-list 'default-frame-alist
             '(vertical-scroll-bars . nil))

(load-file (concat billy-conf-dir "avy-conf.el"))
(load-file (concat billy-conf-dir "util-fns.el"))
(load-file (concat billy-conf-dir "auto-complete-conf.el"))
(load-file (concat billy-conf-dir "browse-kill-ring-conf.el"))
;;(load-file (concat billy-conf-dir "color-theme-conf.el"))
(load-file (concat billy-conf-dir "cider-conf.el"))
(load-file (concat billy-conf-dir "clojure-conf.el"))
(load-file (concat billy-conf-dir "ido-conf.el"))
(load-file (concat billy-conf-dir "lisp-conf.el"))
(load-file (concat billy-conf-dir "paredit-conf.el"))
(load-file (concat billy-conf-dir "popwin-conf.el"))
(load-file (concat billy-conf-dir "recentf-conf.el"))
;;(load-file (concat billy-conf-dir "rust-conf.el"))
(load-file (concat billy-conf-dir "rustic-conf.el"))
(load-file (concat billy-conf-dir "smex-conf.el"))
(load-file (concat billy-conf-dir "backup-dir-conf.el"))
(load-file (concat billy-conf-dir "ahs-conf.el"))
(load-file (concat billy-conf-dir "fzf-conf.el"))
(load-file (concat billy-conf-dir "winner-conf.el"))
(load-file (concat billy-conf-dir "rainbow-conf.el"))
;;(load-file (concat billy-conf-dir "php-conf.el"))
(load-file (concat billy-conf-dir "org-conf.el"))

;; GO =============

;; Company mode
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)

;; Go - lsp-mode
;; Set up before-save hooks to format buffer and add/delete imports.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Start LSP Mode and YASnippet mode
(add-hook 'go-mode-hook #'lsp-deferred)
;;(add-hook 'go-mode-hook #'yas-minor-mode)

(add-hook 'go-mode-hook (lambda () (auto-complete-mode -1)))

;; END GO =============


(add-hook 'ibuffer-mode-hook
	  (lambda ()
	    (define-key ibuffer-mode-map
	      (kbd "C-o")
	      'avy-goto-word-1)))

;; https://github.com/politza/pdf-tools
(pdf-loader-install)

(global-set-key (kbd "C-c n e b") 'cider-eval-buffer)

;;set the mark
(global-set-key (kbd "C-SPC") 'set-mark-command)

;;override C-x C-o
(global-set-key (kbd "C-x C-o") 'other-window)

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

(setq icon-title-format '("" invocation-name ": "(:eval (if (buffer-file-name)
                (abbreviate-file-name (buffer-file-name))
                  "%b"))))

(defun switch-to-most-recent-buffer ()
  (interactive)
  ;;(switch-to-buffer  (other-buffer (current-buffer) 2 ))
  (switch-to-buffer
   (first (first (window-prev-buffers)))))

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

(defun set-indent-tabs-mode-nil ()
  (interactive)
  (setq indent-tabs-mode nil))


(defun gentle-visible-bell ()
   (invert-face 'mode-line)
   (run-with-timer 0.1 nil 'invert-face 'mode-line))

(setq visible-bell nil
      ring-bell-function #'gentle-visible-bell)

(defun indent-buffer ()
      (interactive)
      (save-excursion
        (indent-region (point-min) (point-max) nil)))

(defalias 'yes-or-no-p 'y-or-n-p)
(setq column-number-mode t)

(setq markdown-command "pandoc -f markdown_github -s")

(eval-after-load 'clojure-mode
  '(sayid-setup-package))

(elpy-enable)

(defun make-this()
  (interactive)
  (let* ((src (file-name-nondirectory (buffer-file-name)))
         (exe (file-name-sans-extension src)))
    (compile (concat "make -B " exe))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cargo-process--enable-rust-backtrace t)
 '(custom-safe-themes
   '("6b233389ceb3d6699564bf4d95eb1ec5086308d687d0fa03e33af0128a2e067e" "599e6b74c4522a5e735453084c1465e4c69200bf766fa74351c84c4db6b596ce" "c7eb06356fd16a1f552cfc40d900fe7326ae17ae7578f0ef5ba1edd4fdd09e58" default))
 '(exec-path
   '("/home/bill/.local/bin" "/home/bill/bin" "/usr/local/sbin" "/usr/local/bin" "/usr/sbin" "/usr/bin" "/sbin" "/bin" "/usr/games" "/usr/local/games" "/snap/bin" "/usr/local/libexec/emacs/28.2/x86_64-pc-linux-gnu" "/home/bill/.cargo/bin" "/home/bill/go/bin" "/usr/local/go/bin"))
 '(fzf/args "")
 '(fzf/directory-start "/home/bill")
 '(fzf/executable "/home/bill/repos/billy-macs/lib/fzf1.sh")
 '(ibuffer-formats
   '((mark modified read-only locked " "
	   (name 30 30 :left :elide)
	   " "
	   (mode 16 16 :left :elide)
	   " " filename-and-process)
     (mark " "
	   (name 16 -1)
	   " " filename)))
 '(package-selected-packages
   '(go-mode cider clojure-mode company flycheck lsp-mode rustic lsp-java ccls json-mode avy pdf-tools use-package vlf smex paredit idomenu flx-ido edn browse-kill-ring better-defaults ac-cider))
 '(rust-rustfmt-bin "/home/bill/.cargo/bin/rustfmt")
 '(safe-local-variable-values
   '((cljr-magic-require-namespaces
      ("io" . "clojure.java.io")
      ("as" . "clojure.core.async")
      ("csv" . "clojure.data.csv")
      ("edn" . "clojure.edn")
      ("mat" . "clojure.core.matrix")
      ("nrepl" . "clojure.nrepl")
      ("pprint" . "clojure.pprint")
      ("s" . "clojure.spec.alpha")
      ("set" . "clojure.set")
      ("shell" . "clojure.java.shell")
      ("spec" . "clojure.spec.alpha")
      ("str" . "clojure.string")
      ("walk" . "clojure.walk")
      ("xml" . "clojure.data.xml")
      ("zip" . "clojure.zip")
      ("csk" . "camel-snake-kebab.core")
      ("cske" . "camel-snake-kebab.extras")
      ("duct" . "duct.core")
      ("fs" . "babashka.fs")
      ("ig" . "integrant.core")
      ("json" . "cheshire.core")
      ("m" . "malli.core")
      ("mi" . "malli.instrument")
      ("mr" . "malli.registry")
      ("mt" . "malli.transform")
      ("mu" . "malli.util")
      ("sql" . "honey.sql")
      ("sqlh" . "honey.sql.helpers")
      ("time" . "java-time")
      ("yaml" . "clj-yaml.core")
      ("lacinia" . "com.walmartlabs.lacinia")
      ("lacinia.executor" . "com.walmartlabs.lacinia.executor")
      ("lacinia.resolve" . "com.walmartlabs.lacinia.resolve")
      ("lacinia.schema" . "com.walmartlabs.lacinia.schema")
      ("lacinia.selection" . "com.walmartlabs.lacinia.selection")
      ("log" . "patch.common-log.interface")
      ("utils" . "patch.common-utils.interface"))
     (cljr-clojure-test-declaration . "[clojure.test :as test :refer [are deftest is testing]]")
     (cljr-warn-on-eval)
     (cider-ns-refresh-after-fn . "integrant.repl/resume")
     (cider-ns-refresh-before-fn . "integrant.repl/suspend")))
 '(smerge-command-prefix (kbd "C-S-c")))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ahs-face ((t (:background "#997755" :foreground "#333311" :weight ultra-bold))))
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

(load-file "/home/bill/repos/billy-macs/conf/startup-buffer.el")

;; END Bill's stuff

(message "\n\n init.el done loading  \n\n")

