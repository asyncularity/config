; http://tleyden.github.io/blog/2014/05/22/configure-emacs-as-a-go-editor-from-scratch/

; go get golang.org/x/tools/cmd/goimports
; go get golang.org/x/tools/cmd/...
; go get github.com/rogpeppe/godef
; go get -u github.com/nsf/gocode

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

(setq my-emacsd )

(setenv "GOPATH" (concat my-home "/go/"))

(with-eval-after-load 'go-mode
  (require 'go-autocomplete))

