


;; Contents
;; =====================================================================
;; 0. Overview and license 
;; 1. Init
;; 2. Basic mode settings
;; 3. Faces
;; 4. Syntax highlighting
;; 5. Indentation
;; 6. Finis



;; 0. Overview and license
;; =====================================================================
;;
;; This is an emacs major mode for the Boo programming language. 
;; For more info on boo, see http://boo.codehaus.org.
;; 
;; "Boo is an object oriented statically typed language for .NET and Mono
;;  with a python-inspired syntax and a special focus on metaprogramming
;;  through language and compiler extensibility."
;; 
;; For this reason, this mode derives from python.el (python.el "Gallina").
;; It is doubtful any other python mode will work with boo-mode due to the 
;; use of and dependence on the indentation features of python.el.
;;  
;; Copyright (C) 2014 Patrick Sullivan
;; URL: https://github.com/algoterranean/boo-mode
;;
;; This file is distributed under the terms of the GNU General Public License.
;; See https://www.gnu.org/copyleft/gpl.html for more information.
;;
;;
;; INSTALLATION:
;;
;; Put this file in your load path and put (require 'boo-mode) in your .emacs.
;; You may, of course, hook into the boo-mode hook if you wish, and you will
;; want to define the autoload stuff. For example:
;;
;; (setq boo-custom-macros '("client" "server"))
;; (require 'boo-mode)
;; (setq auto-mode-alist (append '(("\\.boo$" . boo-mode)) auto-mode-alist)) 
;;
;; 
;; CUSTOMIZATION:
;;
;; - The faces are exposed if you wish to customize them.
;; 
;; - You can define your own keywords that need syntax highlighting and 
;;   indentation (read: your custom macros!). HOWEVER you will need to 
;;   define the boo-custom-macro variable BEFORE you load this mode. 
;;   This is due to some rather hackish macro expansion stuff that 
;;   has been derived from python.el. 
;;       
;;
;; TODO: 
;; 
;; - Improve and finalize syntax highlighting. 
;;   - In particular, Attributes.
;; - Add doc string support.
;; - Add keymap support. 
;; - Interpreter support.
;; - Break out font lock keywords into separate categories. 
;; - Debugging support?
;; - Unity-specific support? 
;;
;;
;; HISTORY AND VERSION NOTES:
;;
;; v0.1, Feb 2014: Initial release, so, yeah. Don't expect shit to work much.
;;
;;
;;
;;



;; 1. Init
;; ======================================================================

;; requires python.el
;; see http://www.emacswiki.org/emacs/ProgrammingWithPythonDotElGallina
;; or http://lists.gnu.org/archive/html/emacs-devel/2012-04/msg00583.html
(require 'python)


(defconst boo-mode-version "0.1"
  "`boo-mode' version number.")

(defgroup boo nil
  "Support for the Boo programming language (boo.codehaus.org)"
  :group 'languages
  :prefix "boo-")

(defcustom boo-mode-hook nil
  "list of functions to be executed on entry to pyxl-mode."
  :type 'hook
  :group 'boo)


;; 2. Basic mode settings
;; ======================================================================

;; (defvar boo-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map "\C-c\C-c" 'boo-compile)
;;     map)
;;     "Keymap used in boo mode")



;; 3. Faces
;; ======================================================================


(defface boo-builtin-face 
  '((t (:inherit font-lock-builtin-face)))
  "Face for builtins like TypeError, object, open, and exec." 
  :group 'boo)
(defvar boo-builtin-face 'boo-builtin-face)

(defface boo-exception-face 
  '((t (:inherit font-lock-builtin-face)))
  "Exceptions." 
  :group 'boo)
(defvar boo-exception-face 'boo-exception-face)

(defface boo-decorators-face 
  '((t (:inherit font-lock-keyword-face)))
  "Face method decorators." 
  :group 'boo)
(defvar boo-decorators-face 'boo-decorators-face)

(defface boo-type-face 
  '((t (:inherit font-lock-type-face)))
  "Types" 
  :group 'boo)
(defvar boo-type-face 'boo-type-face)

(defface boo-comment-face 
  '((t (:inherit font-lock-comment-face)))
  "Comments" 
  :group 'boo)
(defvar boo-comment-face 'boo-comment-face)

;; (defface boo-pseudo-keyword-face 
;;   '((t (:inherit font-lock-pseudo-keyword-face)))
;;   "Face for builtins like TypeError, object, open, and exec." 
;;   :group 'boo)
;; (defvar boo-pseudo-keyword-face 'boo-pseudo-keyword-face)

(defface boo-macro-face
  '((t (:inherit font-lock-builtin-face)))
  "Face for builtins like TypeError, object, open, and exec." 
  :group 'boo)
(defvar boo-macro-face 'boo-macro-face)

(defface boo-native-type-face
  '((t (:inherit font-lock-variable-name-face)))
  "Face for builtins like TypeError, object, open, and exec." 
  :group 'boo)
(defvar boo-native-type-face 'boo-native-type-face)


(defface boo-function-face 
  '((t (:inherit font-lock-function-name-face)))
  "Face for builtins like TypeError, object, open, and exec." 
  :group 'boo)
(defvar boo-function-face 'boo-function-face)

(defface boo-variable-face 
  '((t (:inherit font-lock-variable-name-face)))
  "Face for builtins like TypeError, object, open, and exec." 
  :group 'boo)
(defvar boo-variable-face 'boo-variable-face)

;; (defface boo-warning-face 
;;   '((t (:inherit font-lock-warning-face)))
;;   "Face for builtins like TypeError, object, open, and exec." 
;;   :group 'boo)
;; (defvar boo-warning-face 'boo-warning-face)

(defface boo-operator-face
  '((t (:inherit font-lock-warning-face)))
  "Face for builtins like TypeError, object, open, and exec." 
  :group 'boo)
(defvar boo-operator-face 'boo-operator-face)





;; 4. Syntax highlighting
;; ======================================================================

(defvar boo-valid-name-regexp "[A-Za-z_]+[.A-Za-z0-9_]*")

;; (defvar boo-operators '("+" "-" "/" "&" "^" "~" "|" "*" "<" ">"
;; 			"=" "%" "**" "//" "<<" ">>" "<=" "!="
;; 			"==" ">=" "is" "not" "in" "isa"))

(defvar boo-operator-regexp
  "\\([=\\+-]\\|[/]\\|[&]\\|[\\^]\\|[~|]\\|[\\*]\\|[<>]+\\|[%]\\|[!]\\|\\(\\<is[a]*[ ]+\\|\\<not[ ]+\\|\\<in[ ]+\\)\\)"
  )



(defvar boo-macros
  '("assert" "using" "lock" "debug" "print"))

(defvar boo-custom-macros '()
  "A list of keywords for custom macros that require syntax highlighting and indentation. 
This needs to be defined before the mode has started due to the macro expansion involved.")




(defvar boo-font-lock-keywords
  (let ((kw1 (mapconcat 'identity  ;; KEYWORDS
			'( ;; declarations
			  "interface" "struct" "enum" "class" "def" "macro"
			  ;; namespaces
			  "import" "from" "namespace"
			  ;; class modifiers
			  "public" "protected" "internal" "private" "abstract"
			  "final" "static" "override" "partial" "virtual"
			  ;; references and types
			  "cast" "ref" "of" "as" "duck"
			  ;; delegates
			  "event" "callable" "do"
			  ;; special class refsa
			  "self" "super" "constructor" "destructor"
			  ;; exceptions
			  "try" "except" "ensure" "raise"
			  ;; logic/control
			  "if" "elif" "else" "unless" "or" "and"
			  ;; loops/control
			  "for" "while"
			  "break" "continue" "pass" "return" "yield"
			  ;; 
			  "true" "false" "null"
			  ;; magic!
			  "goto" ;; TODO add ":lable" syntax below
			  )
			"\\|"))
	(kw2 (mapconcat 'identity ;; BUILTINS
			'("matrix" "array" "BooVersion" "gets" "enumerate" "iterator"
			  "join" "map" "range" "reversed" "shell" "zip"
			  )
			"\\|"))
	(kw3 (mapconcat 'identity ;; NATIVE TYPES
			'("sbyte" "short" "int" "long" "byte" "ushort" "uint" "ulong"
			  "single" "double" "decimal" 
			  "char" "bool" "string"
			  )
			"\\|"))
	(kw4 (mapconcat 'identity ;; MACROS
			(append boo-macros boo-custom-macros)
			"\\|"))
	)
    
   
    (list
     ;; keywords
     (list (concat "\\<\\(" kw1 "\\)\\>") 
	   1 boo-decorators-face)
     ;; builtins when they don't appear as object attributes
     (list (concat "\\([^. \t]\\|^\\)[ \t]*\\<\\(" kw2 "\\)\\>") 
	   2 boo-builtin-face)
     ;; native types
     (list (concat "\\<\\(" kw3 "\\)\\>") 
	   1 boo-native-type-face)
     ;; operators
     (list boo-operator-regexp 1 boo-operator-face) ;;nil t)
     ;; import and namesapce references
     (list (concat "\\(import\\|namespace\\|from\\) \\(" boo-valid-name-regexp "\\)") 
	   2 boo-type-face)
     ;; type declarations
     (list (concat "\\<\\(as\\|cast\\|of\\) [[(]*\\(" boo-valid-name-regexp "\\)[])]*") 
	   2 boo-type-face)
     ;; types in arrays and matrix
     (list (concat "\\(array\\|matrix\\)(\\(" boo-valid-name-regexp "+\\),") 
	   2 boo-type-face)
     ;; declaration names
     '("\\<\\(def\\|class\\|interface\\|struct\\|enum\\|callable\\|macro\\)[ \t]+\\([a-zA-Z_]+[a-zA-Z0-9_]*\\)" 
       2 boo-function-face)
     ;; macros
     (list (concat "[ \t]*\\(" kw4 "\\)[ :]+")
	   1 boo-macro-face)
     ;; string interpolation
     '("\$[({]*\\([a-zA-Z0-9_+-\\[]+\\]*\\)[})]*" 
       1 font-lock-preprocessor-face t)



     ;; delegates
     (list (concat "\\<as callable *(\\(\\(" boo-valid-name-regexp "[, ]*\\)+\\)" )
     	   1 boo-type-face)




     ;; ;; comments should override string interpolation
     ;; ;; (font lock regexps are run in order listed here)
     ;; '("#.*$" 0 boo-comment-face t)

     ;; C-style comments 
     ;; TODO: multi-line comments
     '("\\(//.*$\\)" 
       1 boo-comment-face t)
     '("\\(/\\*.*\\(\\*/\\)*\\)" 
       1 boo-comment-face t)

     ;; ;; numbers
     ;; '("\\b\\([0-9]+[0-9\\.]*\\)"
     ;;   ;; 1 boo-variable-name-face)
     ;;   1 boo-warning-face)

     ;; ;; brackets and parens
     '("\\([\\\[()]\\|]\\)" 
       1 boo-builtin-face)

     ;; properties
     (list (concat "^[ \t]*\\(" boo-valid-name-regexp "\\) as [(]*\\(" boo-valid-name-regexp "\\)[)]*:") 
	   1 boo-function-face)
     (list (concat "\\<\\([Pp]roperty(\\|[Gg]etter(\\|[Ss]etter(\\)\\(" boo-valid-name-regexp "\\))") 
	   2 boo-function-face)
     (list (concat "^[ \t]*\\(" boo-valid-name-regexp "\\) as .*:$")
	   1 boo-function-face)
     '("\\(get\\|set\\):" 
       1 boo-function-face)

     ;; labels and goto
     (list (concat "^[ \t]*:\\(" boo-valid-name-regexp "\\)[ \t]*$")
	   1 boo-function-face)

     ;; add attribute support
     
     ;; assembly attributes
     (list (concat "^\\[\\(assembly\\):")
	   1 boo-decorators-face)
     (list (concat "^\\[assembly:[ ]*\\(" boo-valid-name-regexp "\\)\\]$")
	   1 boo-type-face)
     
     )
))



;; 5. Indentation
;; ======================================================================
;;
;; this shit is nasty but it does work. temporarily. 


(defvar boo-default-block-start-keywords
  '("class" "def" "if" "elif" "else" "try" "except" "ensure" "for" "while" "interface" "struct" "enum" "unless" "set" "get" "macro"))

(defvar boo-block-start-regexp
  (concat "\\_<\\(?:\\(?:"
	  (mapconcat 'identity boo-default-block-start-keywords "\\|")
	  "\\|"
	  (mapconcat 'identity boo-custom-macros "\\|")
	  "\\)\\)\\_>"))


;; The below code is pulled almost entirely from python.el.
;; This is done because the functions have to be re-declared 
;; after the macros are altered to include the Boo syntax. 
;;
;; TODO: is this buffer-local? wouldn't this possibly break
;; python.el if someone is using it and boo-mode at the same time?
(setq python-rx-constituents
      `((block-start          . ,boo-block-start-regexp)

	(decorator            . ,(rx line-start (* space) ?@ (any letter ?_)
				     (* (any word ?_))))
	(defun                . ,(rx symbol-start (or "def" "class") symbol-end))
	(if-name-main         . ,(rx line-start "if" (+ space) "__name__"
				     (+ space) "==" (+ space)
				     (any ?' ?\") "__main__" (any ?' ?\")
				     (* space) ?:))
	(symbol-name          . ,(rx (any letter ?_) (* (any word ?_))))
	(open-paren           . ,(rx (or "{" "[" "(")))
	(close-paren          . ,(rx (or "}" "]" ")")))
	(simple-operator      . ,(rx (any ?+ ?- ?/ ?& ?^ ?~ ?| ?* ?< ?> ?= ?%)))
	;; FIXME: rx should support (not simple-operator).
	(not-simple-operator  . ,(rx
				  (not
				   (any ?+ ?- ?/ ?& ?^ ?~ ?| ?* ?< ?> ?= ?%))))
	;; FIXME: Use regexp-opt.
	(operator             . ,(rx (or "+" "-" "/" "&" "^" "~" "|" "*" "<" ">"
					 "=" "%" "**" "//" "<<" ">>" "<=" "!="
					 "==" ">=" "is" "not")))
	;; FIXME: Use regexp-opt.
	(assignment-operator  . ,(rx (or "=" "+=" "-=" "*=" "/=" "//=" "%=" "**="
					 ">>=" "<<=" "&=" "^=" "|=")))
	(string-delimiter . ,(rx (and
				  ;; Match even number of backslashes.
				  (or (not (any ?\\ ?\' ?\")) point
				      ;; Quotes might be preceded by a escaped quote.
				      (and (or (not (any ?\\)) point) ?\\
					   (* ?\\ ?\\) (any ?\' ?\")))
				  (* ?\\ ?\\)
				  ;; Match single or triple quotes of any kind.
				  (group (or  "\"" "\"\"\"" "'" "'''"))))))
      )

  

(defmacro python-rx (&rest regexps)
  "Python mode specialized rx macro.
This variant of `rx' supports common python named REGEXPS."
  (let ((rx-constituents (append python-rx-constituents rx-constituents)))
    (cond ((null regexps)
	   (error "No regexp"))
	  ((cdr regexps)
	   (rx-to-string `(and ,@regexps) t))
	  (t
	   (rx-to-string (car regexps) t)))))

(setq python-syntax-propertize-function
      (syntax-propertize-rules
       ((python-rx string-delimiter)
	(0 (ignore (python-syntax-stringify))))))


(setq python-nav-beginning-of-defun-regexp
      (python-rx line-start (* space) defun (+ space) (group symbol-name)))



(defun python-indent-guess-indent-offset ()
  "Guess and set `python-indent-offset' for the current buffer."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let ((block-end))
	(while (and (not block-end)
		    (re-search-forward
		     (python-rx line-start block-start) nil t))
	  (when (and
		 (not (python-syntax-context-type))
		 (progn
		   (goto-char (line-end-position))
		   (python-util-forward-comment -1)
		   (if (equal (char-before) ?:)
		       t
		     (forward-line 1)
		     (when (python-info-block-continuation-line-p)
		       (while (and (python-info-continuation-line-p)
				   (not (eobp)))
			 (forward-line 1))
		       (python-util-forward-comment -1)
		       (when (equal (char-before) ?:)
			 t)))))
	    (setq block-end (point-marker))))
	(let ((indentation
	       (when block-end
		 (goto-char block-end)
		 (python-util-forward-comment)
		 (current-indentation))))
	  (if indentation
	      (set (make-local-variable 'python-indent-offset) indentation)
	    (message "Can't guess python-indent-offset, using defaults: %s"
		     python-indent-offset)))))))

(defun python-indent-context ()
  "Get information on indentation context.
Context information is returned with a cons with the form:
    \(STATUS . START)

Where status can be any of the following symbols:
 * inside-paren: If point in between (), {} or []
 * inside-string: If point is inside a string
 * after-backslash: Previous line ends in a backslash
 * after-beginning-of-block: Point is after beginning of block
 * after-line: Point is after normal line
 * no-indent: Point is at beginning of buffer or other special case
START is the buffer position where the sexp starts."
  (save-restriction
    (widen)
    (let ((ppss (save-excursion (beginning-of-line) (syntax-ppss)))
	  (start))
      (cons
       (cond
	;; Beginning of buffer
	((save-excursion
	   (goto-char (line-beginning-position))
	   (bobp))
	 'no-indent)
	;; Inside string
	((setq start (python-syntax-context 'string ppss))
	 'inside-string)
	;; Inside a paren
	((setq start (python-syntax-context 'paren ppss))
	 'inside-paren)
	;; After backslash
	((setq start (when (not (or (python-syntax-context 'string ppss)
				    (python-syntax-context 'comment ppss)))
		       (let ((line-beg-pos (line-number-at-pos)))
			 (python-info-line-ends-backslash-p
			  (1- line-beg-pos)))))
	 'after-backslash)
	;; After beginning of block
	((setq start (save-excursion
		       (when (progn
			       (back-to-indentation)
			       (python-util-forward-comment -1)
			       (equal (char-before) ?:))
			 ;; Move to the first block start that's not in within
			 ;; a string, comment or paren and that's not a
			 ;; continuation line.
			 (while (and (re-search-backward
				      (python-rx block-start) nil t)
				     (or
				      (python-syntax-context-type)
				      (python-info-continuation-line-p))))
			 (when (looking-at (python-rx block-start))
			   (point-marker)))))
	 'after-beginning-of-block)
	;; After normal line
	((setq start (save-excursion
		       (back-to-indentation)
		       (skip-chars-backward (rx (or whitespace ?\n)))
		       (python-nav-beginning-of-statement)
		       (point-marker)))
	 'after-line)
	;; Do not indent
	(t 'no-indent))
       start))))



(defun python-indent-calculate-indentation ()
  "Calculate correct indentation offset for the current line."
  (let* ((indentation-context (python-indent-context))
	 (context-status (car indentation-context))
	 (context-start (cdr indentation-context)))
    (save-restriction
      (widen)
      (save-excursion
	(pcase context-status
	  (`no-indent 0)
	  ;; When point is after beginning of block just add one level
	  ;; of indentation relative to the context-start
	  (`after-beginning-of-block
	   (goto-char context-start)
	   (+ (current-indentation) python-indent-offset))
	  ;; When after a simple line just use previous line
	  ;; indentation, in the case current line starts with a
	  ;; `python-indent-dedenters' de-indent one level.
	  (`after-line
	   (-
	    (save-excursion
	      (goto-char context-start)
	      (current-indentation))
	    (if (progn
		  (back-to-indentation)
		  (looking-at (regexp-opt python-indent-dedenters)))
		python-indent-offset
	      0)))
	  ;; When inside of a string, do nothing. just use the current
	  ;; indentation.  XXX: perhaps it would be a good idea to
	  ;; invoke standard text indentation here
	  (`inside-string
	   (goto-char context-start)
	   (current-indentation))
	  ;; After backslash we have several possibilities.
	  (`after-backslash
	   (cond
	    ;; Check if current line is a dot continuation.  For this
	    ;; the current line must start with a dot and previous
	    ;; line must contain a dot too.
	    ((save-excursion
	       (back-to-indentation)
	       (when (looking-at "\\.")
		 ;; If after moving one line back point is inside a paren it
		 ;; needs to move back until it's not anymore
		 (while (prog2
			    (forward-line -1)
			    (and (not (bobp))
				 (python-syntax-context 'paren))))
		 (goto-char (line-end-position))
		 (while (and (re-search-backward
			      "\\." (line-beginning-position) t)
			     (python-syntax-context-type)))
		 (if (and (looking-at "\\.")
			  (not (python-syntax-context-type)))
		     ;; The indentation is the same column of the
		     ;; first matching dot that's not inside a
		     ;; comment, a string or a paren
		     (current-column)
		   ;; No dot found on previous line, just add another
		   ;; indentation level.
		   (+ (current-indentation) python-indent-offset)))))
	    ;; Check if prev line is a block continuation
	    ((let ((block-continuation-start
		    (python-info-block-continuation-line-p)))
	       (when block-continuation-start
		 ;; If block-continuation-start is set jump to that
		 ;; marker and use first column after the block start
		 ;; as indentation value.
		 (goto-char block-continuation-start)
		 (re-search-forward
		  (python-rx block-start (* space))
		  (line-end-position) t)
		 (current-column))))
	    ;; Check if current line is an assignment continuation
	    ((let ((assignment-continuation-start
		    (python-info-assignment-continuation-line-p)))
	       (when assignment-continuation-start
		 ;; If assignment-continuation is set jump to that
		 ;; marker and use first column after the assignment
		 ;; operator as indentation value.
		 (goto-char assignment-continuation-start)
		 (current-column))))
	    (t
	     (forward-line -1)
	     (goto-char (python-info-beginning-of-backslash))
	     (if (save-excursion
		   (and
		    (forward-line -1)
		    (goto-char
		     (or (python-info-beginning-of-backslash) (point)))
		    (python-info-line-ends-backslash-p)))
		 ;; The two previous lines ended in a backslash so we must
		 ;; respect previous line indentation.
		 (current-indentation)
	       ;; What happens here is that we are dealing with the second
	       ;; line of a backslash continuation, in that case we just going
	       ;; to add one indentation level.
	       (+ (current-indentation) python-indent-offset)))))
	  ;; When inside a paren there's a need to handle nesting
	  ;; correctly
	  (`inside-paren
	   (cond
	    ;; If current line closes the outermost open paren use the
	    ;; current indentation of the context-start line.
	    ((save-excursion
	       (skip-syntax-forward "\s" (line-end-position))
	       (when (and (looking-at (regexp-opt '(")" "]" "}")))
			  (progn
			    (forward-char 1)
			    (not (python-syntax-context 'paren))))
		 (goto-char context-start)
		 (current-indentation))))
	    ;; If open paren is contained on a line by itself add another
	    ;; indentation level, else look for the first word after the
	    ;; opening paren and use it's column position as indentation
	    ;; level.
	    ((let* ((content-starts-in-newline)
		    (indent
		     (save-excursion
		       (if (setq content-starts-in-newline
				 (progn
				   (goto-char context-start)
				   (forward-char)
				   (save-restriction
				     (narrow-to-region
				      (line-beginning-position)
				      (line-end-position))
				     (python-util-forward-comment))
				   (looking-at "$")))
			   (+ (current-indentation) python-indent-offset)
			 (current-column)))))
	       ;; Adjustments
	       (cond
		;; If current line closes a nested open paren de-indent one
		;; level.
		((progn
		   (back-to-indentation)
		   (looking-at (regexp-opt '(")" "]" "}"))))
		 (- indent python-indent-offset))
		;; If the line of the opening paren that wraps the current
		;; line starts a block add another level of indentation to
		;; follow new pep8 recommendation. See: http://ur1.ca/5rojx
		((save-excursion
		   (when (and content-starts-in-newline
			      (progn
				(goto-char context-start)
				(back-to-indentation)
				(looking-at (python-rx block-start))))
		     (+ indent python-indent-offset))))
		(t indent)))))))))))



;; 6. Finis
;; ======================================================================


(define-derived-mode boo-mode python-mode
  "Boo" "Major mode for Boo (derived from python.el)."
  (setcar font-lock-defaults boo-font-lock-keywords)
  ;; (append python-font-lock-keywords boo-font-lock-keywords))
  (setq python-indent-offset 4)
  ;; (setq python-smart-indentation t)
  (setq indent-tabs-mode t)
  (setq tab-width 4)
  (run-hooks 'boo-mode-hook)
)


(provide 'boo-mode)
