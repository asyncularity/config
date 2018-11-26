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
(require 'load-packages)
(load-elpa-packages)
(load "functions")

(if (boundp 'x-list-fonts)
	(progn
      (defun font-exists-p (font) "check if font exists" (if (null (x-list-fonts font)) nil t))
      (if (font-exists-p "-*-clean-bold-*-*-*-12-*-*-*-*-*-*-*")
          (set-default-font "-*-clean-bold-*-*-*-12-*-*-*-*-*-*-*")
        (if (font-exists-p "-misc-fixed-medium-r-normal--13-*-100-100-c-70-iso8859-1")
            (set-default-font "-misc-fixed-medium-r-normal--13-*-100-100-c-70-iso8859-1")))))

;;; KEYBINDINGS ;;;

(define-key global-map (kbd "C-n") 'Control-X-prefix)
(define-key global-map (kbd "M-x") 'helm-M-x)

;; Navigation
(define-key global-map (kbd "C-h") 'previous-line)
(define-key global-map (kbd "C-t") 'next-line)
(define-key global-map (kbd "C-e") 'backward-char)
(define-key global-map (kbd "C-u") 'forward-char)
(define-key global-map (kbd "M-h") 'backward-paragraph)
(define-key global-map (kbd "M-t") 'forward-paragraph)
(define-key global-map (kbd "M-e") 'backward-word)
(define-key global-map (kbd "M-u") 'forward-word)
(define-key global-map (kbd "C-M-h") 'beginning-of-defun)

;; Copy/Paste
(define-key global-map (kbd "C-f") 'kill-ring-save)
(define-key global-map (kbd "M-f") 'kill-region)
(define-key global-map (kbd "M-k") 'kill-region)
(define-key global-map (kbd "C-k") 'kill-line-noring) 
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)

;; Search
(define-key global-map (kbd "C-s") 'isearch-forward)
(define-key global-map (kbd "M-s") 'helm-projectile-grep)

;; Other stuff
(define-key global-map (kbd "C-<backspace>") 'backward-delete-word-noring)
(define-key global-map (kbd "M-d")           'delete-word-noring)
(define-key global-map (kbd "C-c w")     'insert-datestamp)
(define-key global-map (kbd "C-c m")     'insert-id)
(define-key global-map (kbd "C-c v")     'insert-copyright)
(define-key global-map (kbd "C-b")       'helm-mini)
(define-key global-map (kbd "C-n C-f")   'helm-find-files)
(define-key global-map (kbd "C-n g")     'magit-status)
(define-key global-map (kbd "C-n c")     'org-capture)
(define-key global-map (kbd "C-c C-c")   'comment-region)
(define-key global-map (kbd "C-c C-u")   'uncomment-region)
(define-key global-map (kbd "M-r")       'query-replace-regexp)
(define-key global-map (kbd "M-\\")      'indent-region)
(define-key global-map (kbd "C-<tab>")   'dabbrev-expand)
(define-key global-map (kbd "C-x C-r")   'revert-buffer)
(define-key global-map (kbd "C-x C-e")   'call-last-kbd-macro)
(define-key global-map (kbd "C-p")       'undo)
(define-key global-map (kbd "C-o")       'set-mark-command)
(define-key global-map (kbd "C-j")       'end-of-line)
(define-key global-map (kbd "C-,")       'kill-whitespace)
(define-key global-map (kbd "C-x C-q")   'save-buffers-kill-emacs)
(define-key global-map (kbd "C-.")       'universal-argument)
(define-key global-map (kbd "C-;")       'help)
(define-key global-map (kbd "C-w")       'transpose-chars)
(define-key global-map (kbd "M-w")       'transpose-words)
(define-key global-map (kbd "C-c C-h")   'hs-hide-block)
(define-key global-map (kbd "C-c C-s")   'hs-show-block)
(define-key global-map (kbd "C-c C-l")   'hs-show-all)
(define-key global-map (kbd "C-c C-z")   'hs-hide-all)
(define-key global-map (kbd "C-c C-a")   'align-cols)
(define-key global-map (kbd "M-g")       'goto-line)

;; Habit breakers
(define-key global-map (kbd "C-x C-b") nil)
(define-key global-map (kbd "C-x C-c") nil)
(define-key global-map (kbd "C-x C-o") nil)
(define-key global-map (kbd "C-x C-n") nil)

;; isearch mode-map
(define-key isearch-mode-map (kbd "C-y") 'clipboard-yank)
(define-key isearch-mode-map (kbd "C-j") (lambda () "" (interactive) (progn (end-of-line) (isearch-exit))))
(define-key isearch-mode-map (kbd "C-h") (lambda () "" (interactive) (progn (previous-line 1) (isearch-exit))))
(define-key isearch-mode-map (kbd "C-t") (lambda () "" (interactive) (progn (next-line 1) (isearch-exit))))
(define-key isearch-mode-map (kbd "C-e") (lambda () "" (interactive) (progn (backward-char) (isearch-exit))))
(define-key isearch-mode-map (kbd "C-u") (lambda () "" (interactive) (progn (forward-char) (isearch-exit))))
(define-key isearch-mode-map (kbd "M-h") (lambda () "" (interactive) (progn (backward-paragraph) (isearch-exit))))
(define-key isearch-mode-map (kbd "M-t") (lambda () "" (interactive) (progn (forward-paragraph) (isearch-exit))))
(define-key isearch-mode-map (kbd "M-e") (lambda () "" (interactive) (progn (backward-word 1) (isearch-exit))))
(define-key isearch-mode-map (kbd "M-u") (lambda () "" (interactive) (progn (forward-word 1) (isearch-exit))))

;; helm mode-map
(define-key helm-find-files-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-find-files-map (kbd "M-e") 'backward-word)
(define-key helm-find-files-map (kbd "M-u") 'forward-word)
(define-key helm-find-files-map (kbd "C-<backspace>") 'backward-delete-word-noring)
;;(define-key helm-map (kbd "<tab>") 'helm-maybe-exit-minibuffer)
;;(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
;;(define-key helm-map (kbd "C-j") 'helm-execute-persistent-action)

(eval-after-load 'projectile
  '(progn
     (define-key projectile-command-map (kbd "b") 'helm-projectile-switch-buffer)
     (define-key projectile-command-map (kbd "f") 'helm-projectile)
     (define-key projectile-command-map (kbd "p") 'helm-projectile-switch-project)))

;;; KEYBINDINGS ;;;

(helm-mode t)
(projectile-global-mode)

(setq backup-directory-alist `((".*" . ,"~/.emacs.d/backup/")))
(setq x-select-enable-clipboard nil)
(setq x-select-enable-primary t)

(setq projectile-use-git-grep t)

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

;;; generic hooks ;;;

(defun common-hook ()
  (local-set-key (kbd "M-e") 'backward-word)
  (local-set-key (kbd "C-j") 'end-of-line)
  (local-set-key (kbd "C-e") 'backward-char)
  (local-set-key (kbd "M-h") 'backward-paragraph)
  (local-set-key (kbd "M-t") 'forward-paragraph)
  (font-lock-add-keywords nil highlightlist)
  (tab-nonsense))

(defun hideshow-hook ()
  (local-set-key (kbd "C-c C-h") 'hs-hide-block)
  (local-set-key (kbd "C-c C-s") 'hs-show-block)
  (local-set-key (kbd "C-c C-l") 'hs-show-all)
  (local-set-key (kbd "C-c C-z") 'hs-hide-all)
  (hs-minor-mode)
  (add-hook 'before-revert-hook 'hs-show-all)
  (add-hook 'after-revert-hook  'hs-hide-all))

(defun c-like-hook ()
  (local-set-key (kbd "C-c C-a") 'align-cols)
  (local-set-key (kbd "C-M-h")   'beginning-of-defun)
  (local-set-key (kbd "C-M-t")   'end-of-defun)
  (local-set-key (kbd "C-c C-f") 'c-mark-function)
  (local-set-key (kbd "C-c C-u") 'uncomment-region)
  (local-set-key (kbd "<return>")     'newline-and-indent)
  (local-set-key (kbd "C-c C-t") 'nil)
  (local-set-key (kbd "M-g")      'goto-line-expand))

;;; language hooks ;;;

(defun my-org-mode-hook ()
  (common-hook)
  (org-bullets-mode 1))

(defun my-go-mode-hook ()
  (common-hook)
  (hideshow-hook)
  ; http://tleyden.github.io/blog/2014/05/27/configure-emacs-as-a-go-editor-from-scratch-part-2/
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)  
  (local-set-key (kbd "C-c C-z") 'collapse-1)
  (auto-complete-mode)
  (local-set-key (kbd "C-<tab>") 'auto-complete)
  (define-key ac-complete-mode-map (kbd "C-<tab>") 'ac-next)
  (define-key ac-complete-mode-map (kbd "C-h") 'ac-previous)
  (define-key ac-complete-mode-map (kbd "C-t") 'ac-next)
  (require 'go-autocomplete)
  (collapse-1))

(defun my-c-mode-hook ()
  (common-hook)
  (hideshow-hook)
  (c-like-hook)
  (c-set-style "stroustrup")
  (hs-hide-all))

(defun my-java-mode-hook ()
  (common-hook)
  (hideshow-hook)
  (c-like-hook)
  (local-set-key (kbd "C-c C-z") 'collapse-2)
  (collapse-2))

(defun my-sh-mode-hook ()
  (common-hook))

(defun my-json-mode-hook ()
  (common-hook)
  (hideshow-hook)
  (local-set-key (kbd "C-c C-z") 'collapse-1)
  (collapse-1))

(defun my-js2-mode-hook ()
  ;; http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
  (setq js-indent-level 4
        indent-tabs-mode nil
        c-basic-offset 4)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map (kbd "<return>") 'newline-and-indent)
  (define-key js2-mode-map (kbd "<backspace>") 'c-electric-backspace)
  (if (featurep 'js2-highlight-vars)
      (js2-highlight-vars-mode))
  (common-hook)
  (hideshow-hook)
  (c-like-hook)
  (local-set-key (kbd "C-c C-z") 'collapse-3)
  (collapse-3))

(defun my-python-mode-hook ()
  (common-hook)
  (hideshow-hook)
  (show-paren-mode 1)
  (local-set-key (kbd "C-c C-z") 'collapse-1)
  (collapse-1))

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

(setq org-capture-templates
 '(("t" "Todo" entry (file+headline "~/todo.org" "Uncategorized")
    "* TODO %?")
   ("b" "Bug to File" entry (file+headline "~/todo.org" "Bugs to file")
    "* TODO %?")))

(require 'server)
(or (server-running-p)
    (server-start))
(if (fboundp 'set-scroll-bar-mode) (set-scroll-bar-mode nil))

(set-background-color "grey0")
(set-foreground-color "grey88")
(set-cursor-color "lightskyblue")
(show-paren-mode)

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
 '(zmacs-region ((t (:foreground "green" :background "darkslategrey")))))

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
