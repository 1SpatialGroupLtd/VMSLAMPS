$! This is a template command file for use as an initialisation file for the
$! DOCUMENT procedure. Copy it, tailor it as you want, and then assign the
$! logical name LSL$DOC_INITIALISE to point to it.
$!
$! This command file can set various global symbols, to alter the way that
$! DOCUMENT works. This is equivalent to using the OPTIONS option as soon
$! as you enter DOCUMENT. The symbols that you can set, and their default
$! values, are:
$!
$!	DOC$EDITOR	== "EDT/COMMAND=LSL$DOC_COMMAND:EDTINI.EDT"
$!	DOC$WIDTH	== 80
$!	DOC$SMOOTH	== TRUE			(TRUE and FALSE are
$!	DOC$NO_MENUS	== FALSE		 defined within DOC)
$!
$! DOC$EDITOR   is the editor command used by DOCUMENT to edit files
$! DOC$WIDTH    is the screen width used for menus, etc
$! DOC$SMOOTH   is TRUE if TYPEd text is to use smooth scrolling
$! DOC$NO_MENUS is TRUE if menus are not to be displayed
$!
$! So now set the ones that you want to override - don't forget to
$! use "==" to do the assignment!
$!
$	DOC$EDITOR == "EDIT/TPU"	! use the TPU editor instead
$	DOC$SMOOTH == FALSE		! always use JUMP scroll
$!
$	exit
