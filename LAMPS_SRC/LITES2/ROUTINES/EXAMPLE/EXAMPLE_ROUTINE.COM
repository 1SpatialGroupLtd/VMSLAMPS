$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-06-28 13:04:24.000000000 +0100
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
$	FORTRAN/NOOPT/DEBUG USRDO,USRERR,USRGAC,USRINI,USRPAC
$	FORTRAN/NOOPT/DEBUG USRRET,USRSTO,USRGCB,USRGTX
$	FORTRAN/NOOPT/DEBUG USRPCB,USRPTX,USRDEF
$	LIBR/REPL USRLIB USRDO,USRERR,USRGAC,USRINI,USRPAC,-
	                 USRRET,USRSTO,USRGCB,USRGTX,USRPCB,USRPTX,USRDEF
$	DELETE *.OBJ;*
$!
$! and link it
$	@USRLNK
$EXIT:
$	PURGE USR*.*
$	PURGE *.EXE
$	SET NOVER
