;;; electric-align.el --- Realtime . -*- lexical-binding: t -*-

;;-------------------------------------------------------------------
;;
;; Copyright (C) 2015 Yuuki Arisawa
;;
;; This file is NOT part of Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA
;;
;;-------------------------------------------------------------------

;; Author: Yuuki Arisawa <yuuki.ari@gmail.com>
;; URL: https://github.com/uk-ar/electric-align
;; Package-Requires: ((cl-lib "0.5"))
;; Created: 1 April 2015
;; Version: 1.0
;; Keywords: align
;;; Compatibility: GNU Emacs 24.4

;;; Commentary:

(require 'align)

;;; Code:
(defun electric-align-electric ();;(beg end length)
  (undo-boundary)
  (align-current)
  ;;(font-lock-fontify-buffer)
  )

(defun electric-align-electric-del (arg)
  (interactive "P")
  ;;todo find & save keymap
  (call-interactively 'backward-delete-char-untabify)
  (undo-boundary)
  (align-current)
  )

(defun electric-align-electric-deletechar (N)
  (interactive "P")
  ;;todo find & save keymap
  (call-interactively 'delete-char)
  (undo-boundary)
  (align-current)
  )

;; set-temporary-overlay-map is inactive when other key
;;minor mode map
;;(kbd "<deletechar>")
;;(kbd "<DEL>")
(defvar electric-align-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "<DEL>") 'electric-align-electric-del);;backward
    (define-key map (kbd "C-d") 'electric-align-electric-deletechar);;forward
    map)
  "Keymap used by `electric-align-mode'.")

(define-minor-mode electric-align-mode
  "Toggle electric align . "
  :lighter " EA"
  :keymap electric-align-mode-map
  :group 'electric-align
  (if electric-align-mode
      (progn
        ;;(add-hook 'after-change-functions #'electric-align-electric nil t)
        (add-hook 'post-self-insert-hook #'electric-align-electric t)
        )
    ;;(remove-hook 'after-change-functions #'electric-align-electric t)
    (remove-hook 'post-self-insert-hook #'electric-align-electric)
    ))

;; (align-current '((c++-comment-end
;;                   (regexp . "\\(?:/\\*.*\\)\\(\\s-*\\)\\*/")
;;                   (modes . align-c++-modes)
;;                   )))
;; bug in delete-forward
;;https://google-styleguide.googlecode.com/svn/trunk/google-c-style.el
;;http://masutaka.net/chalow/2009-07-16-1.html
;;http://tuhdo.github.io/c-ide.html
;; (align-current '((c++-comment-end
;;                   (regexp . "/\\*.*\\(\\s-*\\)\\*/\\(\\s-*\\)$");;"/\\*.*[^ ]\\(\\s-*\\)\\(\\*/\\s-*\\)$");;"/\\*.*?\\(\\s-*\\)
;;                   ;;
;;                   ;;"/\\*.*\\(\\s-*\\)\\(\\*/\\s-*\\)$")
;;                   (group 1 2)
;;                   (modes . align-c++-modes)
;;                   (justify . t)
;;                   (tab-stop)
;;                   ;;(spacing . 0)
;;                   )))
;; (defun foo (end reverse)
;;   (funcall (if reverse 're-search-backward
;;              're-search-forward)
;;            (concat "[^ \t\n\\\\]"
;;                    (regexp-quote comment-start)
;;                    "\\(.+\\)$") end t))

;; (align-current '((c++-comment-end
;;                   ;;(regexp . "/\\*.*?\\(\\s-*\\)\\*/\\(\\s-*$\\)")
;;                   (regexp . foo)
;;                           ;;"/\\*.*[^ ]\\(\\s-*\\)\\(\\*/\\s-*\\)$")
;;                   ;;"/\\*.*\\(\\s-*\\)\\(\\*/\\s-*\\)$")
;;                   (group . (1 2))
;;                   (modes . align-c++-modes)
;;                   (justify . t)
;;                   (tab-stop . nil)
;;                   (spacing . 0)
;;                   )))

;; (align-current '((c++-comment-end
;;                   (regexp . "\\(\\s-*\\)\\*/")))
;;                '())

;; (align-current '((c++-comment-end
;;                   (regexp . "\\(\\s-*\\)\\*/")))
               ;; '((exc-dq-string
               ;;    (regexp . "\"\\([^\"\n]+\\)\"")
               ;;    (repeat . t)
               ;;    (modes  . align-dq-string-modes))))

;; (align-current '((c++-comment-end
;;                   (regexp . "\\(\\s-*\\)\\*/")))
;;                '((exc-c-comment
;;                   (regexp . "/\\*\\(.+\\)\\*/")
;;                   (repeat . t)
;;                   (modes . align-c++-modes))))
;; (exc-c-comment
;;  (regexp . "/\\*\\(.+\\)\\*/")
;;  (repeat . t)
;;  (modes . align-c++-modes))
;; align-exclude-rules-list

(align-current `((open-comment
                  (regexp . ,(function
                                (lambda (end reverse)
                                  (funcall (if reverse 're-search-backward
                                             're-search-forward)
                                           (concat "[^ \t\n\\\\]"
                                                   (regexp-quote comment-start)
                                                   "\\(.+\\)$") end t))))
                  (modes . align-open-comment-modes)))
               '((exc-dq-string
                 (regexp . "\"\\([^\"\n]+\\)\"")
                 (repeat . t)
                 (modes  . align-dq-string-modes)))
               )
;;"\\(/\\*\\)\\([ ]?[^ ]\\)*\\(\\s-*\\)\\(\\*/\\)\\(\\s-*$\\)"
;; (c-assignment
;;  (regexp   . ,(concat "[^-=!^&*+<>/| \t\n]\\(\\s-*[-=!^&*+<>/|]*\\)"
;;                       "=\\(\\s-*\\)\\([^= \t\n]\\|$\\)"))
;;  (group    . (1 2))
;;  (modes    . align-c++-modes)
;;  (justify  . t)
;;  (tab-stop . nil))
"[^-=!^&*+<>/| \t\n]\\(\\s-*[-=!^&*+<>/|]*\\)=\\(\\s-*\\)\\([^= \t\n]\\|$\\)"

(add-to-list 'align-rules-list
             '(c++-comment-end
               (regexp  . "/\\*.*\\(\\s-*\\)\\(\\*/\\s-*\\)$")
               (spacing . 0)
               (modes   . align-c++-modes))
             t)
;;(assoc 'c++-comment align-rules-list)

;;https://news.ycombinator.com/item?id=333626
;;http://nickgravgaard.com/elastic-tabstops/
(provide 'electric-align)
;;; electric-align.el ends here
