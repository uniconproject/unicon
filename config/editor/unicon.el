;;; unicon.el --- mode for editing Unicon code

;; Copyright (C) 1989, 2001-2017 Free Software Foundation, Inc.

;; Author: Chris Smith     <csmith@convex.com> via icon.el,
;; 	   Robert Parlett  <parlett@dial.pipex.com> 1999
;;         Nolan Clayton   <nclayton@cs.nmsu.edu>   2003
;;         Clinton Jeffery <jeffery@uidaho.edu>     2013
;;         Don Ward        <don@careful.co.uk>      2017
;;
;; Keywords: languages

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A major mode for editing the Unicon programming language.

;;; Code:

(defvar unicon-mode-abbrev-table nil
  "Abbrev table in use in Unicon-mode buffers.")
(define-abbrev-table 'unicon-mode-abbrev-table ())

(defvar unicon-mode-map ()
  "Keymap used in Unicon mode.")
(if unicon-mode-map
    ()
  (let ((map (make-sparse-keymap "Unicon")))
	(setq unicon-mode-map (make-sparse-keymap))
	(define-key unicon-mode-map "\r" 'electric-unicon-terminate-line)
	(define-key unicon-mode-map "{" 'electric-unicon-brace)
	(define-key unicon-mode-map "}" 'electric-unicon-brace)
	(define-key unicon-mode-map "\e\C-h" 'mark-unicon-function)
	(define-key unicon-mode-map "\e\C-a" 'beginning-of-unicon-defun)
	(define-key unicon-mode-map "\e\C-e" 'end-of-unicon-defun)
	(define-key unicon-mode-map "\e\C-q" 'indent-unicon-exp)
	(define-key unicon-mode-map "\177" 'backward-delete-char-untabify)
	(define-key unicon-mode-map "\t" 'unicon-indent-command)
	
	;; Useful time savers by Nolan Clayton
	;; 1. Auto Indent C-m = <return>
	;; [DonW] this should respect the setting of unicon-electric-newline
	;;    (define-key unicon-mode-map "\C-m" 'newline-and-indent)
	(define-key unicon-mode-map "\C-m" 'electric-unicon-terminate-line)
	;; 2. <Control> = C   \e= <Escape>
	(define-key unicon-mode-map "\C-c\C-c" 'compile) 
	(define-key unicon-mode-map "\eg" 'goto-line)
	(define-key unicon-mode-map "\eG" 'what-line)
	;;  (define-key unicon-mode-map "\es" 'copy-region-as-kill)

	;; 3. The following are shortcuts to Dr Meehams Templates
	(define-key unicon-mode-map "\e\C-n" 'unicon-next-template-point)
	(define-key unicon-mode-map "\epm" 'unicon-method-template)
	(define-key unicon-mode-map "\epp" 'unicon-procedure-template)
	(define-key unicon-mode-map "\epc" 'unicon-class-template)
	(define-key unicon-mode-map "\epw" 'unicon-while-template)
	(define-key unicon-mode-map "\epu" 'unicon-until-template)
	(define-key unicon-mode-map "\epr" 'unicon-repeat-template)
	(define-key unicon-mode-map "\epi" 'unicon-if-template)
	(define-key unicon-mode-map "\epe" 'unicon-ifelse-template)
	(define-key unicon-mode-map "\eps" 'unicon-strscan-template)))


(defvar unicon-mode-syntax-table nil
  "Syntax table in use in Unicon-mode buffers.")

(if unicon-mode-syntax-table
    ()
  (setq unicon-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?\\ "\\" unicon-mode-syntax-table)
  (modify-syntax-entry ?# "<" unicon-mode-syntax-table)
  (modify-syntax-entry ?\n ">" unicon-mode-syntax-table)
  (modify-syntax-entry ?$ "." unicon-mode-syntax-table)
  (modify-syntax-entry ?/ "." unicon-mode-syntax-table)
  (modify-syntax-entry ?* "." unicon-mode-syntax-table)
  (modify-syntax-entry ?+ "." unicon-mode-syntax-table)
  (modify-syntax-entry ?- "." unicon-mode-syntax-table)
  (modify-syntax-entry ?= "." unicon-mode-syntax-table)
  (modify-syntax-entry ?% "." unicon-mode-syntax-table)
  (modify-syntax-entry ?< "." unicon-mode-syntax-table)
  (modify-syntax-entry ?> "." unicon-mode-syntax-table)
  (modify-syntax-entry ?& "." unicon-mode-syntax-table)
  (modify-syntax-entry ?| "." unicon-mode-syntax-table)
;; [DonW] Make underscore part of a symbol so M-x imenu plays nicely.
  (modify-syntax-entry ?_ "_" unicon-mode-syntax-table)
  (modify-syntax-entry ?\' "\"" unicon-mode-syntax-table))

(defgroup unicon nil
  "Major mode for editing Unicon code."
  :link '(custom-group-link :tag "Font Lock Faces group" font-lock-faces)
  :group 'languages)

(defcustom unicon-indent-use-only-spaces t
  "Non-nil means use only spaces when indenting; otherwise use spaces and tabs."
  :type 'boolean
  :group 'unicon)

(defcustom unicon-indent-level 3
  "Indentation of Unicon statements with respect to containing block."
  :type 'integer
  :group 'unicon)

(defcustom unicon-class-indent-level 3
  "Indentation of methods within classes."
  :type 'integer
  :group 'unicon)

(defcustom unicon-brace-imaginary-offset 0
  "Imagined indentation of a Unicon open brace that actually follows a statement."
  :type 'integer
  :group 'unicon)

(defcustom unicon-brace-offset 0
  "Extra indentation for braces, compared with other text in same context."
  :type 'integer
  :group 'unicon)

(defcustom unicon-continued-statement-offset 3
  "Extra indent for lines not starting new statements."
  :type 'integer
  :group 'unicon)

(defcustom unicon-continued-brace-offset 0
  "Extra indent for substatements that start with open-braces.
This is in addition to unicon-continued-statement-offset."
  :type 'integer
  :group 'unicon)

(defcustom unicon-align-closing-brace-with-statement t
  "Non-nil means use the Unicon project standard indentation, which aligns the
closing brace with the preceding statement.
nil means align the closing brace with the reserved word (if, while etc.)"
  :type 'boolean
  :group 'unicon)

(defcustom unicon-auto-newline nil
  "*Non-nil means automatically newline before and after braces
inserted in Unicon code."
  :type 'boolean
  :group 'unicon)

(defcustom unicon-electric-newline nil
  "*Non-nil means automatically indent current and new line whenever return is pressed."
  :type 'boolean
  :group 'unicon)

(defcustom unicon-tab-always-indent t
  "Non-nil means TAB in Unicon mode should always reindent the current line,
regardless of where in the line point is when the TAB command is used."
  :type 'boolean
  :group 'unicon)

(defcustom unicon-compile-command "unicon -c -u"
  "Command used to compile unicon code."
  :type 'string
  :group 'unicon)

(defvar unicon-imenu-generic-expression
  '((nil "^[ \t]*\\(procedure\\|method\\|class\\)[ \t]+\\([_[:word:]]+\\)[ \t]*("  2))
  "Imenu expression for Unicon mode.  See `imenu-generic-expression'.")

(defvar unicon-template-ring [] )
(defvar unicon-template-index 0)


(defvar unicon-end-indent-level nil)
(defvar unicon-extra-indent nil)

;; Define a dummy function to break into the debugger at the desired point.
;; Yes, we could use (debug) instead, but that would enter the debugger every
;; time, whereas using this, combined with M-x debug-on-entry, gives more control.
;;
(defun enter-debugger ()
  "Call this function in the code and break into the debugger using M-x debug-on-entry"
  nil)


;;;###autoload
(define-derived-mode unicon-mode prog-mode "Unicon"
  "Major mode for editing Unicon code.
Expression and list commands understand all Unicon brackets.
Tab indents for Unicon code following Icon Project style rules.
Paragraphs are separated by blank lines only.
Delete converts tabs to spaces as it moves back.
M-C-n Causes cursor to move to the next template point.
\\{unicon-mode-map}
Variables controlling indentation style:
 unicon-tab-always-indent
    Non-nil means TAB in Unicon mode should always reindent the current line,
    regardless of where in the line point is when the TAB command is used.
 unicon-auto-newline
    Non-nil means automatically newline before and after braces
    inserted in Unicon code.
 unicon-indent-level
    Indentation of Unicon statements within surrounding block.
    The surrounding block's indentation is the indentation
    of the line on which the open-brace appears.
 unicon-align-closing-brace-with-statement
    Non-nil means use the Unicon project standard indentation, which aligns
    the closing brace with the preceding statement.
    nil means align the closing brace with the reserved word (if, while etc.)
 unicon-continued-statement-offset
    Extra indentation given to a substatement, such as the
    then-clause of an if or body of a while.
 unicon-continued-brace-offset
    Extra indentation given to a brace that starts a substatement.
    This is in addition to `unicon-continued-statement-offset'.
 unicon-brace-offset
    Extra indentation for line if it starts with an open brace.
 unicon-brace-imaginary-offset
    An open brace following other text is treated as if it were
    this far to the right of the start of its line.

Turning on Unicon mode calls the value of the variable `unicon-mode-hook'
with no args, if that value is non-nil."

  :abbrev-table unicon-mode-abbrev-table
  (set (make-local-variable 'paragraph-start) (concat "$\\|" page-delimiter))
  (set (make-local-variable 'paragraph-separate) paragraph-start)
  (set (make-local-variable 'indent-line-function) #'unicon-indent-line)
  (set (make-local-variable 'comment-start) "# ")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'comment-start-skip) "# *")
  (set (make-local-variable 'comment-indent-function) 'unicon-comment-indent)
  (set (make-local-variable 'indent-line-function) 'unicon-indent-line)
   ;; font-lock support
  (set (make-local-variable 'font-lock-defaults)
       '((unicon-font-lock-keywords
          unicon-font-lock-keywords-1 unicon-font-lock-keywords-2)
         nil nil ((?_ . "w")) beginning-of-defun
         ;; Obsoleted by Emacs 19.35 parse-partial-sexp's COMMENTSTOP.
         ;;(font-lock-comment-start-regexp . "#")
         (font-lock-mark-block-function . mark-defun)))
  ;;
  (set (make-local-variable'compile-command) "unicon -c -u")
  ;; imenu support
  (set (make-local-variable 'imenu-generic-expression)
       unicon-imenu-generic-expression)
  ;; hideshow support
  ;; we start from the assertion that `hs-special-modes-alist' is autoloaded.
  (unless (assq 'unicon-mode hs-special-modes-alist)
    (setq hs-special-modes-alist
		  (cons '(unicon-mode  "\\<procedure\\>\\|\\<method\\>" "\\<end\\>" nil
							   unicon-forward-sexp-function)
				hs-special-modes-alist))))


;; This is used by indent-for-comment to decide how much to
;; indent a comment in Unicon code based on its context.
(defun unicon-comment-indent ()
  (if (looking-at "^#")
      0	
    (save-excursion
      (skip-chars-backward " \t")
      (max (if (bolp) 0 (1+ (current-column)))
		   comment-column))))

(defun electric-unicon-brace (arg)
  "Insert character and correct line's indentation."
  (interactive "P")
  (let (insertpos)
    (if (and (not arg)
			 (eolp)
			 (or (save-excursion
				   (skip-chars-backward " \t")
				   (bolp))
				 (if unicon-auto-newline
					 (progn (unicon-indent-line) (newline) t)
				   nil)))
		(progn
		  (insert last-command-event)
		  (unicon-indent-line)
		  (if unicon-auto-newline
			  (progn
				(newline)
				;; (newline) may have done auto-fill
				(setq insertpos (- (point) 2))
				(unicon-indent-line)))
		  (save-excursion
			(if insertpos (goto-char (1+ insertpos)))
			(delete-char -1))))
    (if insertpos
		(save-excursion
		  (goto-char insertpos)
		  (self-insert-command (prefix-numeric-value arg)))
      (self-insert-command (prefix-numeric-value arg)))))

(defun unicon-indent-command (&optional whole-exp)
  (interactive "P")
  "Indent current line as Unicon code, or in some cases insert a tab character.
If `unicon-tab-always-indent' is non-nil (the default), always indent current
line.  Otherwise, indent the current line only if point is at the left margin
or in the line's indentation; otherwise insert a tab.

A numeric argument, regardless of its value, means indent rigidly all the
lines of the expression starting after point so that this line becomes
properly indented.  The relative indentation among the lines of the
expression are preserved."
  (if whole-exp
      ;; If arg, always indent this line as Unicon
      ;; and shift remaining lines of expression the same amount.
      (let ((shift-amt (unicon-indent-line))
			beg end)
		(save-excursion
		  (if unicon-tab-always-indent
			  (beginning-of-line))
		  (setq beg (point))
		  (forward-sexp 1)
		  (setq end (point))
		  (goto-char beg)
		  (forward-line 1)
		  (setq beg (point)))
		(if (> end beg)
			(indent-code-rigidly beg end shift-amt "#")))
    (if (and (not unicon-tab-always-indent)
			 (save-excursion
			   (skip-chars-backward " \t")
			   (not (bolp))))
		(insert-tab)
      (unicon-indent-line))))

(defun unicon-indent-line ()
  "Indent current line as Unicon code.
Return the amount the indentation changed by."
  (let ((indent (calculate-unicon-indent nil))
		beg shift-amt
		(case-fold-search nil)
		(pos (- (point-max) (point))))
    (beginning-of-line)
    (setq beg (point))
    (cond ((eq indent nil)
		   (setq indent (current-indentation)))
		  ((eq indent t)
		   (setq indent (calculate-unicon-indent-within-comment)))
		  ((looking-at "[ \t]*#")
		   ())        ;; rpp - was  (setq indent 0))
		  (t
		   (skip-chars-forward " \t")
		   (if (listp indent) (setq indent (car indent)))
		   (cond ((and (looking-at "else\\b")
					   (not (looking-at "else\\s_")))
				  (setq indent (save-excursion
								 (unicon-backward-to-start-of-if)
								 (current-indentation))))
				 ((and (looking-at "end\\b")
					   (not (looking-at "end\\s_")))
				  (setq indent unicon-end-indent-level))

				 ((= (following-char) ?})
				  (setq indent (- indent unicon-indent-level)))

				 ((= (following-char) ?{)
				  (setq indent (+ indent unicon-brace-offset))))))
    (skip-chars-forward " \t")
    (setq shift-amt (- indent (current-column)))
	;;	(message "setting shift-amt to %s" shift-amt)
    (if (zerop shift-amt)
		(if (> (- (point-max) pos) (point))
			(goto-char (- (point-max) pos)))
      (delete-region beg (point))
      (indent-to-spaces indent)
      ;; If initial point was within line's indentation,
      ;; position after the indentation.  Else stay at same point in text.
      (if (> (- (point-max) pos) (point))
		  (goto-char (- (point-max) pos))))
    shift-amt))

; calculate-unicon-indent, then bump up by unicon-indent-level if line started with }
(defun calculate-unicon-indent (&optional parse-start)
  (let ((base-indent (indent-ignoring-preprocessor-lines parse-start)))
	(if unicon-align-closing-brace-with-statement
		(save-excursion
		  (beginning-of-line)
		  (skip-chars-forward " \t")
		  (if ( /= (char-after) ?} )
			  base-indent
			(+ base-indent unicon-indent-level)
			)
		  )
	  base-indent)))

(defun indent-ignoring-preprocessor-lines (&optional parse-start)
  (save-excursion
	(beginning-of-line)
	(skip-chars-forward " \t")
	(if (eq (char-after) ?$)
		nil
	  (real-calculate-unicon-indent parse-start)
	  )))

(defun real-calculate-unicon-indent (&optional parse-start)
  "Return appropriate indentation for current line as Unicon code.
In usual case returns an integer: the column to indent to.
Returns nil if line starts inside a string, t if in a comment."
  (save-excursion
    (beginning-of-line)
    (let ((indent-point (point))
		  (case-fold-search nil)
		  (line-no (count-lines 1 (point)))
		  containing-sexp-line
		  state
		  containing-sexp
		  toplevel)
      (if parse-start
		  (goto-char parse-start)
		(setq toplevel (beginning-of-unicon-defun)))
      (while (< (point) indent-point)
		(setq parse-start (point))
		(setq state (parse-partial-sexp (point) indent-point 0))
		(setq containing-sexp (car (cdr state))))
      (cond ((or (nth 3 state) (nth 4 state))
			 ;; return nil or t if should not change this line
			 (nth 4 state))
			((and containing-sexp
				  (/= (char-after containing-sexp) ?{))
			 ;; line is expression, not statement:
			 (setq containing-sexp-line (count-lines 1 containing-sexp))
			 (if (= line-no containing-sexp-line)
				 (goto-char (1+ containing-sexp))

			   (progn
				 (forward-line -1)
				 (beginning-of-line)
				 (skip-chars-forward " \t")
                 )
			   )
			 (current-column)
			 )
			(t
			 (if toplevel
				 ;; Outside any procedures.
				 (progn (unicon-backward-to-noncomment (point-min))
						(if (unicon-is-continuation-line)
							unicon-continued-statement-offset
						  unicon-extra-indent))
			   ;; Statement level.
			   (if (null containing-sexp)
				   (progn (beginning-of-unicon-defun)
						  (setq containing-sexp (point))))
			   (goto-char indent-point)
			   ;; Is it a continuation or a new statement?
			   ;; Find previous non-comment character.
			   (unicon-backward-to-noncomment containing-sexp)
			   ;; Now we get the answer.
			   (if (unicon-is-continuation-line)
				   ;; This line is continuation of preceding line's statement;
				   ;; indent  unicon-continued-statement-offset  more than the
				   ;; first line of the statement.
				   (progn
					 (unicon-backward-to-start-of-continued-exp
					  containing-sexp)
					 (+ unicon-continued-statement-offset (current-column)
						(if (save-excursion (goto-char indent-point)
											(skip-chars-forward " \t")
											(eq (following-char) ?{))
							unicon-continued-brace-offset 0)))
				 ;; This line starts a new statement.
				 ;; Position following last unclosed open.
				 (goto-char containing-sexp)
				 ;; Is line first statement after an open-brace?
				 (or
				  ;; If no, find that first statement and indent like it.
				  (save-excursion
					(cond
					 ((looking-at "procedure\\s \\|method\\s ")
					  (forward-sexp 3))
					 ((looking-at "initially\\s *\\s(")
					  (forward-sexp 2))
					 ((looking-at "initially")
					  (end-of-line))
					 (t  (forward-char 1))
					 )

					(while (progn (skip-chars-forward " \t\n")
								  (looking-at "[#$]"))
					  ;; Skip over comments and preprocessor statements following openbrace.
					  (forward-line 1))
					;; The first following code counts
					;; if it is before the line we want to indent.
					(and (< (point) indent-point)
						 (current-column)))
				  ;; If no previous statement,
				  ;; indent it relative to line brace is on.
				  ;; For open brace in column zero, don't let statement
				  ;; start there too.  If unicon-indent-level is zero, use
				  ;; unicon-brace-offset + unicon-continued-statement-offset
				  ;; instead.
				  ;; For open-braces not the first thing in a line,
				  ;; add in unicon-brace-imaginary-offset.
				  (+ (if (and (bolp) (zerop unicon-indent-level))
						 (+ unicon-brace-offset
							unicon-continued-statement-offset)
					   unicon-indent-level)
					 ;; Move back over whitespace before the openbrace.
					 ;; If openbrace is not first nonwhite thing on the line,
					 ;; add the unicon-brace-imaginary-offset.
					 (progn (skip-chars-backward " \t")
							(if (bolp) 0 unicon-brace-imaginary-offset))
					 ;; Get initial indentation of the line we are on.
					 (current-indentation))))))))))

;; List of words to check for as the last thing on a line.
;; If cdr is t, next line is a continuation of the same statement,
;; if cdr is nil, next line starts a new (possibly indented) statement.

(defconst unicon-resword-alist
  '(("by" . t) ("case" . t) ("create") ("do") ("dynamic" . t) ("else")
    ("every" . t) ("if" . t) ("global" . t) ("initial" . t)
    ("link" . t) ("local" . t) ("of") ("record" . t) ("repeat" . t)
    ("static" . t) ("then") ("to" . t) ("until" . t) ("while" . t)
    ("thread") ("critical" . t)
	;; [DonW] a "responsible adult" should check these additions
	("break" . t) ("class" . t) ("import" . t)
	("initially" . t) ("invocable" . t) ("method" . t)
	("next") ("not" . t) ("package" . t) ("procedure" . t)
	("suspend" . t )
	))

(defun unicon-is-continuation-line ()
  (let* ((ch (preceding-char))
		 (ch-syntax (char-syntax ch)))
    (if (eq ch-syntax ?w)
		(assoc (buffer-substring
				(progn (forward-word -1) (point))
				(progn (forward-word 1) (point)))
			   unicon-resword-alist)
	  (not (memq ch '(0 ?\; ?\} ?\{ ?\) ?\] ?\" ?\' ?\n)))
	  )
	)
  )

;; This function also skips over preprocessor lines
(defun unicon-backward-to-noncomment (lim)
  (let (opoint stop)
    (while (and (not stop) (> (point) 1))
      (skip-chars-backward " \t\n\f" lim)
      (setq opoint (point))
      (beginning-of-line)
	  (if (not (looking-at "^\\s *[$]"))
		  (progn
      ;;; rpp
      ;;; fixed bug here, changed 5 to 4 (inside comment)
			(if (and (nth 4 (parse-partial-sexp (point) opoint))
					 (< lim (point)))
				(search-backward "#")
			  (setq stop t))
			)
		)
	  )
	)
  )

(defun unicon-backward-to-start-of-continued-exp (lim)
  (if (memq (preceding-char) '(?\) ?\]))
      (forward-sexp -1))
  (beginning-of-line)
  (skip-chars-forward " \t")
  (cond
   ;;   ((<= (point) lim) (goto-char (+ unicon-indent-level lim)))
   ((<= (point) lim) (goto-char (1+ lim)))
   ((not (unicon-is-continued-line)) 0)
   ((and (eq (char-syntax (following-char)) ?w)
		 (cdr
		  (assoc (buffer-substring (point)
								   (save-excursion (forward-word 1) (point)))
				 unicon-resword-alist))) 0)
   (t (end-of-line 0) (unicon-backward-to-start-of-continued-exp lim))))

(defun unicon-is-continued-line ()
  (save-excursion
    (end-of-line 0)
    (unicon-is-continuation-line)))

(defun unicon-backward-to-start-of-if (&optional limit)
  "Move to the start of the last \"unbalanced\" if."
  (or limit (setq limit (save-excursion (beginning-of-unicon-defun) (point))))
  (let ((if-level 1)
		(case-fold-search nil))
    (while (not (zerop if-level))
      (backward-sexp 1)
      (cond ((and (looking-at "else\\b")
				  (not (looking-at "else\\s_")))
			 (setq if-level (1+ if-level)))
			((and (looking-at "if\\b")
				  (not (looking-at "if\\s_")))
			 (setq if-level (1- if-level)))
			((< (point) limit)
			 (setq if-level 0)
			 (goto-char limit))))))

(defun mark-unicon-function ()
  "Put mark at end of Unicon function, point at beginning."
  (interactive)
  (push-mark (point))
  (end-of-unicon-defun)
  (push-mark (point))
  (beginning-of-line 0)
  (beginning-of-unicon-defun))


(defun beginning-of-unicon-defun ()
  "Go to the start of the enclosing procedure; return t if at top level."
  (interactive)
  (cond
   ((re-search-backward "^\\s *procedure\\s \\|^\\s *initially\\s *$\\|^\\s *initially\\s *\\s(.*$\\|^\\s *method\\s \\|^class\\s \\|^\\s *end\\s *$" (point-min) 'move)
	(skip-chars-forward " \t")
	(cond
	 ((looking-at "c")
	  (setq unicon-extra-indent unicon-class-indent-level)
	  (setq unicon-end-indent-level 0)
	  t
	  )
	 ((looking-at "e")
	  (setq unicon-extra-indent (current-column))
	  (setq unicon-end-indent-level 0)
	  t
	  )
	 ((looking-at "i")
	  (setq unicon-end-indent-level 0)
	  nil
	  )
	 (t
	  (setq unicon-extra-indent (current-column))
	  (setq unicon-end-indent-level (current-column))
	  nil
	  )
	 )
	)
   (t
	(setq unicon-extra-indent 0)
	t
	)
   )
  )

(defun end-of-unicon-defun ()
  (interactive)
  (if (not (bobp)) (forward-char -1))
  (re-search-forward "^\\s *end\\s *$" (point-max) 'move)
  (forward-word -1)
  (forward-line 1))

(defun indent-unicon-exp ()
  "Indent each line of the Unicon grouping following point."
  (interactive)
  (let ((indent-stack (list nil))
		(contain-stack (list (point)))
		(case-fold-search nil)
		restart outer-loop-done inner-loop-done state ostate
		this-indent last-depth last-sexp
		at-else at-brace at-do
		(opoint (point))
		(next-depth 0))
    (save-excursion
      (forward-sexp 1))
    (save-excursion
      (setq outer-loop-done nil)
      (while (and (not (eobp)) (not outer-loop-done))
		(setq last-depth next-depth)
		;; Compute how depth changes over this line
		;; plus enough other lines to get to one that
		;; does not end inside a comment or string.
		;; Meanwhile, do appropriate indentation on comment lines.
		(setq inner-loop-done nil)
		(while (and (not inner-loop-done)
					(not (and (eobp) (setq outer-loop-done t))))
		  (setq ostate state)
		  (setq state (parse-partial-sexp (point) (progn (end-of-line) (point))
										  nil nil state))
		  (setq next-depth (car state))
		  (if (and (car (cdr (cdr state)))
				   (>= (car (cdr (cdr state))) 0))
			  (setq last-sexp (car (cdr (cdr state)))))
		  (if (or (nth 4 ostate))
			  (unicon-indent-line))
		  (if (or (nth 3 state))
			  (forward-line 1)
			(setq inner-loop-done t)))
		(if (<= next-depth 0)
			(setq outer-loop-done t))
		(if outer-loop-done
			nil
		  (if (/= last-depth next-depth)
			  (setq last-sexp nil))
		  (while (> last-depth next-depth)
			(setq indent-stack (cdr indent-stack)
				  contain-stack (cdr contain-stack)
				  last-depth (1- last-depth)))
		  (while (< last-depth next-depth)
			(setq indent-stack (cons nil indent-stack)
				  contain-stack (cons nil contain-stack)
				  last-depth (1+ last-depth)))
		  (if (null (car contain-stack))
			  (setcar contain-stack (or (car (cdr state))
										(save-excursion (forward-sexp -1)
														(point)))))
		  (forward-line 1)
		  (skip-chars-forward " \t")
		  (if (eolp)
			  nil
			(if (and (car indent-stack)
					 (>= (car indent-stack) 0))
				;; Line is on an existing nesting level.
				;; Lines inside parens are handled specially.
				(if (/= (char-after (car contain-stack)) ?{)
					(setq this-indent (car indent-stack))
				  ;; Line is at statement level.
				  ;; Is it a new statement?  Is it an else?
				  ;; Find last non-comment character before this line
				  (save-excursion
					(setq at-else (looking-at "else\\W"))
					(setq at-brace (= (following-char) ?{))
					(unicon-backward-to-noncomment opoint)
					(if (unicon-is-continuation-line)
						;; Preceding line did not end in comma or semi;
						;; indent this line  unicon-continued-statement-offset
						;; more than previous.
						(progn
						  (unicon-backward-to-start-of-continued-exp (car contain-stack))
						  (setq this-indent
								(+ unicon-continued-statement-offset (current-column)
								   (if at-brace unicon-continued-brace-offset 0))))
					  ;; Preceding line ended in comma or semi;
					  ;; use the standard indent for this level.
					  (if at-else
						  (progn (unicon-backward-to-start-of-if opoint)
								 (setq this-indent (current-indentation)))
						(setq this-indent (car indent-stack))))))
			  ;; Just started a new nesting level.
			  ;; Compute the standard indent for this level.
			  (let ((val (calculate-unicon-indent
						  (if (car indent-stack)
							  (- (car indent-stack))))))
				(setcar indent-stack
						(setq this-indent val))))
			;; Adjust line indentation according to its contents
			(if (or (= (following-char) ?})
					(and (looking-at "end\\b")
						 (not (looking-at "end\\s_")))
					)
				(setq this-indent (- this-indent unicon-indent-level)))
			(if (= (following-char) ?{)
				(setq this-indent (+ this-indent unicon-brace-offset)))
			;; Put chosen indentation into effect.
			(or (= (current-column) this-indent)
				(progn
				  (delete-region (point) (progn (beginning-of-line) (point)))
				  (indent-to-spaces this-indent)))
			;; Indent any comment following the text.
			(or (looking-at comment-start-skip)
				(if (re-search-forward comment-start-skip (save-excursion (end-of-line) (point)) t)
					(progn (indent-for-comment) (beginning-of-line))))))))))


(defun indent-to-spaces (n)
  (if unicon-indent-use-only-spaces
	  (while (< (current-column) n)
		(insert " ")
		)

	(indent-to n)
	)
  )

;; [DonW] redundant now we have a customization buffer, but retained in case
;; someone wants to bind it to a key or use it in their .emacs file.
(defun toggle-unicon-electric-newline ()
  "Toggle value of unicon-electric-newline"
  (interactive)
  (setq unicon-electric-newline (not unicon-electric-newline))
  (message "unicon-electric-newline is %s" unicon-electric-newline)
  )

(defun electric-unicon-terminate-line ()
  "Terminate line and indent next line."
  (interactive)
  (if unicon-electric-newline
      (progn
		(save-excursion
		  (unicon-indent-line)
		  )
		(newline)
		;; Indent next line
		(unicon-indent-line)
		)
	(newline)
	)
  )


(defconst unicon-font-lock-keywords-1
  (eval-when-compile
    (list
     ;; Fontify procedure name definitions (and class and method.
	 '("^[ \t]*\\(procedure\\|class\\|method\\)\\>[ \t]*\\(\\sw+\\)?"
	   
       (1 font-lock-builtin-face) (2 font-lock-function-name-face nil t))))
  "Subdued level highlighting for Unicon mode.")

(defconst unicon-font-lock-keywords-2
  (append 
   unicon-font-lock-keywords-1
   (eval-when-compile
     (list
      (cons      ;; $define $ifdef $ifndef $undef
       (concat "^\\s *" 
			   (regexp-opt'("$define" "$ifdef" "$ifndef" "$undef") t)
			   "\\>[ \t]*\\([^ \t\n]+\\)?")
	   '((1 font-lock-variable-name-face) 
		 (2 font-lock-variable-name-face nil t)))
      (cons      ;; $dump $endif $else $include $line
       (concat 
		"^\\s *" (regexp-opt'("$dump" "$endif" "$else" "$include" "$line") t) "\\>" )
       'font-lock-variable-name-face)
      (cons      ;; $warning $error
       (concat (regexp-opt '("$warning" "$error") t)
			   "\\>[ \t]*\\(.+\\)?")
       '((1 font-lock-warning-face) (2 font-lock-warning-face nil t)))
      ;; Fontify all Icon/Unicon keywords.  Place these before other
      ;; shorter patterns that match portions such as cset
      (cons 
       (regexp-opt 
		'("&allocated" "&ascii" "&clock" "&col" "&collections" "&column" 
		  "&control" "&cset" "&current" "&date" "&dateline" "&digits" "&dump"
		  "&e" "&errno" "&error" "&errornumber" "&errortext" "&errorvalue" "&errout"
		  "&eventcode" "&eventsource" "&eventvalue" "&fail" "&features" 
		  "&file" "&host" "&input" "&interval" "&lcase" "&ldrag" "&letters" 
		  "&level" "&line" "&lpress" "&lrelease" "&main" "&mdrag" "&meta" 
		  "&mpress" "&mrelease" "&now" "&null" "&output" "&phi" "&pi" "&pos" 
		  "&progname" "&random" "&rdrag" "&regions" "&resize" "&row" 
		  "&rpress" "&rrelease" "&shift" "&source" "&storage" "&subject" 
		  "&time" "&trace" "&ucase" "&version" "&window" "&x" "&y" "&pick") t)
       'font-lock-constant-face)
      ;; Fontify all type specifiers.
      (cons
       (regexp-opt  '("null" "string" "co-expression" "table" "integer"
					  "cset"  "set" "real" "file" "list") 'words)
       'font-lock-type-face)
      ;; Fontify reserved words.
      ;;
      (cons 
       (regexp-opt 
		'("break" "do" "next" "repeat" "to" "by" "else" "if" "not" "return" 
		  "until" "case" "of" "while" "create" "every" "suspend" "default" 
		  "critical" "invocable"
		  "fail" "record" "then" "thread" "critical") 'words)
       'font-lock-keyword-face)
      ;; "end" "initial" 
      (cons (regexp-opt '("end" "initial" "local" "static" "global" "initially") 'words)
			'font-lock-builtin-face)
      (cons      ;; package declarations plus import and link files
	   ;;       (concat 
	   "^[ \t]*\\(link\\|package\\|import\\)\\>[ \t]*\\(\\sw+\\)?"
	   ;;	(regexp-opt '("global" "link" "local" "static") t)
	   ;;	"\\(\\sw+\\>\\)*")
       '((1 font-lock-builtin-face)
		 (font-lock-match-c-style-declaration-item-and-skip-to-next
		  (goto-char (or (match-beginning 2) (match-end 1))) nil
		  (1 (if (match-beginning 2)
				 font-lock-function-name-face
			   font-lock-variable-name-face)))))
	  ))))

(defvar unicon-font-lock-keywords unicon-font-lock-keywords-1
  "Default expressions to highlight in `unicon-mode'.")


;**********************************************************************************
; This defines the Unicon template functions
;**********************************************************************************
(defun unicon-push-template-mark ( )
  (setq unicon-template-ring 
        (vconcat (vector (point-marker)) unicon-template-ring)))
(defun unicon-next-template-point ( )
  "Go to next template point"
  (interactive)
  (if (equal unicon-template-ring []) 
      (error "Unicon Error: No template inserted.")
    (let ((index unicon-template-index) (next-point))
      (setq next-point
            (aref unicon-template-ring (1- (- (length unicon-template-ring) index ))))
      (setq unicon-template-index 
            (mod (+ unicon-template-index 1) (length unicon-template-ring)))
      (goto-char next-point ))))

(defun unicon-method-template ( )
  "Insert a procedure template and set associated marks."
  (interactive)
  (setq unicon-template-ring [] )
  (setq unicon-template-index 0)
  (insert "\n")
  (unicon-indent-command)
  (insert "method ")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert " ( ")
  (unicon-push-template-mark)
  (insert " )\n" )
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert "\nend")
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (push-mark)
  (unicon-push-template-mark)
  (unicon-next-template-point)
  )

(defun unicon-procedure-template ( )
  "Insert a procedure template and set associated marks."
  (interactive)
  (setq unicon-template-ring [] )
  (setq unicon-template-index 0)
  (insert "\n")
  (unicon-indent-command)
  (insert "procedure ")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert " ( ")
  (unicon-push-template-mark)
  (insert " )\nlocal " )
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert "\n\t" )
  (unicon-push-template-mark)
  (insert "\nend\n")
  (push-mark)
  (unicon-push-template-mark)
  (unicon-next-template-point)
  )

(defun unicon-class-template ( )
  "Insert a procedure template and set associated marks."
  (interactive)
  (setq unicon-template-ring [] )
  (setq unicon-template-index 0)
  (insert "\n")
  (unicon-indent-command)
  (insert "class ")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert " ( ")
  (unicon-push-template-mark)
  (insert " )\n\t" )
  (unicon-push-template-mark)
  (insert "\n\tinitially( ")
  (unicon-push-template-mark)
  (insert " )\n\t" )
  (unicon-push-template-mark)
  (insert "\nend\n")
  (push-mark)
  (unicon-push-template-mark)
  (unicon-next-template-point)
  )  

(defun unicon-while-template ( ) 
  "Insert a while loop template and set associated marks."
  (interactive)
  (setq unicon-template-ring [] )
  (setq unicon-template-index 0)  
  (insert "\n" )
  (unicon-indent-command)
  (insert "while ")
  (unicon-push-template-mark)
  (insert " do {\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert "\n}")
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (push-mark)
  (unicon-next-template-point)
  )
(defun unicon-until-template ( ) 
  "Insert a while loop template and set associated marks."
  (interactive)
  (setq unicon-template-ring [] )
  (setq unicon-template-index 0)  
  (insert "\n" )
  (unicon-indent-command)
  (insert "until ")
  (unicon-push-template-mark)
  (insert " do {\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert "\n}")
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (push-mark)
  (unicon-next-template-point)
  )

(defun unicon-repeat-template ( ) 
  "Insert a while loop template and set associated marks."
  (interactive)
  (setq unicon-template-ring [] )
  (setq unicon-template-index 0)  
  (insert "\n" )
  (unicon-indent-command)
  (insert "repeat {\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert "\n}")
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (push-mark)
  (unicon-next-template-point)
  )
(defun unicon-if-template ( )
  "Insert an if statement template and set associated marks."
  (interactive)
  (setq unicon-template-ring [] )
  (setq unicon-template-index 0)  
  (insert "\n" )
  (unicon-indent-command)
  (insert "if " )
  (unicon-push-template-mark)
  (insert " then {")
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert "\n}")
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (push-mark)
  (unicon-next-template-point) 
  )
(defun unicon-ifelse-template ( )
  "Insert an if statement template and set associated marks."
  (interactive)
  (setq unicon-template-ring [] )
  (setq unicon-template-index 0)  
  (insert "\n" )
  (unicon-indent-command)
  (insert "if " )
  (unicon-push-template-mark)
  (insert " then {")
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert "\n}")
  (unicon-indent-command)
  (insert "\n else {")
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert "\n}")
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (push-mark)
  (unicon-next-template-point) 
  )

(defun unicon-strscan-template ( )
  "Insert a string scanning expression template and set associated marks."
  (interactive)
  (setq unicon-template-ring [] )
  (setq unicon-template-index 0)  
  (insert "\n ")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert " ? {" )
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (insert "\n}" )
  (unicon-indent-command)
  (insert "\n")
  (unicon-indent-command)
  (unicon-push-template-mark)
  (push-mark)
  (unicon-next-template-point) 
  )

;;;used by hs-minor-mode
(defun unicon-forward-sexp-function (arg)
  (if (< arg 0)
      (beginning-of-unicon-defun)
    (end-of-unicon-defun)
    (forward-char -1)))

(defun calculate-unicon-indent-within-comment ()
  "Return the indentation amount for line, assuming that
the current line is to be regarded as part of a block comment."
  (let (end star-start)
    (save-excursion
      (beginning-of-line)
      (skip-chars-forward " \t")
      (setq star-start (= (following-char) ?\#))
      (skip-chars-backward " \t\n")
      (setq end (point))
      (beginning-of-line)
      (skip-chars-forward " \t")
      (and (re-search-forward "#[ \t]*" end t)
		   star-start
		   (goto-char (1+ (match-beginning 0))))
      (current-column))))

(provide 'unicon)

;;; unicon.el ends here
