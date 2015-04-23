;;; electric-align-test.el --- test for electric-align

;; -------------------------------------------------------------------
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
;; -------------------------------------------------------------------

;;;
(require 'electric-align)
(require 'ert)
(require 'ert-x)

(ert-deftest ea-test-c-comment-end ()
  (ert-with-test-buffer (:name "electric-align")
    (c-mode)
    (insert "
/**/
/* */
/*z*/
/*  */
/*z */
/* z*/
")
    (backward-char)
    (align-current)
    (should
     (equal
      (substring-no-properties (buffer-string))
      "
/*   */
/*   */
/*z  */
/*   */
/*z  */
/* z */
"))))

;; for demo (c-set-style "k&r")
;; #include <stdio.h>
;; int someDemoCode(int fred,
;;                      int wilma,
;;                      int b)
;; {
;; x();                          /* try making   */
;; print("hello again!\n");      /* this comment */
;; makeThisFunction();           /* a bit longer */
;; for(i = start;i < end; ++i)
;;       {
;;       if(isPrime(i))
;;       {
;;       ++numPrimes;
;;       }
;;       }
;;       }

(mapc
 'kill-buffer
 (remove-if-not
  (lambda (buffer-name)
    (when (string-match "*Test buffer" buffer-name) buffer-name))
  (mapcar 'buffer-name (buffer-list))))

(ert-run-tests-interactively t)
