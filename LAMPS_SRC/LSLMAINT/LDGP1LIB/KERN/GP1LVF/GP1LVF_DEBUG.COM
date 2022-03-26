$! GP1LVF.COM  718.1X0.0700
$! Compiling and building the GP1 VMS- fortran/debug/noopt on line plotterlibrary
$!
$ fortran/debug/noopt CHAR.FOR
$ fortran/debug/noopt CHDIS.FOR
$ fortran/debug/noopt CIRCLE.FOR
$ fortran/debug/noopt CLRWIN.FOR
$ fortran/debug/noopt FACTOR.FOR
$ fortran/debug/noopt GPINIT.FOR
$ fortran/debug/noopt GPSTAT.FOR
$ fortran/debug/noopt IROUND.FOR
$ fortran/debug/noopt LINE.FOR
$ fortran/debug/noopt LINRAT.FOR
$ fortran/debug/noopt LINSCL.FOR
$ fortran/debug/noopt LINSET.FOR
$ fortran/debug/noopt LINSRO.FOR
$ fortran/debug/noopt LINSYM.FOR
$ fortran/debug/noopt LOCAL.FOR
$ fortran/debug/noopt MESSAG.FOR
$ fortran/debug/noopt NEWIND.FOR
$ fortran/debug/noopt NEWORG.FOR
$ fortran/debug/noopt NUMBER.FOR
$ fortran/debug/noopt ORIWIN.FOR
$ fortran/debug/noopt PENCHA.FOR
$ fortran/debug/noopt PENMOV.FOR
$ fortran/debug/noopt PLOT.FOR
$ fortran/debug/noopt PLTEND.FOR
$ fortran/debug/noopt PUTIN.FOR
$ fortran/debug/noopt REMOTE.FOR
$ fortran/debug/noopt RESET.FOR
$ fortran/debug/noopt SCALE.FOR
$ fortran/debug/noopt SENDGP.FOR
$ fortran/debug/noopt SETORG.FOR
$ fortran/debug/noopt SETPAR.FOR
$ fortran/debug/noopt SPEED.FOR
$ fortran/debug/noopt SPIRAL.FOR
$ fortran/debug/noopt SPLINE.FOR
$ fortran/debug/noopt STROT.FOR
$ fortran/debug/noopt STRSCL.FOR
$ fortran/debug/noopt STRSEL.FOR
$ fortran/debug/noopt STRSET.FOR
$ fortran/debug/noopt STRSLN.FOR
$ fortran/debug/noopt SYMBOL.FOR
$ fortran/debug/noopt SYMDEF.FOR
$ fortran/debug/noopt SYROTA.FOR
$ fortran/debug/noopt SYSCAL.FOR
$ fortran/debug/noopt SYSET.FOR
$ fortran/debug/noopt SYSTOR.FOR
$ fortran/debug/noopt TKREI.FOR
$ fortran/debug/noopt TXTYP.FOR
$ fortran/debug/noopt VECTOR.FOR
$ fortran/debug/noopt WHERE.FOR
$ fortran/debug/noopt WHERED.FOR
$ fortran/debug/noopt GPFPUS.FOR
$ fortran/debug/noopt GPFFIL.FOR
$ fortran/debug/noopt GPFDIA.FOR
$!
$LIBRARY/CREATE GP1LVF -
CHAR,-
CHDIS,-
CIRCLE,-
CLRWIN,-
FACTOR,-
GPINIT,-
GPSTAT,-
IROUND,-
LINE,-
LINRAT,-
LINSCL,-
LINSET,-
LINSRO,-
LINSYM,-
LOCAL,-
MESSAG,-
NEWIND,-
NEWORG,-
NUMBER,-
ORIWIN,-
PENCHA,-
PENMOV,-
PLOT,-
PLTEND,-
PUTIN,-
REMOTE,-
RESET,-
SCALE,-
SENDGP,-
SETORG,-
SETPAR,-
SPEED,-
SPIRAL,-
SPLINE,-
STROT,-
STRSCL,-
STRSEL,-
STRSET,-
STRSLN,-
SYMBOL,-
SYMDEF,-
SYROTA,-
SYSCAL,-
SYSET,-
SYSTOR,-
TKREI,-
TXTYP,-
VECTOR,-
WHERE,-
WHERED
$!
$LINK GPFPUS,GP1LVF/LIB
$LINK GPFFIL,GP1LVF/LIB
$LINK GPFDIA,GP1LVF/LIB
