;;$Id: .emacs,v 1.00 2018/10/17 21:45:17 dmorris Exp $

(package-initialize)
(require 'cl)
(require 'package)

(setq my-home (expand-file-name (concat "~" (or (getenv "SUDO_USER") (getenv "USER")))))
(setq my-emacsd (concat my-home "/.emacs.d/"))
(setq load-path (cons (concat my-emacsd "/lisp") load-path))
(setq load-path (cons (concat my-emacsd "/lisp/jdee-2.4.1/lisp") load-path))
(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "google-chrome")

(require 'id)
(require 'align)
(require 'jde-autoload)

;; load required packages from elpa
(require 'load-packages)
(load-elpa-packages)

(autoload 'js2-mode "js2-mode" nil t)
(load    "functions")

(defconst windows (equal window-system 'w32))
(defconst xwindows (equal window-system 'x))
(defconst nowindows (equal window-system nil))

(defun font-existsp (font)
  (if xwindows
      (if (null (x-list-fonts font))
          nil t)))

(if (font-existsp "-*-clean-bold-*-*-*-12-*-*-*-*-*-*-*")
    (set-default-font "-*-clean-bold-*-*-*-12-*-*-*-*-*-*-*")
  (if (font-existsp "-misc-fixed-medium-r-normal--13-*-100-100-c-70-iso8859-1")
      (set-default-font "-misc-fixed-medium-r-normal--13-*-100-100-c-70-iso8859-1")))

;;; KEYBINDINGS ;;;
(define-key global-map [?\C-n] 'Control-X-prefix)

;; Navigation
(define-key global-map [?\C-h] 'previous-line)
(define-key global-map [?\C-t] 'next-line)
(define-key global-map [?\C-e] 'backward-char)
(define-key global-map [?\C-u] 'forward-char)
(define-key global-map [?\M-h] 'backward-paragraph)
(define-key global-map [?\M-t] 'forward-paragraph)
(define-key global-map [?\M-e] 'backward-word)
(define-key global-map [?\M-u] 'forward-word)
(define-key global-map [?\C-\M-h] 'beginning-of-defun)

;; Copy/Paste
(define-key global-map [?\C-f] 'kill-ring-save)
(define-key global-map [?\M-f] 'kill-region)
(define-key global-map [?\M-k] 'kill-region)
(define-key global-map [?\C-k] 'kill-line-noring) 

;; Search
(define-key global-map [?\C-s] 'isearch-forward)
(define-key global-map [?\M-s] 'helm-projectile-grep)

;; Other stuff
(define-key global-map [?\C-c?w]     'insert-datestamp)
(define-key global-map [?\C-c?m]     'insert-id)
(define-key global-map [?\C-c?v]     'insert-copyright)
(define-key global-map [?\C-b]       'helm-mini)
;;(define-key global-map [?\C-n?\C-f]  'helm-find-files)
(define-key global-map [?\C-n?g]     'magit-status)
(define-key global-map [?\C-c?\C-c]  'comment-region)
(define-key global-map [?\C-c?\C-u]  'uncomment-region)
(define-key global-map [?\M-r]       'query-replace-regexp)
(define-key global-map [?\M-\\]      'indent-region)
(define-key global-map [C-tab]       'dabbrev-expand)
(define-key global-map [?\C-x?\C-r]  'revert-buffer)
(define-key global-map [?\C-x?\C-e]  'call-last-kbd-macro)
(define-key global-map [?\C-p]       'undo)
(define-key global-map [C-backspace] 'backward-kill-word)
(define-key global-map [?\C-o]       'set-mark-command)
(define-key global-map [?\C-j]       'end-of-line)
(define-key global-map [?\C-,]       'kill-whitespace)
(define-key global-map [?\C-x?\C-q]  'save-buffers-kill-emacs)
(define-key global-map [?\C-']       'universal-argument)
(define-key global-map [?\C-w]       'transpose-chars)
(define-key global-map [?\M-w]       'transpose-words)
(define-key global-map [?\C-c?\C-h]  'hs-hide-block)
(define-key global-map [?\C-c?\C-s]  'hs-show-block)
(define-key global-map [?\C-c?\C-l]  'hs-show-all)
(define-key global-map [?\C-c?\C-z]  'hs-hide-all)
(define-key global-map [?\C-c?\C-a]  'align-cols)
(define-key global-map [?\M-g]       'goto-line)

;; Habit breakers
(define-key global-map [?\C-.?\C-.] nil)
(define-key global-map [?\C-x?\C-b] nil)
(define-key global-map [?\C-x?\C-c] nil)
(define-key global-map [?\C-x?\C-o] nil)
(define-key global-map [?\C-x?\C-n] nil)

;; Search mode Stuff
(define-key isearch-mode-map [?\C-y] 'clipboard-yank)
(define-key isearch-mode-map [?\C-j] (lambda () "" (interactive) (progn (end-of-line) (isearch-exit))))
(define-key isearch-mode-map [?\C-h] (lambda () "" (interactive) (progn (previous-line 1) (isearch-exit))))
(define-key isearch-mode-map [?\C-t] (lambda () "" (interactive) (progn (next-line 1) (isearch-exit))))
(define-key isearch-mode-map [?\C-e] (lambda () "" (interactive) (progn (backward-char) (isearch-exit))))
(define-key isearch-mode-map [?\C-u] (lambda () "" (interactive) (progn (forward-char) (isearch-exit))))
(define-key isearch-mode-map [?\M-h] (lambda () "" (interactive) (progn (backward-paragraph) (isearch-exit))))
(define-key isearch-mode-map [?\M-t] (lambda () "" (interactive) (progn (forward-paragraph) (isearch-exit))))
(define-key isearch-mode-map [?\M-e] (lambda () "" (interactive) (progn (backward-word 1) (isearch-exit))))
(define-key isearch-mode-map [?\M-u] (lambda () "" (interactive) (progn (forward-word 1) (isearch-exit))))

;; helm
(setq
 ;; open helm buffer in another window
 helm-split-window-default-side 'other
 ;; do not occupy whole other window
 helm-split-window-in-side-p t)

;; prefer creating window on the right for the rest
(setq split-height-threshold nil)

(helm-mode t)
(global-set-key (kbd "M-x") 'helm-M-x)
;; (global-set-key (kbd "M-y") 'helm-show-kill-ring)
;; (global-set-key (kbd "C-x b") 'helm-mini)
;; (global-set-key (kbd "C-x ,") 'helm-mini)
;; (global-set-key (kbd "C-x C-f") 'helm-find-files)
;; (define-key helm-map (kbd "C-j") 'helm-maybe-exit-minibuffer)
;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)

;; "follow" in helm-occur
;;(cl-defmethod helm-setup-user-source ((source helm-source-multi-occur)) (setf (slot-value source 'follow) 1))

(require 'helm-projectile)
(defun helm-projectile-switch-buffer ()
  "Use Helm instead of ido to switch buffer in projectile."
  (interactive)
  (helm :sources helm-source-projectile-buffers-list
        :buffer "*helm projectile buffers*"
        :prompt (projectile-prepend-project-name "Switch to buffer: ")))


(require 'helm-projectile)
(defun helm-projectile-switch-buffer ()
  "Use Helm instead of ido to switch buffer in projectile."
  (interactive)
  (helm :sources helm-source-projectile-buffers-list
        :buffer "*helm projectile buffers*"
        :prompt (projectile-prepend-project-name "Switch to buffer: ")))

;; projectile
(require 'projectile)
(setq projectile-use-git-grep t)
(projectile-global-mode)
;; Override some projectile keymaps
(eval-after-load 'projectile
  '(progn
     (define-key projectile-command-map (kbd "b") 'helm-projectile-switch-buffer)
     (define-key projectile-command-map (kbd "f") 'helm-projectile)
     (define-key projectile-command-map (kbd "p") 'helm-projectile-switch-project)))

;;; KEYBINDINGS ;;;

(setq backup-directory-alist '(("." . ".~")))
(setq backup-directory-alist (list (cons ".*" (expand-file-name "~/.emacsbackup/"))))
(setq x-select-enable-clipboard nil)
(setq x-select-enable-primary t)

(setq ange-ftp-default-user "dmorris")
(setq add-log-full-name "dmorris")
(setq ids-creator-id "dmorris")

(setq inhibit-startup-echo-area-message "Asterisk")
(setq inhibit-startup-message t)
(setq blick-matching-paren nil)
(setq enable-local-variables 'query)
(setq next-line-add-newlines nil)
(setq completion-ignored-extensions 
      (list
       "CVS/" ".svn/" ".o" "~" ".bin" ".bak" ".aph" 
       ".elc" ".idx" ".dvi" ".class" ".lib"
       ".exe" ".com" ".gif" ".jpg" ".GIF"
       ".JPG" ".png" ".bmp" ".psd"))
(setq scroll-margin 1)
(setq sentence-end-double-space nil)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76))
(setq highlightlist  '(("\\<\\(FIXME\\)\\>" 1 font-lock-warning-face prepend)
		       ("\\<\\(XXX*\\)\\>"  1 font-lock-warning-face prepend)
		       ("\\<\\(TODO*\\)\\>" 1 font-lock-warning-face prepend)))


;;; hooks ;;;

(defun common-hook ()
  (local-set-key [?\M-e] 'backward-word)
  (local-set-key [?\C-j] 'end-of-line)
  (local-set-key [?\C-e] 'backward-char)
  (local-set-key [?\M-h] 'backward-paragraph)
  (local-set-key [?\M-t] 'forward-paragraph)
  (tab-nonsense))

(defun my-org-mode-hook ()
  (common-hook)
  (org-bullets-mode 1))

(defun my-go-mode-hook ()
  (local-set-key [?\C-c?\C-h]  'hs-hide-block)
  (local-set-key [?\C-c?\C-s]  'hs-show-block)
  (local-set-key [?\C-c?\C-l]  'hs-show-all)
  (local-set-key [?\C-c?\C-z]  'hs-hide-all)
  (add-hook 'before-save-hook 'gofmt-before-save)  
  (hs-minor-mode)
  (collapse-1))

(defun c-like-common-hook ()
  (local-set-key [?\C-c?\C-a] 'align-cols)
  (local-set-key [?\C-\M-h]   'beginning-of-defun)
  (local-set-key [?\C-\M-t]   'end-of-defun)
  (local-set-key [?\C-c?\C-f] 'c-mark-function)
  (local-set-key [?\C-c?\C-s] 'hs-show-block)
  (local-set-key [?\C-c?\C-u] 'uncomment-region)
  (local-set-key [return]     'newline-and-indent)
  (local-set-key [?\C-c?\C-t] 'nil)
  (local-set-key [?\M-g]      'goto-line-expand)
  (local-set-key [?\C-c?\C-h]  'hs-hide-block)
  (local-set-key [?\C-c?\C-s]  'hs-show-block)
  (local-set-key [?\C-c?\C-l]  'hs-show-all)
  (local-set-key [?\C-c?\C-z]  'hs-hide-all)
  (hs-minor-mode))

(defun my-c-mode-hook ()
  (common-hook)
  (c-like-common-hook)
  (c-set-style "stroustrup")
  (add-hook 'before-revert-hook 'hs-show-all)
  (add-hook 'after-revert-hook  'hs-hide-all)
  (hs-hide-all))

(defun my-java-mode-hook ()
  (common-hook)
  (c-like-common-hook)
  (local-set-key [?\C-c?\C-z] 'collapse-2)
  (add-hook 'before-revert-hook 'hs-show-all)
  (add-hook 'after-revert-hook  'collapse-2)
  (collapse-2))

(defun my-sh-mode-hook ()
  (common-hook))

(defun my-json-mode-hook ()
  (common-hook)
  (hs-minor-mode)
  (collapse-1))

(defun my-js2-mode-hook ()
  ;; http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
  (setq js-indent-level 4
	indent-tabs-mode nil
	c-basic-offset 4)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)

  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map [(meta control \;)] 
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
	 (insert " ]----- */"))
       ))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
					;(define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
      (js2-highlight-vars-mode))
  (common-hook)
  (c-like-common-hook)
  (local-set-key [?\C-c?\C-z] 'collapse-1)
  (local-set-key [?\C-c?\C-h] 'hs-hide-block)
  (local-set-key [?\C-c?\C-s] 'hs-show-block)
  (local-set-key [?\C-c?\C-l] 'hs-show-all)
  (local-set-key [?\C-c?\C-z] 'hs-hide-all)
  (collapse-1))

(defun py-outline-level ()
  "This is so that `current-column` DTRT in otherwise-hidden text"
  (let (buffer-invisibility-spec)
    (save-excursion
      (skip-chars-forward "\t ")
      (current-column))))

(defun my-python-mode-hook ()
  (common-hook)
  (local-set-key [C-tab] 'dabbrev-expand)
  (local-set-key [?\C-c?\C-u] 'uncomment-region)
  (local-set-key [?\C-c?\C-c] 'comment-region)
  (local-set-key [?\C-c?\C-h] 'hide-entry)
  (local-set-key [?\C-c?\C-z] 'hide-body)
  (setq outline-regexp "[^ \t\n]\\|[ \t]*\\(def[ \t]+\\|class[ \t]+\\)") 
  (setq outline-level 'py-outline-level) ; enable our level computation
  (setq outline-minor-mode-prefix "\C-c")
  (local-set-key [?\C-c?\C-u] 'uncomment-region)
  (outline-minor-mode t)
  (show-paren-mode 1))

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'java-mode-hook 'my-java-mode-hook)
(add-hook 'sh-mode-hook 'my-sh-mode-hook)
(add-hook 'python-mode-hook  'my-python-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'common-hook)
(add-hook 'js2-mode-hook 'my-js2-mode-hook)
(add-hook 'go-mode-hook 'my-go-mode-hook)
(add-hook 'json-mode-hook 'my-json-mode-hook)
(add-hook 'org-mode-hook 'my-org-mode-hook)

(setq auto-mode-alist (cons '("\.java$" . java-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\.js$" . js2-mode) auto-mode-alist))

(require 'server)
(or (server-running-p)
    (server-start))
(if (fboundp 'set-scroll-bar-mode) (set-scroll-bar-mode nil))
(font-lock-add-keywords 'java-mode highlightlist)
(font-lock-add-keywords 'jde-mode  highlightlist)
(font-lock-add-keywords 'c-mode    highlightlist)
(font-lock-add-keywords 'go-mode   highlightlist)

(set-background-color "grey0")
(set-foreground-color "grey88")
(set-cursor-color "lightskyblue")
(show-paren-mode)

(if window-system
    (custom-set-faces
     '(blue ((t (:foreground "skyblue"))))
     '(custom-rogue-face ((t (:background "black" :foreground "blue4"))))
     '(font-lock-comment-face ((t (:foreground "Grey40"))))
     '(font-lock-constant-face ((((class color) (background dark)) (:foreground "#ABC"))))
     '(font-lock-doc-face ((t (:foreground "Grey40"))))
     '(font-lock-function-name-face ((t (:foreground "skyblue"))))
     '(font-lock-keyword-face ((t (:foreground "#6633cc"))))
     '(font-lock-preprocessor-face ((t (:foreground "lightgreen"))))
     '(font-lock-string-face ((t (:foreground "#77BB99"))))
     '(font-lock-type-face ((t (:foreground "CornflowerBlue"))))
     '(font-lock-variable-name-face ((t (:foreground "skyblue"))))
     '(font-lock-warning-face ((t (:foreground "red"))))
     '(green ((t (:foreground "SeaGreen"))))
     '(highlight ((t (:foreground "White" :background "SlateGrey"))))
     '(isearch ((t (:foreground "LightSlateBlue" :background "navyblue"))))
     '(paren-match ((t (:background "grey35"))))
     '(region ((((class color) (background dark)) (:foreground "green" :background "darkslategray"))))
     '(secondary-selection ((t (:foreground "green" :background "darkslategray"))))
     '(show-paren-match-face ((((class color)) (:foreground "#1133ff"))))
     '(widget-documentation-face ((((class color) (background dark)) (:foreground "LightSeaGreen")) (((class color) (background light)) (:foreground "dark green")) (t nil)))
     '(zmacs-region ((t (:foreground "green" :background "darkslategrey"))))))

(if (not window-system)
    (custom-set-faces
     '(blue ((t (:foreground "skyblue"))))
     '(custom-rogue-face ((t (:background "black" :foreground "blue4"))))
     '(font-lock-comment-face ((t (:foreground "white"))))
     '(font-lock-constant-face ((((class color) (background dark)) (:foreground "#ABC"))))
     '(font-lock-doc-face ((t (:foreground "Grey40"))))
     '(font-lock-function-name-face ((t (:foreground "skyblue"))))
     '(font-lock-keyword-face ((t (:foreground "#6633cc"))))
     '(font-lock-preprocessor-face ((t (:foreground "lightgreen"))))
     '(font-lock-string-face ((t (:foreground "#77BB99"))))
     '(font-lock-type-face ((t (:foreground "CornflowerBlue"))))
     '(font-lock-variable-name-face ((t (:foreground "skyblue"))))
     '(font-lock-warning-face ((t (:foreground "red"))))
     '(green ((t (:foreground "SeaGreen"))))
     '(highlight ((t (:foreground "White" :background "SlateGrey"))))
     '(isearch ((t (:foreground "LightSlateBlue" :background "navyblue"))))
     '(paren-match ((t (:background "grey35"))))
     '(region ((((class color) (background dark)) (:foreground "green" :background "darkslategray"))))
     '(secondary-selection ((t (:foreground "green" :background "darkslategray"))))
     '(show-paren-match-face ((((class color)) (:foreground "#1133ff"))))
     '(widget-documentation-face ((((class color) (background dark)) (:foreground "LightSeaGreen")) (((class color) (background light)) (:foreground "dark green")) (t nil)))
     '(zmacs-region ((t (:foreground "green" :background "darkslategrey"))))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dabbrev-case-fold-search nil)
 '(global-font-lock-mode 1 nil (font-lock))
 '(jde-gen-comments nil)
 '(menu-bar-mode nil)
 '(package-selected-packages (quote (helm-projectile helm go-mode)))
 '(tool-bar-mode nil)
 '(transient-mark-mode 1)
 '(visible-bell t))

(message "(* emacs *)")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blue ((t (:foreground "skyblue"))))
 '(custom-rogue-face ((t (:background "black" :foreground "blue4"))))
 '(font-lock-comment-face ((t (:foreground "Grey40"))))
 '(font-lock-constant-face ((((class color) (background dark)) (:foreground "#ABC"))))
 '(font-lock-doc-face ((t (:foreground "Grey40"))))
 '(font-lock-function-name-face ((t (:foreground "skyblue"))))
 '(font-lock-keyword-face ((t (:foreground "#6633cc"))))
 '(font-lock-preprocessor-face ((t (:foreground "lightgreen"))))
 '(font-lock-string-face ((t (:foreground "#77BB99"))))
 '(font-lock-type-face ((t (:foreground "CornflowerBlue"))))
 '(font-lock-variable-name-face ((t (:foreground "skyblue"))))
 '(font-lock-warning-face ((t (:foreground "red"))))
 '(green ((t (:foreground "SeaGreen"))))
 '(highlight ((t (:foreground "White" :background "SlateGrey"))))
 '(isearch ((t (:foreground "LightSlateBlue" :background "navyblue"))))
 '(paren-match ((t (:background "grey35"))))
 '(region ((((class color) (background dark)) (:foreground "green" :background "darkslategray"))))
 '(secondary-selection ((t (:foreground "green" :background "darkslategray"))))
 '(show-paren-match ((((class color)) (:foreground "#1133ff"))))
 '(widget-documentation ((((class color) (background dark)) (:foreground "LightSeaGreen")) (((class color) (background light)) (:foreground "dark green")) (t nil)))
 '(widget-documentation-face ((((class color) (background dark)) (:foreground "LightSeaGreen")) (((class color) (background light)) (:foreground "dark green")) (t nil)) t)
 '(zmacs-region ((t (:foreground "green" :background "darkslategrey")))))
