(deftheme Billy-Theme
  "Created 2020-07-07.")

(custom-theme-set-faces
 'Billy-Theme
 '(default ((t (:inherit nil :stipple nil :background "#112222" :foreground "#BBBBAA" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight light :height 113 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 '(cursor ((t (:background "#999988" :foreground "#112222" :inverse-video t))))
 '(fixed-pitch ((t (:family "Monospace"))))
 '(variable-pitch ((((type w32)) (:foundry "outline" :family "Arial")) (t (:family "Sans Serif"))))
 '(escape-glyph ((t (:weight bold :foreground "#7d7c61"))))
 '(homoglyph ((((background dark)) (:foreground "cyan")) (((type pc)) (:foreground "#cc3399")) (t (:foreground "brown"))))
 '(minibuffer-prompt ((t (:foreground "#99CC66" :background "#000000"))))
 '(highlight ((t (:background "#333333"))))
 '(region ((t (:background "#997777" :foreground "#112222"))))
 '(shadow ((((class color grayscale) (min-colors 88) (background light)) (:foreground "grey50")) (((class color grayscale) (min-colors 88) (background dark)) (:foreground "grey70")) (((class color) (min-colors 8) (background light)) (:foreground "green")) (((class color) (min-colors 8) (background dark)) (:foreground "#cccc44"))))
 '(secondary-selection ((t (:background "#5f5f5f"))))
 '(trailing-whitespace ((t (:background "#ff0000"))))
 '(font-lock-builtin-face ((t (:foreground "#6699CC" :weight normal))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#6abd50" :weight bold :background "#113322"))))
 '(font-lock-comment-face ((t (:slant italic :foreground "#99BBAA" ))))
 '(font-lock-constant-face ((t (:foreground "#66DDEE"))))
 '(font-lock-doc-face ((t (:foreground "#CCBB22"))))
 '(font-lock-function-name-face ((t (:foreground "#cc9933"))))
 '(font-lock-keyword-face ((t (:foreground "#77BBCC" :weight medium))))
 '(font-lock-negation-char-face ((t (:weight bold :foreground "#7d7c61"))))
 '(font-lock-preprocessor-face ((t (:foreground "#919191"))))
 '(font-lock-regexp-grouping-backslash ((t (:weight bold :foreground "#E9C062"))))
 '(font-lock-regexp-grouping-construct ((t (:weight bold :foreground "#DD6666"))))
 '(font-lock-string-face ((t (:foreground "#EE9999"))))
 '(font-lock-type-face ((t (:foreground "#DDDDAA" :weight black))))
 '(font-lock-variable-name-face ((t (:foreground "#AA77AA"))))
 '(font-lock-warning-face ((t (:weight bold :foreground "#ff69b4"))))
 '(button ((t (:underline (:color foreground-color :style line)))))
 '(link ((t (:weight bold :underline (:color foreground-color :style line) :foreground "#cccc44"))))
 '(link-visited ((t (:weight normal :underline (:color foreground-color :style line) :foreground "#d0bf8f"))))
 '(fringe ((t (:foreground "#dcdccc" :background "#2b2b2b"))))
 '(header-line ((t (:box (:line-width -1 :color nil :style released-button) :foreground "#cccc44" :background "#2b2b2b"))))
 '(tooltip ((t (:foreground "black" :background "lightyellow" :inherit (variable-pitch)))))
 '(mode-line ((t (:box (:line-width -1 :color "#334466" :style nil) :foreground "#4c83ff" :background "#333333"))))
 '(mode-line-buffer-id ((t (:weight bold :foreground "#BB9966"))))
 '(mode-line-emphasis ((t (:weight normal))))
 '(mode-line-highlight ((((class color) (min-colors 88)) (:box (:line-width 2 :color "#666666" :style released-button))) (t (:inherit (highlight)))))
 '(mode-line-inactive ((t (:weight light :box (:line-width -1 :color "#444444" :style nil) :foreground "#4D4D4D" :background "#1A1A1A"))))
 '(isearch ((t (:weight bold :foreground "#000000" :background "#cc3399"))))
 '(isearch-fail ((t (:foreground "#bdbdb3" :background "#996666"))))
 '(lazy-highlight ((t (:weight bold :foreground "#000000" :background "#cccc44"))))
 '(match ((t (:weight bold :foreground "#cc3399" :background "#000000"))))
 '(next-error ((t (:inherit (region)))))
 '(query-replace ((t (:background "#333333"))))
 '(compilation-info ((t (:foreground "#BBBBBB"))))
 '(compilation-line-number ((t (:foreground "#cccc44"))))
 '(package-name ((t (:foreground "#66aacc")))))

(provide-theme 'Billy-Theme)

