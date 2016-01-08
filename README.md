# emacs_cfg

Summary:
========

This repository contains configuration files I have used since the 
early 1990s for both Emacs and XEmacs.  These lisp files map the PC 
function (F) keys and add features including language-specific 
highlighting.  Note that the mappings are loosely based on the 
Brief editor (very old).


Installation:
=============

1)  Copy dot_emacs to ~/.emacs

2)  Make a .xemacs directory and copy all files under dot_xemacs to it

Notes:
======

1)  This was created many years ago, inspired by work I did circa 1991 
    to map the PC function keys on Win3.1 using Hummingbird Exceed to 
    support Brief Editor-like key maps (note at the time with Emacs 18 
    I also had to hack the Emacs source to get it to work).  These were
    also updated to support Sun workstation keyboards.

2)  This version was started in 1993 and included syntax highlighting.
    Additional changes were made based on the Linux Journal article 
    in Issue 5, Page 10.

3)  This was created to support both Emacs and Xemacs.  For years I 
    used only Xemacs, but with current Fedora/CentOS/Ubuntu the newer 
    Emacs is fantastic and that is all I use, hence recent changes have
    not been tested with Xemacs.

4)  The .emacs file is a stub directing to the .xemacs directory's
    init.el file:

    	    .emacs  --redirect-->  .xemacs/init.el

5)  In 2015, I added the go-mode from: https://github.com/dominikh/go-mode.el
    This is included with some mods.  Note, you may want to get the
    latest version.

6)  Customize colors in init.el lines like:

      (set-face-foreground 'font-lock-comment-face "darkred")


File Types Supported:
=====================

     .c         c-mode
     .cc        c-mode
     .cxx       c++-mode
     .cpp       c++-mode
     .ino       c++-mode
     .CPP       c++-mode
     .C         c++-mode
     .hpp       c++-mode
     .HPP       c++-mode
     .h         c-mode
     .H         c-mode
     .tex       TeX-mode
     .txi       Texinfo-mode
     .el        emacs-lisp-mode
     .php       php-mode
     .py        python-mode
     .pl        perl-mode
     .pm        perl-mode
     .m         octave-mode
     .spec      rpm-spec-mode
     .spec-in   rpm-spec-mode
     .html      html-mode
     .htm       html-mode
     .java      java-mode
     .go        go-mode

Key Mappings:
=============
  
* Sun Function Keys (beyond F12):  see init.el (very old, no longer tested)
* PC Function (F1..F12) keys
* PC Keypad:
* Home, End, Page Up, Page Down

PC Function Keys and Keypad:
============================

     F1	        1 window
     F2         split vertically
     F3         split horizontally
     f4         find file (open file)
     F5         search for string
     F6/F7/F8   start/end/run keyboard macro (sequence of steps)
     F9         go to line
     F10        set mark
     F11        toggle between overwrite and insert
     F12        info
     KP /       delete line 
     KP *       undo
     KP +       copy region (copies to buffer)
     KP -       kill region (copies to buffer)
     KP enter   set mark
     KP ins     paste copied region (pastes buffer)
     Home	start of line
     End	end of line
     PgUp	one page up
     PgDn	one page down

