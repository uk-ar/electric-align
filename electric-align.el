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
  (undo-boundary)
  (align-current)
  ;;todo find & save keymap
  (call-interactively 'backward-delete-char-untabify)
  )

(defun electric-align-electric-deletechar (N)
  (interactive "P")
  (undo-boundary)
  (align-current)
  ;;todo find & save keymap
  (call-interactively 'delete-char)
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
        (add-hook 'post-self-insert-hook #'electric-align-electric)
        )
    ;;(remove-hook 'after-change-functions #'electric-align-electric t)
    (remove-hook 'post-self-insert-hook #'electric-align-electric t)
    ))

(define-minor-mode electric-align-mode
  "Toggle electric align . "
  :lighter " EA"
  :group 'electric-align
  (if electric-align-mode
      (progn
        ;;(add-hook 'after-change-functions #'electric-align-electric nil t)
        (add-hook 'post-self-insert-hook #'electric-align-electric)
        )
    ;;(remove-hook 'after-change-functions #'electric-align-electric t)
    (remove-hook 'post-self-insert-hook #'electric-align-electric t)
    ))
;; (align-current '((c++-comment-end
;;                   (regexp . "\\(?:/\\*.*\\)\\( *\\)*\\*/")
;;                   (modes . align-c++-modes)
;;                   )))

;; bug in delete-forward
(add-to-list 'align-rules-list
             '(c++-comment-end
               (regexp . "\\(?:/\\*.*\\)\\( *\\)*\\*/\\s-*$")
               ;;(regexp . "\\(?:/\\*.*\\)\\( *\\)*\\*/")
               (modes . align-c++-modes))
             t)
