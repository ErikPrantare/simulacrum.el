;;; emacslisten.el --- Framework for voice driven computing  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Erik Präntare

;; Author: Erik Präntare <erik@adjoint-modality2>
;; Keywords: convenience
;; Created: 19 Aug 2025

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU Affero General Public License
;; as published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU Affero General Public
;; License along with this program.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Core form evaluator for EmacsListen.

;;; Code:

(defvar emacslisten-this-form nil
  "The form currently evaluated by EmacsListen.

This variable may be changed by the evaluated form.  Whatever gets
put in this variable will be in `emacslisten-last-form' during the
form next evaluated.")

(defvar emacslisten-last-form nil
  "The form last evaluated by EmacsListen.

This will be whatever `emacslisten-this-form' was at the end of the
previously evaluated form.")

(defun emacslisten--evaluate-form (form)
  "Evaluate FORM.

Before FORM is evaluated, `emacslisten-this-form' is set to FORM.
After FORM has been evaluated, `emacslisten-last-form' is set to
`emacslisten-this-form'."
  (setq emacslisten-this-form form)
  (eval form)
  (setq emacslisten-last-form emacslisten-this-form))

(defmacro emacslisten-evaluate (form)
  "Evaluate FORM as a voice driven command.

This adds a new event to `unread-command-events' of the form
\(emacslisten--remote-form . FORM\).  By defining a key binding for
\"<emacslisten--remote-form>\", custom form handlers can be added for
voice commands.  These handlers should inspect `this-command-keys' to
get FORM."
  `(let ((form ',form))
     (setq unread-command-events
           (append unread-command-events
                   (list (cons 'emacslisten--remote-form form))))))

(defun emacslisten--handle-remote-form ()
  "Default form handler.

See `emacslisten-evaluate' for more information concerning form
handlers."
  (interactive)
  (let ((form (cdr (elt (this-command-keys) 0))))
    (emacslisten--evaluate-form form)))

(keymap-global-set "<emacslisten--remote-form>" #'emacslisten--handle-remote-form)

(provide 'emacslisten)
;;; emacslisten.el ends here
