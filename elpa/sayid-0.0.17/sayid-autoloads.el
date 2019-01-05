;;; sayid-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "sayid" "sayid.el" (0 0 0 0))
;;; Generated autoloads from sayid.el

(autoload 'sayid--inject-jack-in-dependencies "sayid" "\
Inject the REPL dependencies of sayid at `cider-jack-in'.\nIf injecting the dependencies is not preferred set `sayid-inject-dependencies-at-jack-in' to nil.\n\n(fn)" nil nil)

(eval-after-load 'cider '(sayid--inject-jack-in-dependencies))

(autoload 'sayid-version "sayid" "\
Show which version of Sayid and the sayid Emacs package are in use.\n\n(fn)" t nil)

(autoload 'sayid-get-trace-ns-dir "sayid" "\
Return current trace ns dir, or prompt for it if not set.\n\n(fn)" t nil)

(autoload 'sayid-set-trace-ns-dir "sayid" "\
Prompt for trace ns dir and store value.\n\n(fn)" t nil)

(autoload 'sayid-query-form-at-point "sayid" "\
Query sayid for calls made to function defined at point.\n\n(fn)" t nil)

(autoload 'sayid-get-meta-at-point "sayid" "\
Query sayid for meta data of form at point.\n\n(fn)" t nil)

(autoload 'sayid-trace-fn-enable "sayid" "\
Enable tracing for symbol at point.  Symbol should point to a fn var.\n\n(fn)" t nil)

(autoload 'sayid-trace-fn-disable "sayid" "\
Disable tracing for symbol at point.  Symbol should point to a fn var.\n\n(fn)" t nil)

(autoload 'sayid-outer-trace-fn "sayid" "\
Add outer tracing for symbol at point.  Symbol should point to a fn var.\n\n(fn)" t nil)

(autoload 'sayid-inner-trace-fn "sayid" "\
Add inner tracing for symbol at point.  Symbol should point to a fn var.\n\n(fn)" t nil)

(autoload 'sayid-remove-trace-fn "sayid" "\
Remove tracing for symbol at point.  Symbol should point to a fn var.\n\n(fn)" t nil)

(autoload 'sayid-load-enable-clear "sayid" "\
Workflow helper function.\nDisable traces, load buffer, enable traces, clear log.\n\n(fn)" t nil)

(autoload 'sayid-get-workspace "sayid" "\
View sayid workspace.\n\n(fn)" t nil)

(autoload 'sayid-show-traced "sayid" "\
Show what sayid has traced.  Optionally specify namespace NS.\n\n(fn &optional NS)" t nil)

(autoload 'sayid-show-traced-ns "sayid" "\
Show what sayid has traced in current namespace.\n\n(fn)" t nil)

(autoload 'sayid-traced-buf-enter "sayid" "\
Perform 'enter' on trace buffer.  Either navigate to ns view or function source.\n\n(fn)" t nil)

(autoload 'sayid-trace-all-ns-in-dir "sayid" "\
Trace all namespaces in specified dir.\n\n(fn)" t nil)

(autoload 'sayid-trace-ns-in-file "sayid" "\
Trace namespace defined in current buffer.\n\n(fn)" t nil)

(autoload 'sayid-trace-ns-by-pattern "sayid" "\
Trace all namespaces that match specified pattern.\n\n(fn)" t nil)

(autoload 'sayid-trace-enable-all "sayid" "\
Enable all traces.\n\n(fn)" t nil)

(autoload 'sayid-trace-disable-all "sayid" "\
Disable all traces.\n\n(fn)" t nil)

(autoload 'sayid-traced-buf-inner-trace-fn "sayid" "\
Apply inner trace from trace buffer.\n\n(fn)" t nil)

(autoload 'sayid-traced-buf-outer-trace-fn "sayid" "\
Apply outer trace from trace buffer.\n\n(fn)" t nil)

(autoload 'sayid-traced-buf-enable "sayid" "\
Enable trace from trace buffer.\n\n(fn)" t nil)

(autoload 'sayid-traced-buf-disable "sayid" "\
Disable trace from trace buffer.\n\n(fn)" t nil)

(autoload 'sayid-traced-buf-remove-trace "sayid" "\
Remove trace from trace buffer.\n\n(fn)" t nil)

(autoload 'sayid-kill-all-traces "sayid" "\
Kill all traces.\n\n(fn)" t nil)

(autoload 'sayid-clear-log "sayid" "\
Clear workspace log.\n\n(fn)" t nil)

(autoload 'sayid-reset-workspace "sayid" "\
Reset all traces and log in workspace.\n\n(fn)" t nil)

(autoload 'sayid-buffer-nav-from-point "sayid" "\
Navigate from sayid buffer to function source.\n\n(fn)" t nil)

(autoload 'sayid-buffer-nav-to-prev "sayid" "\
Move point to previous function in sayid buffer.\n\n(fn)" t nil)

(autoload 'sayid-buffer-nav-to-next "sayid" "\
Move point to next function in sayid buffer.\n\n(fn)" t nil)

(autoload 'sayid-query-id-w-mod "sayid" "\
Query workspace for id, with optional modifier.\n\n(fn)" t nil)

(autoload 'sayid-query-id "sayid" "\
Query workspace for id.\n\n(fn)" t nil)

(autoload 'sayid-query-fn-w-mod "sayid" "\
Query workspace for function, with optional modifier.\n\n(fn)" t nil)

(autoload 'sayid-query-fn "sayid" "\
Query workspace for function.\n\n(fn)" t nil)

(autoload 'sayid-buf-def-at-point "sayid" "\
Def value at point to a var.\n\n(fn)" t nil)

(autoload 'sayid-buf-inspect-at-point "sayid" "\
Def value at point and pass to 'cider-inspect'.\n\n(fn)" t nil)

(autoload 'sayid-buf-pprint-at-point "sayid" "\
Open pretty-print buffer for value at point in sayid buffer.\n\n(fn)" t nil)

(autoload 'sayid-set-view "sayid" "\
Set view.\n\n(fn)" t nil)

(autoload 'sayid-toggle-view "sayid" "\
Toggle whether view is active.\n\n(fn)" t nil)

(autoload 'sayid-gen-instance-expr "sayid" "\
Try to generate an expression that will reproduce traced call.\nPlace expression in kill ring.\n\n(fn)" t nil)

(autoload 'sayid-buf-back "sayid" "\
Move to previous sayid buffer state.\n\n(fn)" t nil)

(autoload 'sayid-buf-forward "sayid" "\
Move to next sayid buffer state.\n\n(fn)" t nil)

(autoload 'sayid-mode "sayid" "\
A major mode for displaying Sayid output\n\n(fn)" t nil)

(autoload 'sayid-traced-mode "sayid" "\
A major mode for displaying Sayid trace output.\n\n(fn)" t nil)

(autoload 'sayid-pprint-mode "sayid" "\
A major mode for displaying Sayid pretty print output.\n\n(fn)" t nil)

(autoload 'sayid-setup-package "sayid" "\
Setup the sayid package.  Optionally takes CLJ-MODE-PREFIX,\nwhich is used as the prefix for clojure-mode keybindings.\nDefault prefix is 'C-c s'.\n\n(fn &optional CLJ-MODE-PREFIX)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "sayid" '("sayid-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; sayid-autoloads.el ends here
