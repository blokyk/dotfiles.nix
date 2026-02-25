{ lib, pkgs, ... }:
let
  nanorc-pkg = pkgs.callPackage ./nanorc-pkg.nix { };
  rc-format = import ./format.nix { inherit lib; };
in {
  home.packages = [ pkgs.nano ];
  home.sessionVariables.EDITOR = pkgs.nano;
  home.file.".nanorc".text = ''
    include "${nanorc-pkg}/share/*.nanorc"

    ## If <Tab> should always produce four spaces when editing a Python file,
    ## independent of the settings of 'tabsize' and 'tabstospaces':
    extendsyntax python tabgives "    "

    ## If <Tab> should always produce an actual TAB when editing a Makefile:
    extendsyntax makefile tabgives "	"

    ${rc-format.generate {
      theme = {
        ## Paint the interface elements of nano.  These are examples;
        ## by default there are no colors, except for errorcolor.
        title =    { fg = "brightwhite";   bg = "blue";   };
        status =   { fg = "brightwhite";   bg = "blue";   };
        error =    { fg = "brightwhite";   bg = "red";    };
        selected = { fg = "brightwhite";   bg = "cyan";   };
        stripe =   {                       bg = "yellow"; };
        number =   { fg = "brightmagenta";                };
        key =      { fg = "brightgreen";                  };
        function = { fg = "brightyellow";                 };
      };

      settings = {
        # Make the 'nextword' function (Ctrl+Right) stop at word ends
        # instead of at beginnings.
        afterends = true;

        # Automatically indent a newly created line to the same number of
        # tabs and/or spaces as the preceding line -- or as the next line
        # if the preceding line is the beginning of a paragraph.
        autoindent = false; # `autoindent` messes with system copy-paste :(

        # Constantly display the cursor position in the status bar.  Note that
        # this overrides "quickblank".
        constantshow = true;

        # Remember the used search/replace strings for the next session.
        historylog = true;

        # Display line numbers to the left of the text.
        linenumbers = true;

        # Enable mouse support, if available for your system.  When enabled,
        # mouse clicks can be used to place the cursor, the = true; mark (with a
        # double click), and execute shortcuts.  The mouse will work in the X
        # Window System, and on the console when gpm is running.
        mouse = true;

        # Switch on multiple file buffers (inserting a file will put it into
        # a separate buffer).
        multibuffer = true;

        # Don't automatically add a newline when a file does not end with one.
        nonewlines = true;

        # Make the Home key smarter.  When Home is pressed anywhere but at the
        # very beginning of non-whitespace characters on a line, the cursor
        # will jump to that beginning (either forwards or backwards).  If the
        # cursor is already at that position, it will jump to the true
        # beginning of the line.
        smarthome = true;

        # Enable soft line wrapping (AKA full-line display).
        softwrap = true;

        # Use this spelling checker instead of the internal one.
        # This option does not have a default value.
        speller = "${pkgs.aspell} -x -c";

        # Use this tab size instead of the default; it must be greater than 0.
        tabsize = 4;

        # Convert typed tabs to spaces.
        tabstospaces = true;

        # Snip whitespace at the end of lines when justifying or hard-wrapping.
        trimblanks = true;

        # Let an unmodified Backspace or Delete erase the marked region (instead
        # of a single character, and without affecting the cutbuffer).
        zap = true;
      };

      keybindings = {
        # Key bindings.
        # See nanorc(5) (section REBINDING KEYS) for more details on this.

        all = {
          "M-H" = "help";
          "^F" = "whereis";
          "^G" = "findnext";
          "^V" = "paste";
        };

        help."M-H" = "exit";

        main = {
          "^S" = "savefile";
          "^C" = "copy";
          "^X" = "cut";
          "^Z" = "undo";
          "^E" = "redo";

          "^O" = "insert";
          "M-C" = "comment";

          # fixes pasting into nano
          "^J" = "enter";

          # The <Ctrl+Delete> keystroke deletes the word to the right of the cursor.
          # On some terminals the <Ctrl+Backspace> keystroke produces ^H, which is
          # the ASCII character for backspace, so it is bound by default to the
          # backspace function.  The <Backspace> key itself produces a different
          # keycode, which is hard-bound to the backspace function.  So, if you
          # normally use <Backspace> for backspacing and not ^H, you can make
          # <Ctrl+Backspace> delete the word to the left of the cursor with:
          "^H" = "chopwordleft";
        };
      };
    }}
    '';
}
