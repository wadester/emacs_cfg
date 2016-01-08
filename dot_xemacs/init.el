;;; -*- Mode: Emacs-Lisp -*-
;;;---------------------------------------------------------------------------
;;; Module:  GATOR's .emacs file
;;; Purpose: Emacs startup file (handles emacs 19.29/30 and xemacs 19.14)
;;; Date:    10/29/1996
;;; Author:  ?/?/?      Original from XEMACS 19.14
;;;          10/29/1996 Support of fonts, and alt. keypad by WWH from
;;;                     my .emacs file for AIX/SUN/SCO/LINUX
;;;          6/23/1998  Changes for xemacs 20.4 and emacs 20.2
;;;          3/12/2003  Changes for emacs 21.2-18 and xemacs 21.4.8-16
;;;          11/28/2005 Removed festival and crypt from default install
;;;                     Minor comment changes, no functional changes.
;;;                     This should work for both xemacs and emacs!
;;;          09/28/2015 Added go mode
;;;                     
;;; 
;;; Revision History:     
;;;      $Log$
;;;          
;;; Notes:
;;; 1) Not tested on SUN/AIX/SCO at this time.
;;;
;;; 2) The following lisp packages from the xemacs distribution need to 
;;;    be installed in the local site-lisp directory:
;;;       auto-save.*, completer.* crypt.* 
;;;       rsz-minibuf.* [may not work].
;;;    Source:        /usr/lib/xemacs-[version]/lisp/*/*.[el,elc]
;;;    Destination:   /usr/lib/emacs/site-lisp
;;;      (for RedHat 5.x, install in /usr/share/emacs/site-lisp)
;;;
;;; 3) This file is typically in ~/.xemacs/init.el and is called
;;;    by the ~/.emacs file (basically a stub).
;;;
;;; 4) Notes on XEmacs setup to use colorization:
;;;    a) XEmacs uses ~/.xemacs-options to store user-specified options.
;;;       This allows for some setup without editing the .emacs file.
;;;       Use the Options pull-down and then when finished with changes,
;;;       select Options -> Save Options to save your settings.
;;;    b) These settings help with syntax highlighting:
;;;        Options -> Frame Appearance -> Frame-Local Font Menu OFF
;;;        Options -> Syntax Highlighting -> In This Buffer ON
;;;        Options -> Syntax Highlighting -> Automatic ON
;;;        Options -> Syntax Highlighting -> Fonts OFF  [optional]
;;;        Options -> Syntax Highlighting -> Colors ON  [optional]
;;;        Options -> Syntax Highlighting -> Most ON    [optional]
;;;    c) Select a face and change its color:
;;;       <esc>X list-faces-display<CR> OR Options -> Browse Faces
;;;       click on face then right click to get menu
;;;       select Set foreground then enter a color, or select
;;;       another property to change it.
;;;       Save your options when done (writes .xemacs-options)
;;;       To abort changing a property, type CTRL-G.
;;;
;;; 5) Tested on Fedora Core 4, Emacs 21.4.1, 11/28/2005.
;;;
;;; 6) The below is from the XEMACS 19.14 and 20.4 .emacs sample file.
;;;---------------------------------------------------------------------------
;;;
;;; The .emacs file, which should reside in your home directory, allows you to
;;; customize the behavior of Emacs.  In general, changes to your .emacs file
;;; will not take effect until the next time you start up Emacs.  You can load
;;; it explicitly with `M-x load-file RET ~/.emacs RET'.
;;;
;;; There is a great deal of documentation on customization in the Emacs
;;; manual.  You can read this manual with the online Info browser: type
;;; `C-h i' or select "Emacs Info" from the "Help" menu.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      GO mode                                     ;;
;; Check out github go code and copy to ~/.xemacs
;; Ref:  https://github.com/dominikh/go-mode.el
;; http://tleyden.github.io/blog/2014/05/22/configure-emacs-as-a-go-editor-from-scratch/ 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.xemacs/")
(require 'go-mode-autoloads)

;; setup GOPATH -- for godoc, may not work
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))


;; -- this calls for an absolute path, not sure it is OK
(setenv "GOPATH" ".")

;; auto call gofmt on save
;;(setq exec-path (cons "/usr/local/go/bin" exec-path))
;;(add-to-list 'exec-path "/Users/tleyden/Development/gocode/bin")
;;(add-hook 'before-save-hook 'gofmt-before-save)

;; godef hooks
;;(defun my-go-mode-hook ()
  ; Call Gofmt before saving                                                    
;;  (add-hook 'before-save-hook 'gofmt-before-save)

;;  ; Godef jump key binding                                                      
;;(local-set-key (kbd "M-.") 'godef-jump))
;;(add-hook 'go-mode-hook 'my-go-mode-hook)

;; autocomplete
;;(require 'go-autocomplete)
;;(require 'auto-complete-config)

;; autocompile
;;(defun my-go-mode-hook ()
;;  ; Call Gofmt before saving
;;  (add-hook 'before-save-hook 'gofmt-before-save)
;;  ; Customize compile command to run go build
;;  (if (not (string-match "go" compile-command))
;;      (set (make-local-variable 'compile-command)
;;           "go generate && go build -v && go test -v && go vet"))
;;  ; Godef jump key binding
;;  (local-set-key (kbd "M-.") 'godef-jump))
;;
;;(add-hook 'go-mode-hook 'my-go-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;			Basic Customization			    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable the commands `narrow-to-region' ("C-x n n") and 
;; `eval-expression' ("M-ESC", or "ESC ESC").  Both are useful
;; commands, but they can be confusing for a new user, so they're
;; disabled by default.
(put 'narrow-to-region 'disabled nil)
(put 'eval-expression 'disabled nil)

;;; Define a variable to indicate whether we're running XEmacs/Lucid Emacs.
;;; (You do not have to defvar a global variable before using it --
;;; you can just call `setq' directly like we do for `emacs-major-version'
;;; below.  It's clearer this way, though.)

(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;; Make the sequence "C-x w" execute the `what-line' command, 
;; which prints the current line number in the echo area.
(global-set-key "\C-xw" 'what-line)

;; WWH misc stuff here....
(setq text-mode-hook 'turn-on-auto-fill)
(setq make-backup-files nil)
(put 'eval-expression 'disabled nil)

;; Stuff for mouse wheel 
;; - Emacs needs mwheel.el, built-in w/ xemacs
;;
;; Enable wheelmouse support by default
(cond (window-system
       (mwheel-install)
       (setq mwheel-follow-mouse t)
))

;; Stuff for festival speech synthesis
;; - Need to copy files to xemacs and emacs dirs 
;; 
;;   mkdir /usr/lib/xemacs/xemacs-packages/lisp/festival
;;   cp /usr/share/festival/festival.el \
;;    	/usr/lib/xemacs/xemacs-packages/lisp/festival
;;   cp /usr/share/festival/festival.el \
;;      /usr/share/emacs/site-lisp
;;
;(autoload 'say-minor-mode "festival" "Menu for using Festival." t)
;(say-minor-mode t)

;; Stuff for Octave
;; - Need to copy files to xemacs from emacs dirs
;; cd /usr/share/doc/octave*/emacs
;; cp *.el /usr/lib/xemacs/xemacs-packages/lisp/prog-modes
;;
(autoload 'octave-mode "octave-mod" nil t)
(autoload 'run-octave "octave-inf"' nil t)

;; Setup the suffix mode rules
;; For example, file.c will result in "c-mode".  
(setq auto-mode-alist (mapcar 'purecopy
                              '(("\\.c$" .    c-mode)
                                ("\\.cc$" .   c-mode)
                                ("\\.cxx$" .  c++-mode)
                                ("\\.cpp$" .  c++-mode)
                                ("\\.ino$" .  c++-mode)
                                ("\\.CPP$" .  c++-mode)
                                ("\\.C$" .    c++-mode)
                                ("\\.hpp$" .  c++-mode)
                                ("\\.HPP$" .  c++-mode)
                                ("\\.h$" .    c-mode)
                                ("\\.H$" .    c-mode)
                                ("\\.tex$" .  TeX-mode)
                                ("\\.txi$" .  Texinfo-mode)
                                ("\\.el$" .   emacs-lisp-mode)
                                ("\\.php$" .  php-mode)
                                ("\\.py$" .   python-mode)
                                ("\\.pl$" .   perl-mode)
                                ("\\.pm$" .   perl-mode)
                                ("\\.m$" .    octave-mode)
                                ("\\.spec$" .   rpm-spec-mode)
                                ("\\.spec-in$" . rpm-spec-mode)
                                ("\\.html$" . html-mode)
                                ("\\.htm$" .  html-mode)
                                ("\\.java$" . java-mode)
				("\\.go$" .   go-mode))))

