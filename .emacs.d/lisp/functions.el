;; $Id: functions.el,v 1.00 2003/11/24 13:29:18 dmorris Exp $

(defun goto-line-expand (arg)
  "Goto line plus hideshow show block"
  (interactive "NGoto Line: ")
  (setq arg (prefix-numeric-value arg))
  (goto-line arg)
  (hs-show-block)
  (goto-line arg))

(defun tab-nonsense ()
  "Sets my tab prefs."
  (progn
    (setq tab-width 4)
    (setq indent-tabs-mode nil)))

(defun kill-whitespace ()
  "Kill the whitespace between to non-whitespace characters"
  (interactive "*")
  (save-excursion
    (save-restriction
      (save-match-data
        (progn
          (re-search-backward "[^ \t\r\n]" nil t)
          (re-search-forward "[ \t\r\n]+" nil t)
          (replace-match "" nil nil))))))

(defun insert-copyright ()
  "Insert copyright notice at top of buffer"
  (interactive "*")
  (save-excursion
    (goto-char 0)
    (insert-file-contents "~/.emacs.d/copyright")
    (re-search-forward "$Id:" nil t)
    (backward-delete-char 4)
    (insert-id)))

;(defun collapse-comments ()
;  "Collases all the c-style comments with hide-show"
;  (interactive)
;  (save-excursion
;    (save-restriction
;      (save-match-data
;        (while
;            (re-search-forward hs-c-start-regexp nil 't)
;          (progn
;            (if (not (hs-already-hidden-p)) (hs-hide-block))
;            (next-line 1)))))))
(defun collapse-comments ())

(defun collapse-java ()
  "Collases all the java functions with hide-show"
  (interactive)
  (save-excursion
    (save-restriction
      (save-match-data
        (progn
          (hs-hide-initial-comment-block)
          (hs-hide-level 2)
          (collapse-comments))))))

(defun collapse-go ()
  "Collases all the java functions with hide-show"
  (interactive)
  (save-excursion
    (save-restriction
      (save-match-data
        (progn
          (hs-hide-initial-comment-block)
          (hs-hide-level 1)
          (collapse-comments))))))

(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (js--proper-indentation parse-status))
           node)

      (save-excursion

        ;; I like to indent case and labels to half of the tab width
        (back-to-indentation)
        (if (looking-at "case\\s-")
            (setq indentation (+ indentation (/ js-indent-level 2))))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

