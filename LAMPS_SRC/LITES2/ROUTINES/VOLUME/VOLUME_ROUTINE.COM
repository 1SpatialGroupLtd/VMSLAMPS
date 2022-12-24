$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-06-13 17:43:14.000000000 +0100
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
$	SET ON
$	ON ERROR THEN GOTO EXIT
$	SET VERIFY
$	LIBR/CREATE USRLIB
$	FORTRAN USRDO.F,USRINI
$	FORTRAN USRRET.F,USRSTO,USRGZS
$	FORTRAN USRPZS.F,USRDEF
$	FORTRAN DO_POLY.F,DO_PREP,DO_PROF,DO_VOL,DO_NEAR
$	FORTRAN SORT.F,FILL_ROTATE
$	LIBR/REPL USRLIB USRDO,USRINI,-
			USRRET,USRSTO,USRGZS,USRPZS,USRDEF,-
			DO_POLY,DO_PREP,DO_PROF,DO_VOL,DO_NEAR,-
			SORT,FILL_ROTATE
$	DELETE *.OBJ;*
$!
$! and link it
$	@USRLNK
$EXIT:
$	PURGE USR*.*
$	PURGE *.EXE
$	SET NOVER
