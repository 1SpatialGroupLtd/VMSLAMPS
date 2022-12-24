$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-05-12 12:00:46.000000000 +0100
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
$	set nover
$	if (P1.nes."")
$	then
$		WS "including the wrapper"
$		OPEN/write INIFILE tmp_init.EDT
$		WRITE INIFILE "include w."
$		WRITE INIFILE "exit"
$		CLOSE INIFILE
$		DEF/USER edtini "here:tmp_init.edt"
$		edt 'P1'.SRC
$!
$		WS "processing"
$		OPEN/write INIFILE tmp_init.EDT
$		WRITE INIFILE "SUBS/???/"'P1'"/:10000/NOTY"
$		WRITE INIFILE "FIND ""PROPER FUNCTION"""
$		WRITE INIFILE "SUBS/"'P1'"/ACTUAL_"'P1'"/:10000/NOTY
$		WRITE INIFILE "FIND ""***"""
$		WRITE INIFILE "INCLUDE ARGS."
$		WRITE INIFILE "exit"
$		CLOSE INIFILE
$		DEF/USER edtini "here:tmp_init.edt"
$		edt 'P1'.SRC
$!
$		DEF/USER SYS$INPUT SYS$COMMAND
$		edt 'P1'.SRC
$	ELSE
$		WS "NO FILE NAME SUPPLIED YOU FOOL!"
$	ENDIF
