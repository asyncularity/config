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

(defun collapse-level (level)
  "Collases all the objects at the specified level with hide-show"
  (interactive "r")
  (save-excursion
    (save-restriction
      (save-match-data
        (progn
          (hs-hide-initial-comment-block)
          (hs-hide-level level))))))

(defun collapse-1 ()
  "Collases all the go functions with hide-show"
  (collapse-level 1))

(defun collapse-2 ()
  "Collases all the go functions with hide-show"
  (collapse-level 2))


