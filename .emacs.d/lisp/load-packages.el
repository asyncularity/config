;; load all required packages

(defun load-elpa-packages ()
  (progn
    (setq tls-checktrust t)
    (setq gnutls-verify-error t)
    (let ((trustfile "/etc/ssl/certs/ca-certificates.crt"))
      (setq gnutls-trustfiles (list trustfile))
      (setq tls-program
            (list
             (format "gnutls-cli --x509cafile %s -p %%p %%h" trustfile))))

    (setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                             ;;			 ("marmalade" . "http://marmalade-repo.org/packages/")
                             ;;			 ("melpa" . "https://melpa.org/packages/")
                             ("melpa-stable" . "https://stable.melpa.org/packages/")))
    (let ((package-list '(ag
                          company
                          company-go
                          dash
                          go-mode
                          helm
                          helm-ag
                          helm-projectile
                          js2-mode
                          json-mode
                          exec-path-from-shell
                          magit
                          org-bullets
                          projectile
                          )))
      (package-initialize)
      ;; fetch the list of packages available
      (unless package-archive-contents
        (package-refresh-contents))
      ;; install the missing packages
      (dolist (package package-list)
        (unless (package-installed-p package)
          (package-install package))))

    ;; helm-projectile doesnt properly require helm-ag and ag, require them manually
    (require 'helm-ag)
    (require 'ag)

    (require 'helm-files)
    (require 'helm-projectile)
    (require 'projectile)
    )
  )

(provide 'load-packages)
