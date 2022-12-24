$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-10-20 10:01:14.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$! GP1LVF.COM  718.1X0.0700
$! Compiling and building the GP1 VMS- FORTRAN on line plotterlibrary
$!
$ FORTRAN CHAR.FOR
$ FORTRAN CHDIS.FOR
$ FORTRAN CIRCLE.FOR
$ FORTRAN CLRWIN.FOR
$ FORTRAN FACTOR.FOR
$ FORTRAN GPINIT.FOR
$ FORTRAN GPSTAT.FOR
$ FORTRAN IROUND.FOR
$ FORTRAN LINE.FOR
$ FORTRAN LINRAT.FOR
$ FORTRAN LINSCL.FOR
$ FORTRAN LINSET.FOR
$ FORTRAN LINSRO.FOR
$ FORTRAN LINSYM.FOR
$ FORTRAN LOCAL.FOR
$ FORTRAN MESSAG.FOR
$ FORTRAN NEWIND.FOR
$ FORTRAN NEWORG.FOR
$ FORTRAN NUMBER.FOR
$ FORTRAN ORIWIN.FOR
$ FORTRAN PENCHA.FOR
$ FORTRAN PENMOV.FOR
$ FORTRAN PLOT.FOR
$ FORTRAN PLTEND.FOR
$ FORTRAN PUTIN.FOR
$ FORTRAN REMOTE.FOR
$ FORTRAN RESET.FOR
$ FORTRAN SCALE.FOR
$ FORTRAN SENDGP.FOR
$ FORTRAN SETORG.FOR
$ FORTRAN SETPAR.FOR
$ FORTRAN SPEED.FOR
$ FORTRAN SPIRAL.FOR
$ FORTRAN SPLINE.FOR
$ FORTRAN STROT.FOR
$ FORTRAN STRSCL.FOR
$ FORTRAN STRSEL.FOR
$ FORTRAN STRSET.FOR
$ FORTRAN STRSLN.FOR
$ FORTRAN SYMBOL.FOR
$ FORTRAN SYMDEF.FOR
$ FORTRAN SYROTA.FOR
$ FORTRAN SYSCAL.FOR
$ FORTRAN SYSET.FOR
$ FORTRAN SYSTOR.FOR
$ FORTRAN TKREI.FOR
$ FORTRAN TXTYP.FOR
$ FORTRAN VECTOR.FOR
$ FORTRAN WHERE.FOR
$ FORTRAN WHERED.FOR
$ FORTRAN GPFPUS.FOR
$ FORTRAN GPFFIL.FOR
$ FORTRAN GPFDIA.FOR
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