;; set indent mode for braces to not indent
(setq c-brace-offset -2)

(defvar cursor-map-2 (make-keymap)
"for ESC-[")
(fset 'Cursor-Map-2 cursor-map-2)
(define-key esc-map "[" 'Cursor-Map-2)
 
; turn on line numbering
(line-number-mode 1)

;
;
; Delete from here to end of buffer,
; Linux Journal, Issue 5, P. 10
(defun my-nuke-to-end ()
  "Nuke text from here to end of buffer."
  (interactive "*")
  (kill-region (point) (point-max)))
;
;
; Delete line and if at end move up 
; Linux Journal, Issue 5, P. 10
(defun my-nuke-line (arg)
  "Nuke a line."
  (interactive "*p")
  (beginning-of-line nil)
  (kill-line arg)
  (if (= (point) (max-point))
    (progn
      (forward-line -1)
      (end-of-line nil)
      (kill-line arg)
      (beginning-of-line nil))))
;
;
;; kill the current line -- bound to an F key
(defun kill-current-line ()
  "Kills the current line."
  (interactive)
  (beginning-of-line)
  (kill-line 1))

;
;; set up the function keys to do common tasks to reduce Emacs pinky
;; and such.
(global-set-key [f29]         'scroll-down)            ; SUN page down
(global-set-key [f35]         'scroll-up)              ; SUN page up
(global-set-key [kp-divide]   'kill-current-line)
(global-set-key [f25]         'kill-current-line)
(global-set-key [kp-multiply] 'advertised-undo)        ; LINUX
(global-set-key [f26]         'advertised-undo)        ; SUN R6=f26
(global-set-key [kp-add]      'copy-region-as-kill)    ; keypad +
(global-set-key [kp-subtract] 'kill-region)            ; keypad -
(global-set-key [kp-enter]    'set-mark-command)       ; keypad ENTER
(global-set-key [insert]      'yank)                   ; keypad INS
(global-set-key [end]         'end-of-line)            ; LINUX END
(global-set-key [home]        'beginning-of-line)      ; LUNUX HOME
(global-set-key [f33]         'end-of-line)            ; SUN END
(global-set-key [f27]         'beginning-of-line)      ; SUN HOME
(global-set-key [f1]       'delete-other-windows)      ; F1
(global-set-key [f2]       'split-window-vertically)   ; F2
(global-set-key [f3]       'split-window-horizontally) ; F3
(global-set-key [f4]       'find-file)                 ; F4 - find file
(global-set-key [f5]       'search-forward)            ; F5
(global-set-key [f6]       'start-kbd-macro)           ; F6 
(global-set-key [f7]       'end-kbd-macro)             ; F7
(global-set-key [f8]       'call-last-kbd-macro)       ; F8
(global-set-key [f9]       'goto-line)                 ; F9
;(global-set-key [f10]      'toggle-macro)             ; F10 - experimental
(global-set-key [f10]      'set-mark-command) 	       ; F10 - set mark
(global-set-key [f11]      'overwrite-mode)            ; F11
(global-set-key [f12]      'info)                      ; F12	


;; XEMACS uses the "_" whereas emacs uses the "-" character!
(global-set-key [kp_divide]   'kill-current-line)
(global-set-key [kp_multiply] 'advertised-undo)        ; LINUX
(global-set-key [kp_add]      'copy-region-as-kill)    ; keypad +
(global-set-key [kp_subtract] 'kill-region)            ; keypad -
(global-set-key [kp_enter]    'set-mark-command)       ; keypad ENTER

;; Stuff from the demo .emacs below:
;; =================================
;; Make F1 invoke help
; (global-set-key 'f1 'help-command)
;; Make F2 be `undo'
; (global-set-key 'f2 'undo)
;; Make F3 be `find-file'
;; Note: it does not currently work to say
;;   (global-set-key 'f3 "\C-x\C-f")
;; The reason is that macros can't do interactive things properly.
;; This is an extremely longstanding bug in Emacs.  Eventually,
;; it will be fixed. (Hopefully ..)
;(global-set-key 'f3 'find-file)

;; Make F4 be "mark", F5 be "copy", F6 be "paste"
;; Note that you can set a key sequence either to a command or to another
;; key sequence.
;(global-set-key 'f4 'set-mark-command)
;(global-set-key 'f5 "\M-w")
;(global-set-key 'f6 "\C-y")

;; Shift-F4 is "pop mark off of stack"
;(global-set-key '(shift f4) (lambda () (interactive) (set-mark-command t)))

;; Make F7 be `save-buffer'
;(global-set-key 'f7 'save-buffer)

;; Make F8 be "start macro", F9 be "end macro", F10 be "execute macro"
;(global-set-key 'f8 'start-kbd-macro)
;(global-set-key 'f9 'end-kbd-macro)
;(global-set-key 'f10 'call-last-kbd-macro)

;; Here's an alternative binding if you don't use keyboard macros:
;; Make F8 be `save-buffer' followed by `delete-window'.
;;(global-set-key 'f8 "\C-x\C-s\C-x0")

;; If you prefer delete to actually delete forward then you want to
;; uncomment the next line.
;; (load-library "delbackspace")


(cond (running-xemacs
       ;;
       ;; Code for any version of XEmacs/Lucid Emacs goes here
       ;;

       ;; Change the values of some variables.
       ;; (t means true; nil means false.)
       ;;
       ;; Use the "Describe Variable..." option on the "Help" menu
       ;; to find out what these variables mean.
       (setq find-file-use-truenames nil
	     find-file-compare-truenames t
	     minibuffer-confirm-incomplete t
	     complex-buffers-menu-p t
	     next-line-add-newlines nil
	     mail-yank-prefix "> "
	     kill-whole-line t
	     )

       ;; When running ispell, consider all 1-3 character words as correct.
       (setq ispell-extra-args '("-W" "3"))

       ;; Change the way the buffer name is displayed in the
       ;; modeline.  The variable for this is called
       ;; 'modeline-buffer-identification but was called
       ;; 'mode-line-buffer-identification in older XEmacsen.
       (if (boundp 'modeline-buffer-identification)
	   ;; Note that if you want to put more than one form in the
	   ;; `THEN' clause of an IF-THEN-ELSE construct, you have to
	   ;; surround the forms with `progn'.  You don't have to
	   ;; do this for the `ELSE' clause.
	   (progn
	     (setq-default modeline-buffer-identification '("XEmacs: %17b"))
	     (setq modeline-buffer-identification '("XEmacs: %17b")))
	 (setq-default mode-line-buffer-identification '("XEmacs: %17b"))
	 (setq mode-line-buffer-identification '("XEmacs: %17b")))

       (cond ((or (not (fboundp 'device-type))
		  (equal (device-type) 'x))
	      ;;
	      ;; Code which applies only when running emacs under X goes here.
	      ;; (We check whether the function `device-type' exists
	      ;; before using it.  In versions before 19.12, there
	      ;; was no such function.  If it doesn't exist, we
	      ;; simply assume we're running under X -- versions before
	      ;; 19.12 only supported X.)

	      ;; Remove the binding of C-x C-c, which normally exits emacs.
	      ;; It's easy to hit this by mistake, and that can be annoying.
	      ;; Under X, you can always quit with the "Exit Emacs" option on
	      ;; the File menu.
;	      (global-set-key "\C-x\C-c" nil)

	      ;; Uncomment this to enable "sticky modifier keys" in 19.13
	      ;; and up.  With sticky modifier keys enabled, you can
	      ;; press and release a modifier key before pressing the
	      ;; key to be modified, like how the ESC key works always.
	      ;; If you hold the modifier key down, however, you still
	      ;; get the standard behavior.  I personally think this
	      ;; is the best thing since sliced bread (and a *major*
	      ;; win when it comes to reducing Emacs pinky), but it's
	      ;; disorienting at first so I'm not enabling it here by
	      ;; default.

	      ;;(setq modifier-keys-are-sticky t)

	      ;; This changes the variable which controls the text that goes
	      ;; in the top window title bar.  (However, it is not changed
	      ;; unless it currently has the default value, to avoid
	      ;; interfering with a -wn command line argument I may have
	      ;; started emacs with.)
	      (if (equal frame-title-format "%S: %b")
		  (setq frame-title-format
			(concat "%S: " invocation-directory invocation-name
				" [" emacs-version "]"
				(if nil ; (getenv "NCD")
				    ""
				  "   %b"))))

	      ;; If we're running on display 0, load some nifty sounds that
	      ;; will replace the default beep.  But if we're running on a
	      ;; display other than 0, which probably means my NCD X terminal,
	      ;; which can't play digitized sounds, do two things: reduce the
	      ;; beep volume a bit, and change the pitch of the sound that is
	      ;; made for "no completions."
	      ;;
	      ;; (Note that sampled sounds only work if XEmacs was compiled
	      ;; with sound support, and we're running on the console of a
	      ;; Sparc, HP, or SGI machine, or on a machine which has a
	      ;; NetAudio server; otherwise, you just get the standard beep.)
	      ;;
	      ;; (Note further that changing the pitch and duration of the
	      ;; standard beep only works with some X servers; many servers
	      ;; completely ignore those parameters.)
	      ;;
	      (cond ((string-match ":0" (getenv "DISPLAY"))
		     (load-default-sounds))
		    (t
		     (setq bell-volume 40)
		     (setq sound-alist
			   (append sound-alist '((no-completion :pitch 500))))
		     ))

	      ;; Make `C-x C-m' and `C-x RET' be different (since I tend
	      ;; to type the latter by accident sometimes.)
	      (define-key global-map [(control x) return] nil)

	      ;; Change the pointer used when the mouse is over a modeline
	      (set-glyph-image modeline-pointer-glyph "leftbutton")

	      ;; Change the pointer used during garbage collection.
	      ;;
	      ;; Note that this pointer image is rather large as pointers go,
	      ;; and so it won't work on some X servers (such as the MIT
	      ;; R5 Sun server) because servers may have lamentably small
	      ;; upper limits on pointer size.
	      ;;(if (featurep 'xpm)
	      ;;   (set-glyph-image gc-pointer-glyph
	      ;;	 (expand-file-name "trash.xpm" data-directory)))

	      ;; Here's another way to do that: it first tries to load the
	      ;; pointer once and traps the error, just to see if it's
	      ;; possible to load that pointer on this system; if it is,
	      ;; then it sets gc-pointer-glyph, because we know that
	      ;; will work.  Otherwise, it doesn't change that variable
	      ;; because we know it will just cause some error messages.
	      (if (featurep 'xpm)
		  (let ((file (expand-file-name "recycle.xpm" data-directory)))
		    (if (condition-case error
			    ;; check to make sure we can use the pointer.
			    (make-image-instance file nil
						 '(pointer))
			  (error nil))	    ; returns nil if an error occurred.
			(set-glyph-image gc-pointer-glyph file))))
	 
	      ;; Add `dired' to the File menu
	      (add-menu-item '("File") "Edit Directory" 'dired t)

	      ;; Here's a way to add scrollbar-like buttons to the menubar
	      (add-menu-item nil "Top" 'beginning-of-buffer t)
	      (add-menu-item nil "<<<" 'scroll-down t)
	      (add-menu-item nil " . " 'recenter t)
	      (add-menu-item nil ">>>" 'scroll-up t)
	      (add-menu-item nil "Bot" 'end-of-buffer t)
	      
	      ;; Change the behavior of mouse button 2 (which is normally
	      ;; bound to `mouse-yank'), so that it inserts the selected text
	      ;; at point (where the text cursor is), instead of at the
	      ;; position clicked.
	      ;;
	      ;; Note that you can find out what a particular key sequence or
	      ;; mouse button does by using the "Describe Key..." option on
	      ;; the Help menu.
	      (setq mouse-yank-at-point t)

	      ;; When editing C code (and Lisp code and the like), I often
	      ;; like to insert tabs into comments and such.  It gets to be
	      ;; a pain to always have to use `C-q TAB', so I set up a more
	      ;; convenient binding.  Note that this does not work in
	      ;; TTY frames.
	      (define-key global-map '(shift tab) 'self-insert-command)

	      ;; LISPM bindings of Control-Shift-C and Control-Shift-E.
	      ;; Note that "\C-C" means Control-C, not Control-Shift-C.
	      ;; To specify shifted control characters, you must use the
	      ;; more verbose syntax used here.
	      (define-key emacs-lisp-mode-map '(control C) 'compile-defun)
	      (define-key emacs-lisp-mode-map '(control E) 'eval-defun)

	      ;; If you like the FSF Emacs binding of button3 (single-click
	      ;; extends the selection, double-click kills the selection),
	      ;; uncomment the following:

	      ;; Under 19.13, the following is enough:
              ;(define-key global-map 'button3 'mouse-track-adjust)

	      ;; But under 19.12, you need this:
              ;(define-key global-map 'button3
              ;    (lambda (event)
              ;      (interactive "e")
              ;      (let ((default-mouse-track-adjust t))
              ;        (mouse-track event))))

	      ;; Under both 19.12 and 19.13, you also need this:
              ;(add-hook 'mouse-track-click-hook
              ;          (lambda (event count)
              ;            (if (or (/= (event-button event) 3)
              ;                    (/= count 2))
              ;                nil ;; do the normal operation
              ;              (kill-region (point) (mark))
              ;              t ;; don't do the normal operations.
              ;              )))


	      ))

       ))

;; Oh, and here's a cute hack you might want to put in the sample .emacs
;; file: it changes the color of the window if it's not on the local
;; machine, or if it's running as root:

;; local emacs background:  whitesmoke
;; remote emacs background: palegreen1
;; root emacs background:   coral2
(cond
 ((and (string-match "XEmacs" emacs-version)
       (eq window-system 'x)
       (boundp 'emacs-major-version)
       (= emacs-major-version 19)
       (>= emacs-minor-version 12))
  (let* ((root-p (eq 0 (user-uid)))
	 (dpy (or (getenv "DISPLAY") ""))
	 (remote-p (not
		    (or (string-match "^\\(\\|unix\\|localhost\\):" dpy)
			(let ((s (system-name)))
			  (if (string-match "\\.\\(netscape\\|mcom\\)\\.com" s)
			      (setq s (substring s 0 (match-beginning 0))))
			  (string-match (concat "^" (regexp-quote s)) dpy)))))
	 (bg (cond (root-p "coral2")
		   (remote-p "palegreen1")
		   (t nil))))
    (cond (bg
	   (let ((def (color-name (face-background 'default)))
		 (faces (face-list)))
	     (while faces
	       (let ((obg (face-background (car faces))))
		 (if (and obg (equal def (color-name obg)))
		     (set-face-background (car faces) bg)))
	       (setq faces (cdr faces)))))))))


;;; Older versions of emacs did not have these variables
;;; (emacs-major-version and emacs-minor-version.)
;;; Let's define them if they're not around, since they make
;;; it much easier to conditionalize on the emacs version.

(if (and (not (boundp 'emacs-major-version))
	 (string-match "^[0-9]+" emacs-version))
    (setq emacs-major-version
	  (string-to-int (substring emacs-version
				    (match-beginning 0) (match-end 0)))))
(if (and (not (boundp 'emacs-minor-version))
	 (string-match "^[0-9]+\\.\\([0-9]+\\)" emacs-version))
    (setq emacs-minor-version
	  (string-to-int (substring emacs-version
				    (match-beginning 1) (match-end 1)))))

;;; Define a function to make it easier to check which version we're
;;; running.

(defun running-emacs-version-or-newer (major minor)
  (or (> emacs-major-version major)
      (and (= emacs-major-version major)
	   (>= emacs-minor-version minor))))

(cond ((and running-xemacs
	    (running-emacs-version-or-newer 19 6))
       ;;
       ;; Code requiring XEmacs/Lucid Emacs version 19.6 or newer goes here
       ;;
       ))

(cond ((>= emacs-major-version 19)
       ;;
       ;; Code for any vintage-19 emacs goes here
       ;;
       ))

(cond ((and (not running-xemacs)
	    (>= emacs-major-version 19))
       ;;
       ;; Code specific to FSF Emacs 19 (not XEmacs/Lucid Emacs) goes here
       ;;

(cond ((< emacs-major-version 19)
       ;;
       ;; Code specific to emacs 18 goes here
       ;;
       ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;		Customization of Specific Packages		    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Load gnuserv, which will allow you to connect to XEmacs sessions
;;; using `gnuclient'.

;; If you never run more than one XEmacs at a time, you might want to
;; always start gnuserv.  Otherwise it is preferable to specify
;; `-f gnuserv-start' on the command line to one of the XEmacsen.
; (gnuserv-start)


;;; ********************
;;; Load efs, which uses the FTP protocol as a pseudo-filesystem.
;;; When this is loaded, the pathname syntax /user@host:/remote/path
;;; refers to files accessible through ftp.
;;;
; (require 'dired)
;; compatible ange-ftp/efs initialization derived from code
;; from John Turner <turner@lanl.gov>
;; As of 19.15, efs is bundled instead of ange-ftp.
;; NB: doesn't handle 20.0 properly, efs didn't appear until 20.1.
;;
;; The environment variable EMAIL_ADDRESS is used as the password
;; for access to anonymous ftp sites, if it is set.  If not, one is
;; constructed using the environment variables USER and DOMAINNAME
;; (e.g. turner@lanl.gov), if set.

(if (and running-xemacs
	 (or (and (= emacs-major-version 20) (>= emacs-minor-version 1))
	     (and (= emacs-major-version 19) (>= emacs-minor-version 15))))
    (progn
      (message "Loading and configuring bundled packages... efs")
      (require 'efs-auto)
      (if (getenv "USER")
	  (setq efs-default-user (getenv "USER")))
      (if (getenv "EMAIL_ADDRESS")
	  (setq efs-generate-anonymous-password (getenv "EMAIL_ADDRESS"))
	(if (and (getenv "USER")
		 (getenv "DOMAINNAME"))
	    (setq efs-generate-anonymous-password
		  (concat (getenv "USER")"@"(getenv "DOMAINNAME")))))
      (setq efs-auto-save 1))
;;;  (progn
;;;    (message "Loading and configuring bundled packages... ange-ftp")
;;;    (require 'ange-ftp)
;;;    (if (getenv "USER")
;;;	(setq ange-ftp-default-user (getenv "USER")))
;;;    (if (getenv "EMAIL_ADDRESS")
;;;	(setq ange-ftp-generate-anonymous-password (getenv "EMAIL_ADDRESS"))
;;;      (if (and (getenv "USER")
;;;	       (getenv "DOMAINNAME"))
;;;	  (setq ange-ftp-generate-anonymous-password
;;;		(concat (getenv "USER")"@"(getenv "DOMAINNAME")))))
;;;    (setq ange-ftp-auto-save 1)
;;;    )
  )

;;; ********************
;;; Load the default-dir.el package which installs fancy handling
;;;  of the initial contents in the minibuffer when reading
;;; file names.

(if (and running-xemacs
	 (or (and (= emacs-major-version 20) (>= emacs-minor-version 1))
	     (and (= emacs-major-version 19) (>= emacs-minor-version 15))))
    (require 'default-dir))


;; WWH added all the code here for standard EMACS 
;; ==============================================
; setup faces 
; M-x list-faces -- shows all faces
; M-x apropos face -- shows types
; Linux Journal, Issue 5, P. 12
;(set-foreground-color "white")


; WWH not w/ XEMACS (set-foreground-color "black")
; WWH not w/ XEMACS (set-background-color "gray")
;(set-background-color "dimgray")
;(set-cursor-color "blue")

(set-face-foreground 'bold "Navy")
(set-face-foreground 'bold-italic "red")
(set-face-foreground 'italic "darkgreen")
;(set-face-foreground 'modeline "orange")
;(set-face-background 'modeline "dimgray")
(set-face-foreground 'highlight "darkred")
(set-face-background 'highlight "gray")
(set-face-underline-p 'bold nil )
(set-face-underline-p 'underline nil )
(set-face-foreground 'region "white")
(set-face-background 'region "dimgray")
(set-face-foreground 'underline "slateblue")
(set-face-background 'underline "gray")


; turn on region face from mark to point
;
; turn on faces
(font-lock-mode 1)

;; Turn on font-lock mode for Emacs
(cond ((not running-xemacs)
       (global-font-lock-mode t)
))

(cond ((and (not running-xemacs)
	    (>= emacs-major-version 19))
       (transient-mark-mode 1)
       (set-foreground-color "black")
       (set-background-color "gray")
       ;; (copy-face 'bold 'font-lock-keyword-face)
       ))
(set-face-foreground 'font-lock-comment-face "darkred")
(set-face-foreground 'font-lock-string-face "green4")
(set-face-foreground 'font-lock-type-face "purple")
(set-face-foreground 'font-lock-keyword-face "blue")
(set-face-foreground 'font-lock-function-name-face "DarkSlateBlue")
(set-face-foreground 'font-lock-variable-name-face "blue3")
;;WWH:  3/11/03 for emacs 21.2.1
;;  (set-face-foreground 'font-lock-reference-face "Navy")
;;WWH:  old comment out....
;;(copy-face 'italic 'font-lock-type-face)

; turn on font lock mode with new modes
(defun my-enable-minor-modes ()
  "Enables several minor modes."
  (interactive "")
;  (transient-mark-mode 1)
  (font-lock-mode 1))
(add-hook 'c-mode-hook 'my-enable-minor-modes)
(add-hook 'emacs-lisp-mode-hook 'my-enable-minor-modes)
(add-hook 'text-mode-hook 'my-enable-minor-modes)
(add-hook 'html-mode-hook 'my-enable-minor-modes)
(add-hook 'octave-mode-hook 
	(lambda ()
	  (abbrev-mode 1)
	  (auto-fill-mode 1)
	  (if (eq window-system 'x)
		(font-lock-mode 1))))
;; WWH end new code....

       ))

(cond ((< emacs-major-version 19)
       ;;
       ;; Code specific to emacs 18 goes here
       ;;
       ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;		Customization of Specific Packages		    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Load gnuserv, which will allow you to connect to XEmacs sessions
;;; using `gnuclient'.

;; If you never run more than one XEmacs at a time, you might want to
;; always start gnuserv.  Otherwise it is preferable to specify
;; `-f gnuserv-start' on the command line to one of the XEmacsen.
(cond (running-xemacs
       (gnuserv-start)
       ))

;;; ********************
;;; Load efs, which uses the FTP protocol as a pseudo-filesystem.
;;; When this is loaded, the pathname syntax /user@host:/remote/path
;;; refers to files accessible through ftp.
;;;
(require 'dired)
;; compatible ange-ftp/efs initialization derived from code
;; from John Turner <turner@lanl.gov>
;; As of 19.15, efs is bundled instead of ange-ftp.
;; NB: doesn't handle 20.0 properly, efs didn't appear until 20.1.
;;
;; The environment variable EMAIL_ADDRESS is used as the password
;; for access to anonymous ftp sites, if it is set.  If not, one is
;; constructed using the environment variables USER and DOMAINNAME
;; (e.g. turner@lanl.gov), if set.

(if (and running-xemacs
	 (or (and (= emacs-major-version 20) (>= emacs-minor-version 1))
	     (and (= emacs-major-version 19) (>= emacs-minor-version 15))))
    (progn
      (message "Loading and configuring bundled packages... efs")
      (require 'efs-auto)
      (if (getenv "USER")
	  (setq efs-default-user (getenv "USER")))
      (if (getenv "EMAIL_ADDRESS")
	  (setq efs-generate-anonymous-password (getenv "EMAIL_ADDRESS"))
	(if (and (getenv "USER")
		 (getenv "DOMAINNAME"))
	    (setq efs-generate-anonymous-password
		  (concat (getenv "USER")"@"(getenv "DOMAINNAME")))))
      (setq efs-auto-save 1))
;;;  (progn
;;;    (message "Loading and configuring bundled packages... ange-ftp")
;;;    (require 'ange-ftp)
;;;    (if (getenv "USER")
;;;	(setq ange-ftp-default-user (getenv "USER")))
;;;    (if (getenv "EMAIL_ADDRESS")
;;;	(setq ange-ftp-generate-anonymous-password (getenv "EMAIL_ADDRESS"))
;;;      (if (and (getenv "USER")
;;;	       (getenv "DOMAINNAME"))
;;;	  (setq ange-ftp-generate-anonymous-password
;;;		(concat (getenv "USER")"@"(getenv "DOMAINNAME")))))
;;;    (setq ange-ftp-auto-save 1)
;;;    )
  )

;;; ********************
;;; Load ange-ftp, which uses the FTP protocol as a pseudo-filesystem.
;;; When this is loaded, the pathname syntax /user@host:/remote/path
;;; refers to files accessible through ftp.
;;;
;;; ;(require 'dired)
;;; ;(require 'ange-ftp)
;;; ;(setq ange-ftp-default-user "anonymous"      ; id to use for /host:/remote/path
;;; ;      ange-ftp-generate-anonymous-password t ; use $USER@`hostname`
;;; ;      ange-ftp-binary-file-name-regexp "."   ; always transfer in binary mode
;;; ;      )


;;; ********************
;;; WWH: need auto-save.[el,elc] in site-lisp directory for this....

;;; Load the auto-save.el package, which lets you put all of your autosave
;;; files in one place, instead of scattering them around the file system.
;;;
;;;(setq auto-save-directory (expand-file-name "~/autosave/")
;;;      auto-save-directory-fallback auto-save-directory
;;;      auto-save-hash-p nil
;;;      ange-ftp-auto-save t
;;;      ange-ftp-auto-save-remotely nil
;;;      ;; now that we have auto-save-timeout, let's crank this up
;;;      ;; for better interactive response.
;;;      auto-save-interval 2000
;;;      )
;; We load this afterwards because it checks to make sure the
;; auto-save-directory exists (creating it if not) when it's loaded.
;;;(require 'auto-save)

;; This adds additional extensions which indicate files normally
;; handled by cc-mode.
(setq auto-mode-alist
      (append '(("\\.C$"  . c++-mode)
		("\\.cc$" . c++-mode)
		("\\.hh$" . c++-mode)
		("\\.c$"  . c-mode)
		("\\.h$"  . c-mode))
	      auto-mode-alist))


;;; ********************
;;; cc-mode (the mode you're in when editing C, C++, and Objective C files)

;; Tell cc-mode not to check for old-style (K&R) function declarations.
;; This speeds up indenting a lot.
(setq c-recognize-knr-p nil)

;; Change the indentation amount to 4 spaces instead of 2.
;; You have to do it in this complicated way because of the
;; strange way the cc-mode initializes the value of `c-basic-offset'.
(add-hook 'c-mode-hook (lambda () (setq c-basic-offset 4)))


;;; ********************
;;; WWH:  Need completer.[el,elc] in site-lisp directory for this:

;;; Load a partial-completion mechanism, which makes minibuffer completion
;;; search multiple words instead of just prefixes; for example, the command
;;; `M-x byte-compile-and-load-file RET' can be abbreviated as `M-x b-c-a RET'
;;; because there are no other commands whose first three words begin with
;;; the letters `b', `c', and `a' respectively.
;;;
;;; WWH -- this causes emacs 20.2 to dump core -- do not include....
(cond (running-xemacs
       (load-library "completer")
       ))

;;; ********************
;;; WWH:  Need crypt.[el,elc] in site-lisp directory for this:

;;; Load crypt, which is a package for automatically decoding and reencoding
;;; files by various methods - for example, you can visit a .Z or .gz file,
;;; edit it, and have it automatically re-compressed when you save it again.
;;; 
;(setq crypt-encryption-type 'pgp   ; default encryption mechanism
;      crypt-confirm-password t	   ; make sure new passwords are correct
;      ;crypt-never-ever-decrypt t  ; if you don't encrypt anything, set this to
;				   ; tell it not to assume that "binary" files
;				   ; are encrypted and require a password.
;      )
;(require 'crypt)


;;; ********************
;;; Edebug is a source-level debugger for emacs-lisp programs.
;;;
(define-key emacs-lisp-mode-map "\C-xx" 'edebug-defun)


;;; ********************
;;; Font-Lock is a syntax-highlighting package.  When it is enabled and you
;;; are editing a program, different parts of your program will appear in
;;; different fonts or colors.  For example, with the code below, comments
;;; appear in red italics, function names in function definitions appear in
;;; blue bold, etc.  The code below will cause font-lock to automatically be
;;; enabled when you edit C, C++, Emacs-Lisp, and many other kinds of
;;; programs.
;;;
;;; The "Options" menu has some commands for controlling this as well.
;;;
(cond (running-xemacs

       ;; If you want the default colors, you could do this:
       ;; (setq font-lock-use-default-fonts nil)
       ;; (setq font-lock-use-default-colors t)
       ;; but I want to specify my own colors, so I turn off all
       ;; default values.
       (setq font-lock-use-default-fonts nil)
       (setq font-lock-use-default-colors nil)

       (require 'font-lock)

       ;; Mess around with the faces a bit.  Note that you have
       ;; to change the font-lock-use-default-* variables *before*
       ;; loading font-lock, and wait till *after* loading font-lock
       ;; to customize the faces.

       ;; string face is green
       (set-face-foreground 'font-lock-string-face "forest green")

       ;; comments are italic and red; doc strings are italic
       ;;
       ;; (I use copy-face instead of make-face-italic/make-face-bold
       ;; because the startup code does intelligent things to the
       ;; 'italic and 'bold faces to ensure that they are different
       ;; from the default face.  For example, if the default face
       ;; is bold, then the 'bold face will be unbold.)
       ; WWH I disabled this as "d's" and other chars are hard to read
       ; (copy-face 'italic 'font-lock-comment-face)
       ;; Underling comments looks terrible on tty's
       (set-face-underline-p 'font-lock-comment-face nil 'global 'tty)
       (set-face-highlight-p 'font-lock-comment-face t 'global 'tty)
       (copy-face 'font-lock-comment-face 'font-lock-doc-string-face)
       (set-face-foreground 'font-lock-comment-face "red")

       ;; function names are bold and blue
       (copy-face 'bold 'font-lock-function-name-face)
       (set-face-foreground 'font-lock-function-name-face "blue")

       ;; misc. faces
       (and (find-face 'font-lock-preprocessor-face) ; 19.13 and above
            (copy-face 'bold 'font-lock-preprocessor-face))
       ;; (copy-face 'italic 'font-lock-type-face)
       ;; (copy-face 'bold 'font-lock-keyword-face)
       ))


;;; ********************
;;; fast-lock is a package which speeds up the highlighting of files
;;; by saving information about a font-locked buffer to a file and
;;; loading that information when the file is loaded again.  This
;;; requires a little extra disk space be used.
;;;
;;; Normally fast-lock puts the cache file (the filename appended with
;;; .flc) in the same directory as the file it caches.  You can
;;; specify an alternate directory to use by setting the variable
;;; fast-lock-cache-directories.

;; Let's use lazy-lock instead.
;;(add-hook 'font-lock-mode-hook 'turn-on-fast-lock)
;;(setq fast-lock-cache-directories '("/foo/bar/baz"))


;;; ********************
;;; lazy-lock is a package which speeds up the highlighting of files
;;; by doing it "on-the-fly" -- only the visible portion of the
;;; buffer is fontified.  The results may not always be quite as
;;; accurate as using full font-lock or fast-lock, but it's *much*
;;; faster.  No more annoying pauses when you load files.

;; WWH added running-xemacs around below:
(cond (running-xemacs

  (add-hook 'font-lock-mode-hook 'turn-on-lazy-lock)
;; I personally don't like "stealth mode" (where lazy-lock starts
;; fontifying in the background if you're idle for 30 seconds)
;; because it takes too long to wake up again on my piddly Sparc 1+.
  (setq lazy-lock-stealth-time nil)
))

;;; ********************
;;; func-menu is a package that scans your source file for function
;;; definitions and makes a menubar entry that lets you jump to any
;;; particular function definition by selecting it from the menu.  The
;;; following code turns this on for all of the recognized languages.
;;; Scanning the buffer takes some time, but not much.
;;;
;;; Send bug reports, enhancements etc to:
;;; David Hughes <ukchugd@ukpmr.cs.philips.nl>
;;;
(cond (running-xemacs
       (require 'func-menu)
;       (define-key global-map 'f8 'function-menu)
       (define-key global-map 'f12 'function-menu)
       (add-hook 'find-file-hooks 'fume-add-menubar-entry)
       (define-key global-map "\C-cl" 'fume-list-functions)
       (define-key global-map "\C-cg" 'fume-prompt-function-goto)

       ;; The Hyperbole information manager package uses (shift button2) and
       ;; (shift button3) to provide context-sensitive mouse keys.  If you
       ;; use this next binding, it will conflict with Hyperbole's setup.
       ;; Choose another mouse key if you use Hyperbole.
       (define-key global-map '(shift button3) 'mouse-function-menu)

       ;; For descriptions of the following user-customizable variables,
       ;; type C-h v <variable>
       (setq fume-max-items 25
             fume-fn-window-position 3
             fume-auto-position-popup t
             fume-display-in-modeline-p t
             fume-menubar-menu-location "File"
             fume-buffer-name "*Function List*"
             fume-no-prompt-on-valid-default nil)
       ))


;;; ********************
;;; MH is a mail-reading system from the Rand Corporation that relies on a
;;; number of external filter programs (which do not come with emacs.)
;;; Emacs provides a nice front-end onto MH, called "mh-e".
;;;
;; Bindings that let you send or read mail using MH
;(global-set-key "\C-xm" 'mh-smail)
;(global-set-key "\C-x4m" 'mh-smail-other-window)
;(global-set-key "\C-cr" 'mh-rmail)

;; Customization of MH behavior.
(setq mh-delete-yanked-msg-window t)
(setq mh-yank-from-start-of-msg 'body)
(setq mh-summary-height 11)

;; Use lines like the following if your version of MH
;; is in a special place.
;(setq mh-progs "/usr/dist/pkgs/mh/bin.svr4/")
;(setq mh-lib "/usr/dist/pkgs/mh/lib.svr4/")


;;; ********************
;;; resize-minibuffer-mode makes the minibuffer automatically
;;; resize as necessary when it's too big to hold its contents.

;; WWH put running-xemacs around below....
(cond (running-xemacs

  (autoload 'resize-minibuffer-mode "rsz-minibuf" nil t)
  (resize-minibuffer-mode)
  (setq resize-minibuffer-window-exactly nil)
))

 
;;; ********************
;;; W3 is a browser for the World Wide Web, and takes advantage of the very
;;; latest redisplay features in XEmacs.  You can access it simply by typing 
;;; 'M-x w3'; however, if you're unlucky enough to be on a machine that is 
;;; behind a firewall, you will have to do something like this first:

;(setq w3-use-telnet t
;      ;;
;      ;; If the Telnet program you use to access the outside world is
;      ;; not called "telnet", specify its name like this.
;      w3-telnet-prog "itelnet"
;      ;;
;      ;; If your Telnet program adds lines of junk at the beginning
;      ;; of the session, specify the number of lines here.
;      w3-telnet-header-length 4
;      )

; turn on faces
(font-lock-mode 1)

; For newer Xemacs that does not automatically accept
; just doing a font-lock-mode 1, these are required. 
(cond (running-xemacs
	 (add-hook 'emacs-lisp-mode-hook	'turn-on-font-lock)
	 (add-hook 'dired-mode-hook	'turn-on-font-lock)
	 (setq options-save-faces t)
	 ))

;; Options Menu Settings
;; =====================
(cond
 ((and (string-match "XEmacs" emacs-version)
       (boundp 'emacs-major-version)
       (or (and
            (= emacs-major-version 19)
            (>= emacs-minor-version 14))
           (= emacs-major-version 20))
       (fboundp 'load-options-file))
  (load-options-file "/home/wadeh/.xemacs-options")))
;; ============================
;; End of Options Menu Settings



(setq minibuffer-max-depth nil)

